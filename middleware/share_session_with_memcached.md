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

And that's all, from now on we'll be storing the users sessions in our local
memcached server (`localhost:11211`) and the `rack:session` namespace. If you
want to change these settings, use the middleware like this:

```ruby
configure do
  use Rack::Session::Dalli,
    memcache_server: 'example.com:11211',
    namespace: 'other.namespace'
    cache: Dalli::Client.new
end
```

If you need more info, refer to the [dalli gem documentation](https://github.com/mperham/dalli).
