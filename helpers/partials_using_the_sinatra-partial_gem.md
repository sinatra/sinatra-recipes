# Partials using the sinatra-partial gem

An alternative to define helpers for using partials is to use the
sinatra-partial gem.

Add the gem to your `Gemfile`:

```ruby
gem 'sinatra-partial', require: 'sinatra/partial'
```

Register the extension (you don't have to do this for classic style apps):

```ruby
class SomeApp < Sinatra::Base
  configure do
    register Sinatra::Partial
  end

  # ...
end
```

And enjoy!

```ruby
partial 'some_partial', template_engine: :erb
```

To avoid telling `partial` which template engine to use, you can configure it
globally:

```ruby
class SomeApp < Sinatra::Base
  configure do
    register Sinatra::Partial
    set :partial_template_engine, :erb
  end

  # ...
end
```

## More information

For more configuration options and usage, [view the sinatra-partial gem on
GitHub](https://github.com/yb66/Sinatra-Partial).
