# Sinatra::Reloader

**NB: Some of this information is mirrored [here](http://www.sinatrarb.com/contrib/reloader.html).

Sinatra::Reloader is an extension that exists as part of the [Sinatra::Contrib
project](http://www.sinatrarb.com/contrib/). It allows for automatic server
reloading that is compatible with *nix, OSX, and Windows environments.

It is currently the only reloader that works in a Windows environment.

## Basic Setup for a Flat Application

0) Run `gem install sinatra-contrib` or add it to your Gemfile and run `bundle
install`.

At the top of your `app.rb` file, add `require 'sintra/reloader' if development?`.

```ruby
require 'sinatra'
require 'sinatra/reloader'

# ...
```

1) **(optional)** Call the `also_reload` or `dont_reload` methods to customize
your reload policy. More on this [below](#label-Customizing+the+Reload+Policy).

```ruby
require 'sinatra'
require 'sinatra/reloader'

also_reload './lib/model.rb'
dont_reload './path/to/some/file.ext'
# ...
```

## Basic Setup for a Modular Application

0) Run `gem install sinatra-contrib` or add it to your Gemfile and run `bundle
install`.

At the top of your `app.rb` file, add `require 'sintra/reloader'`.

1) Wrap your app in a class that inherits from `Sinatra::Base`.

```ruby
 class App < Sinatra::Base
  # ...
 end
```

2) Add a `configure` block for the development environment.

```ruby
 class App < Sinatra::Base
  configure :development do
    #...
  end
  # ...
 end
```

3) Register reloader

```ruby
 class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  # ...
 end
```

4) **(optional)** Add your models. **Note: you must include a file extension.
This portion of the recipe assumes you are using models and that they exist in a
`lib` folder. If your app structure is different, adjust accordingly.

```ruby
class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload "./lib/model.rb"
    dont_reload "./path/to/other/file.ext"
  end
  # ...
 end
```

## Customizing the Reload Policy Reloader provides two methods, `also_reload`
and `dont_reload`, which allow one to customize which files should or should not
be reloader. You can use these methods to improve the performance of your
development environment by minimizing or alternatively specifying the number of
files that are reloaded.

### Usage Both of these methods take a single argument, `path`, which is a
relative path from `app.rb`, and must specify a single file, including its
extenstion (**  NB: this is different than `require` syntax). Either method can
be called in any order, any number of times.

e.g.

 - `also_reload "/path/to/file.ext"`
 - `dont_reload "/path/to/file.ext"`

