# How to share a session with Memcached?

Suppose that you are developing a Sinatra app that will be deployed to multiple
server instances and must be seen as a single application (it must be balanced
with nginx, for instance). You need a mechanism for sharing user sessions
between all the application instances. To accomplish this task, we'll use
memcached for sharing the session and [Dalli](https://github.com/mperham/dalli)
as the memcached client.

First, add `dalli` to your `Gemfile`:

```ruby
gem 'dalli'
```

Then, add the `Rack::Session::Dalli` middleware:

```ruby
configure do
  use Rack::Session::Dalli, cache: Dalli::Client.new
end
```

`Dalli::Client` defaults the memcache server url to `localhost:11211`. If you
need to use another server, you must configure it yourself.

See a full example configuring the memcache server and the session namespace:

```ruby
configure do
  use Rack::Session::Dalli,
    namespace: 'other.namespace'
    cache: Dalli::Client.new('example.com:11211')
end
```

## More Info

Refer to [Rack::Session](http://rack.rubyforge.org/doc/Rack/Session.html)
documentation to know more about rack sessions.
Refer to [Dalli](https://github.com/mperham/dalli) documentation to know more
about Rack::Session::Dalli.
