# Sinatra::ConfigFile

`Sinatra::ConfigFile` is an extension provided by the
[sinatra-contrib](https://github.com/sinatra/sinatra-contrib) gem that allows
you to load the application's configuration from YAML files. It automatically
detects if the files contains specific environment settings and it will use the
corresponding to the current one.

Install it by running:

```bash
$ gem install sinatra-contrib
```

or with `bundler` (recommended):

```ruby
gem 'sinatra-contrib'
```

## Usage in classic style apps

Suppose that we store our configuration in `config/app.yml`:

```yaml
development:
  app:
    name: My Awesome Application [DEVELOPMENT]
production:
  app:
    name: My Awesome Application
```

Then we can access our configuration using `Sinatra::ConfigFile` through
`settings` within the app.

```ruby
require 'sinatra'
require 'sinatra/config_file'

configure do
  # Tell Sinatra::ConfigFile which config file we want to load:
  config_file 'config/app.yml'
end

get '/' do
  settings.app['name']
end
```

The output in development mode will be `My Awesome Application [DEVELOPMENT]`,
and in production mode will be `My Awesome Application`.

## Usage in modular style apps

Suppose that we have the same configuration file that the previous example.

```ruby
require 'sinatra/base'
require 'sinatra/config_file'

class MyApp < Sinatra::Base
  register Sinatra::ConfigFile

  configure do
    # Tell Sinatra::ConfigFile which config file we want to load:
    config_file 'config/app.yml'
  end

  get '/' do
    settings.app['name']
  end
end
```

As in the previous example, the output in development mode will be
`My Awesome Application [DEVELOPMENT]`, and in production mode will be
`My Awesome Application`.

## More information

For more information please look at the
[Sinatra::ConfigFile documentation](https://github.com/sinatra/sinatra-contrib/blob/master/lib/sinatra/config_file.rb).
