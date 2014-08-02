# Apache and Passenger (mod rails)

Hate deployment via FastCGI? You're not alone. But guess what, Passenger
supports Rack; and this book tells you how to get it all going.

You can find additional documentation at the [official modrails
website](http://modrails.com/documentation.html).

The easiest way to get started with Passenger is via the gem.

## Installation

First you will need to have [Apache
installed](http://httpd.apache.org/docs/2.2/install.html), then you can move
onto installing passenger and the apache passenger module.

You have a number of options when [installing phusion
passenger][passenger],
however the gem is likely the easiest way to get started.

```bash
gem install passenger
```

Once you've got that installed you can build the passenger apache module.

```bash
passenger-install-apache2-module
```

Follow the instructions given by the installer.

### Deploying your app

Passenger lets you easily deploy Sinatra apps through the Rack interface.

There are some assumptions made about your application, however, particularly
the `tmp` and `public` sub-directories of your application.

In order to fit these prerequisites, simply make sure you have the following
setup:

```bash
mkdir public
mkdir tmp
config.ru
```

The public directory is for serving static files and tmp directory is for the
`restart.txt` application restart mechanism. `config.ru` is where you will
place your rackup configuration.

**Rackup**

Once you have these directories in place, you can setup your applications
rackup file, `config.ru`.

```ruby
require 'rubygems'
require 'sinatra'
require File.expand_path '../app.rb', __FILE__

run Sinatra::Application
```

**Virtual Host**

Next thing you'll have to do is setup the [Apache Virtual
Host](http://httpd.apache.org/docs/2.2/vhosts/) for your app.

```bash
<VirtualHost *:80>
    ServerName www.yourapplication.com
    DocumentRoot /path/to/app/public
    <Directory /path/to/app/public>
        Require all granted
        Allow from all
        Options -MultiViews
    </Directory>
</VirtualHost>
```

That should just about do it for your basic apache and passenger configuration.
For more specific information please visit the [official modrails
documentation](http://modrails.com/documentation/Users%20guide%20Apache.html).

## A note about restarting the server

Once you've got everything configured it's time to [restart
Apache](http://httpd.apache.org/docs/2.2/stopping.html).

On most debian-based systems you should be able to:

```bash
sudo apache2ctl stop
# then
sudo apache2ctl start
```

To restart Apache. Check the link above for more detailed information.

In order to [restart the Passenger application][restart-passenger], all you need
to do is run this simple command for your application root:

```bash
touch tmp/restart.txt
```

You should be up and running now with [Phusion Passenger](http://modrails.com/)
and [Apache](http://httpd.apache.org/), if you run into any problems please
consult the official docs.

[passenger]: http://modrails.com/documentation/Users%20guide%20Apache.html#_installing_upgrading_and_uninstalling_phusion_passenger
[restart-passenger]: http://www.modrails.com/documentation/Users%20guide%20Apache.html#_redeploying_restarting_the_ruby_on_rails_application
