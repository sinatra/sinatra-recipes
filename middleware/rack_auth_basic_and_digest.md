# Rack::Auth Basic and Digest

You can easily protect your Sinatra application using HTTP
[Basic][httpbasic] and [Digest][httpdigest] Authentication with the
help of Rack middlewares.

## Protect the whole application

These examples show how to protect the whole application (all routes).

### HTTP Basic Authentication

For classic applications:

```ruby
#main.rb

require 'sinatra'

use Rack::Auth::Basic, "Protected Area" do |username, password|
  username == 'foo' && password == 'bar'
end

get '/' do
  "secret"
end

get '/another' do
  "another secret"
end
```

For modular applications:

```ruby
#main.rb

require 'sinatra/base'

class Protected < Sinatra::Base

  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'foo' && password == 'bar'
  end

  get '/' do
    "secret"
  end

end

Protected.run!
```

To try these examples just run `ruby main.rb -p 4567` and visit
[http://localhost:4567][localhost]

### HTTP Digest Authentication

To use digest authentication with current versions of Rack a
`config.ru` file is needed.

For classic applications:

```ruby
#main.rb

require 'sinatra'

get '/' do
  "secret"
end
```

```ruby
#config.ru

require File.expand_path '../main.rb', __FILE__

app = Rack::Auth::Digest::MD5.new(Sinatra::Application) do |username|
  # Return the password for the given user
  {'john' => 'johnsecret'}[username]
end

app.realm = 'Protected Area'
app.opaque = 'secretkey'

run app
```

For modular applications:

```ruby
#main.rb

require 'sinatra/base'

class Protected < Sinatra::Base

  get '/' do
    "secret"
  end

  def self.new(*)
    app = Rack::Auth::Digest::MD5.new(super) do |username|
      {'foo' => 'bar'}[username]
    end
    app.realm = 'Protected Area'
    app.opaque = 'secretkey'
    app
  end
end
```

```ruby
#config.ru

require File.expand_path '../main.rb', __FILE__

run Protected
```

To try these examples just run `rackup -p 4567` and visit
[http://localhost:4567][localhost]

## Protect specific routes

If you want to protect just specific routes things get a bit complicated. There
are many ways to do it. The one I show here uses [modular applications][modular]
and a `config.ru` file.

### HTTP Basic Authentication

First the `main.rb`

```ruby
#main.rb

require 'sinatra/base'

class Protected < Sinatra::Base

  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'foo' && password == 'bar'
  end

  get '/' do
    "secret"
  end

  get '/another' do
    "another secret"
  end

end

class Public < Sinatra::Base

  get '/' do
    "public"
  end

end
```

And the `config.ru`

```ruby
#config.ru

require File.expand_path '../main.rb', __FILE__

run Rack::URLMap.new({
  "/" => Public,
  "/protected" => Protected
})
```

To try these examples just run `rackup -p 4567` and visit
[http://localhost:4567][localhost]

The resulting routes are explained at the bottom of this page.

### HTTP Digest Authentication

First the `main.rb`

```ruby
#main.rb

require 'sinatra/base'

class Protected < Sinatra::Base

  get '/' do
    "secret"
  end

  get '/another' do
    "another secret"
  end

  def self.new(*)
    app = Rack::Auth::Digest::MD5.new(super) do |username|
      {'foo' => 'bar'}[username]
    end
    app.realm = 'Protected Area'
    app.opaque = 'secretkey'
    app
  end
end

class Public < Sinatra::Base

  get '/' do
    "public"
  end

end
```

And the `config.ru`

```ruby
#config.ru

require File.expand_path '../main.rb', __FILE__

run Rack::URLMap.new({
  "/" => Public,
  "/protected" => Protected
})
```

To try these examples just run `rackup -p 4567` and visit
[http://localhost:4567][localhost]

## The resulting routes

The routes display the following:

* `/` displays "public"
* `/protected` displays "secret"
* `/protected/another` displays "another secret"

All the protected routes are mounted at `/protected` so if you add
another route to the Protected class like for example
`get '/foo' do...` it can be reached at `/protected/foo`. To
change it just modify the call to `Rack::URLMap.new...` to your likings.

[httpbasic]: http://en.wikipedia.org/wiki/Basic_access_authentication
[httpdigest]: http://en.wikipedia.org/wiki/Digest_access_authentication
[modular]: http://www.sinatrarb.com/intro.html#Serving%20a%20Modular%20Application
[localhost]: http://localhost:4567
