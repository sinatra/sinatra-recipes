# Rack::CommonLogger

Sinatra has [logging support](http://www.sinatrarb.com/intro.html#Logging), but
it's [nearly impossible to log to a file and to the
stdout](https://github.com/sinatra/sinatra/issues/484) (like Rails does).

However, there is a little trick you can use to log to stdout *and* to a file:

```ruby
require 'sinatra'

configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

get '/' do
  'Hello World'
end
```

You can use the same configuration for modular style applications, but you have
to `enable :logging` first:

```ruby
require 'sinatra/base'

class SomeApp < Sinatra::Base
  configure do
    enable :logging
    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end

  get '/' do
    'Hello World'
  end

  run!
end
```
