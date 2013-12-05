# FastCGI

The standard method for deployment is to use Thin or Mongrel, and have a
reverse proxy (lighttpd, nginx, or even Apache) point to your bundle of servers.

But that isn't always possible. Cheaper shared hosting (like Dreamhost) won't
let you run Thin or Mongrel, or setup reverse proxies (at least on the default
shared plan).

Luckily, Rack supports various connectors, including CGI and FastCGI. Unluckily
for us, FastCGI doesn't quite work with the current Sinatra release without some
tweaking.

## Deployment with Sinatra version 0.9

From version 0.9.0 Sinatra requires Rack 0.9.1, however FastCGI wrapper from
this version seems not working well with Sinatra unless you define your
application as a subclass of Sinatra::Application class and run this
application directly as a Rack application.

Steps to deploy via FastCGI:

  * htaccess
  * subclass your application as Sinatra::Application
  * dispatch.fcgi

## .htaccess

```
RewriteEngine on

AddHandler fastcgi-script .fcgi
Options +FollowSymLinks +ExecCGI

RewriteRule ^(.*)$ dispatch.fcgi [QSA,L]
```

## Subclass your application as Sinatra::Application

```ruby
# my_sinatra_app.rb
class MySinatraApp < Sinatra::Application
  # your sinatra application definitions
end
```

## dispatch.fcgi - Run this application directly as a Rack application

```ruby
#!/usr/local/bin/ruby

require 'rubygems'
require 'rack'

fastcgi_log = File.open("fastcgi.log", "a")
STDOUT.reopen fastcgi_log
STDERR.reopen fastcgi_log
STDOUT.sync = true

module Rack
  class Request
    def path_info
      @env["REDIRECT_URL"].to_s
    end
    def path_info=(s)
      @env["REDIRECT_URL"] = s.to_s
    end
  end
end

load 'my\_sinatra\_app.rb'

builder = Rack::Builder.new do
  map '/' do
    run MySinatraApp.new
  end
end

Rack::Handler::FastCGI.run(builder)
```
