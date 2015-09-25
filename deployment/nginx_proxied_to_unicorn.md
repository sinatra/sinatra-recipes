# Nginx Proxied to Unicorn

Nginx and Unicorn combine to provide a very powerful setup for deploying your
Sinatra applications. This guide will show you how to effectively setup this
combination for deployment.

## Installation

First thing you will need to do is get nginx installed on your system. This
should be handled by your operating systems package manager.

For more information on installing nginx, check [the official
docs](http://wiki.nginx.org/Install).

Once you have nginx installed, you can install unicorn with rubygems:

```
gem install unicorn
```

Now that's done we can setup a basic Rack application in Sinatra.

## The Example Application

To start our example application, let's first create a `config.ru` in our
application root.

```ruby
require "rubygems"
require "sinatra"

require File.expand_path '../myapp.rb', __FILE__

run MyApp
```

Let's now use the `myapp.rb` that we specified in our Rack config file as our
Sinatra application.

```ruby
require "rubygems"
require "sinatra/base"

class MyApp < Sinatra::Base

  get '/' do
    'Hello, nginx and unicorn!'
  end

end
```

Now that we have our application in place, let's get on to configuring our
proxy.

## Configuration

So if you've made it this far you should have a Sinatra application ready with
nginx and unicorn installed. You're ready to move on to configuring the web
server.

**Unicorn**

Configuring unicorn is really easy and provides an easy to use Ruby DSL for
doing so. In our application's root we'll first need to make a couple
directories, if you haven't already:

```
mkdir tmp
mkdir tmp/sockets
mkdir tmp/pids
mkdir log
```

Once those are in place, we're ready to setup our `unicorn.rb` configuration.

```ruby
# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "/path/to/app/"

worker_processes 2
working_directory @dir

timeout 30

# Specify path to socket unicorn listens to,
# we will use this in our nginx.conf later
listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

# Set process id path
pid "#{@dir}tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"
```

As you can see, unicorn is extremely simple to setup. Let's move onto nginx
now, soon enough you'll be well on your way to serving up all kinds of great
Rack applications!

**nginx**

Nginx is a little more difficult to configure than unicorn, but still a fairly
straightforward process.

In this example we'll be putting all of our configuration in the
`nginx.conf` file of our nginx installation. You could alternatively separate
some of the configuration out into `sites-enabled` and other nginx conventions.
However, for most common and simple implementations this guide should do the
trick.

```bash
# this sets the user nginx will run as,
#and the number of worker processes
user nobody nogroup;
worker_processes  1;

# setup where nginx will log errors to
# and where the nginx process id resides
error_log  /var/log/nginx/error.log;
pid        /var/run/nginx.pid;

events {
  worker_connections  1024;
  # set to on if you have more than 1 worker_processes
  accept_mutex off;
}

http {
  include       /etc/nginx/mime.types;

  default_type application/octet-stream;
  access_log /tmp/nginx.access.log combined;

  # use the kernel sendfile
  sendfile        on;
  # prepend http headers before sendfile()
  tcp_nopush     on;

  keepalive_timeout  5;
  tcp_nodelay        on;

  gzip  on;
  gzip_vary on;
  gzip_min_length 500;

  gzip_disable "MSIE [1-6]\.(?!.*SV1)";
  gzip_types text/plain text/xml text/css
     text/comma-separated-values
     text/javascript application/x-javascript
     application/atom+xml image/x-icon;

  # use the socket we configured in our unicorn.rb
  upstream unicorn_server {
    server unix:/path/to/app/tmp/sockets/unicorn.sock
        fail_timeout=0;
  }

  # configure the virtual host
  server {
    # replace with your domain name
    server_name my-sinatra-app.com;
    # replace this with your static Sinatra app files, root + public
    root /path/to/app/public;
    # port to listen for requests on
    listen 80;
    # maximum accepted body size of client request
    client_max_body_size 4G;
    # the server will close connections after this time
    keepalive_timeout 5;

    location / {
      try_files $uri @app;
    }

    location @app {
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_redirect off;
      # pass to the upstream unicorn server mentioned above
      proxy_pass http://unicorn_server;
    }
  }
}
```

Once you replace `path/to/app` with the location to your Sinatra application,
you should be able now start your application and web server.

## Starting the server

First thing you will need to do is boot up the unicorn processes:

```bash
unicorn -c path/to/unicorn.rb -E development -D
```

It's important to note the flags here, `-c` is path to your unicorn
configuration. `-E` is the Rack environment for your application to run under
and `-D` will daemonize the process.

Lastly, let's start up nginx. On most debian-based systems you can use the
following command:

```bash
/etc/init.d/nginx start
```

However, you should check with your distribution as to where the nginx daemon
resides.

Now you should have successfully deployed your Sinatra application on nginx and
unicorn.

### Stopping the server

So now that you're using nginx and unicorn, at some point you might end up
asking yourself: How do I stop this thing?

Remember that pids folder we created earlier? Well in there is the pid for the
`master` unicorn process, so let's try to use that first:

```bash
cat /path/to/app/tmp/pids/unicorn.pid | xargs kill -QUIT
```

What we're doing is getting the PID from the pidfile created with Unicorn
started and then asking the OS to stop the process. We use the QUIT signal which
lets Unicorn shutdown gracefully, but waiting for its workers to finish.

If that doesn't work though, you might want to try:

```bash
$ ps -ax | grep unicorn
```

This will output the processes running unicorn, in the first column should be
the process id (pid). In order to stop unicorn in it's tracks:

```bash
kill -9 <PID>
```

There should be a `master` process which once that is killed, the
workers should follow. Feel free to search the processes again to make sure
they've all stopped before restarting.

`kill -9` sends an KILL signal to the Unicorns and guarantees (usually) that
they'll be stopped, but it means that Unicorn might not clean up after itself
properly so you should have a check and run the following just to be sure:

```bash
rm /path/to/app/tmp/sockets/unicorn.socket
rm /path/to/app/tmp/pids/unicorn.pid
```

To stop nginx you can use a similar technique as above, or if you've got the
nginx init scripts installed on any debian-based system use:

```bash
sudo /etc/init.d/nginx stop
```

That should wrap things up for deploying nginx and unicorn, for more
information on stopping the server look into `man ps` and `man kill`.

### Resources

*   [unicorn source on GitHub](http://github.com/defunkt/unicorn)
*   [original unicorn announcement](http://github.com/blog/517-unicorn)
*   [official unicorn homepage](http://unicorn.bogomips.org/)
*   [unicorn rdoc](http://rdoc.info/gems/unicorn/2.0.0/frames)
*   [nginx official homepage](http://nginx.org/)
*   [nginx wiki](http://wiki.nginx.org/Main)
