# Lighttpd Proxied to Thin

This will cover how to deploy Sinatra to a load balanced reverse
proxy setup using Lighttpd and Thin.

## Install Lighttpd and Thin

```bash
# Figure out lighttpd yourself, it should be handled by your
# linux distro's package manager

# For thin:
gem install thin
```

## Create your rackup file

The `require 'app'` line should require the actual Sinatra app you have written.

```ruby
## This is not needed for Thin > 1.0.0
ENV['RACK_ENV'] = "production"

require File.expand_path '../app.rb', __FILE__

run Sinatra::Application
```

## Setup a config.yml

Change the /path/to/my/app path to reflect reality.

```yaml
---
 environment: production
 chdir: /path/to/my/app
 address: 127.0.0.1
 user: root
 group: root
 port: 4567
 pid: /path/to/my/app/thin.pid
 rackup: /path/to/my/app/config.ru
 log: /path/to/my/app/thin.log
 max_conns: 1024
 timeout: 30
 max_persistent_conns: 512
 daemonize: true
```

## Setup lighttpd.conf

Change mydomain to reflect reality. Also make sure the first port
here matches up with the port setting in config.yml.

```conf
$HTTP["host"] =~ "(www\.)?mydomain\.com"  {
 proxy.balance = "fair"
 proxy.server =  ("/" =>
                   (
                     ( "host" => "127.0.0.1", "port" => 4567 ),
                     ( "host" => "127.0.0.1", "port" => 4568 )
                   )
                 )
}
```

## Start thin and your application.

I have a rake script so I can just call "rake start" rather than typing this in.

```bash
thin -s 2 -C config.yml -R config.ru start
```

You're done! Go to mydomain.com/ and see the result! Everything should be setup
now, check it out at the domain you setup in your lighttpd.conf file.

*Variation* - nginx via proxy - The same approach to proxying can be applied to
the nginx web server

```conf
upstream www_mydomain_com {
  server 127.0.0.1:5000;
  server 127.0.0.1:5001;
}

server {
  listen    www.mydomain.com:80;
  server_name  www.mydomain.com live;
  access_log /path/to/logfile.log;

  location / {
    proxy_pass http://www_mydomain_com;
  }

}
```

*Variation* - More Thin instances - To add more thin instances, change the
`-s 2` parameter on the thin start command to be how ever many servers you want.
Then be sure lighttpd proxies to all of them by adding more lines to the proxy
statements. Then restart lighttpd and everything should come up as expected.
