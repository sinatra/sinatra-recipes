# BetterErrors

[better_errors](https://github.com/charliesome/better_errors) is a Rack
middleware that replaces the standard error page with a more useful one. It
provides:

* Full stack trace
* Source code inspection for all stack frames (with highlighting)
* Local and instance variable inspection
* Live REPL on every stack frame

You can install it using the `gem` command:

```bash
gem install better_errors
```

or with `bundler` (recommended):

```ruby
group :development do
  gem 'better_errors'
  # uncomment this for more advanced features:
  # gem 'binding_of_caller'
end
```

Then, you can use it as follows:

```ruby
require 'sinatra'
require 'better_errors'

# Just in development!
configure :development do
  use BetterErrors::Middleware
  # you need to set the application root in order to abbreviate filenames
  # within the application:
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  raise 'Oops! See you at the better_errors error page!'
end
```

## More information

For more information please look at the
[better_errors README](https://github.com/charliesome/better_errors).
