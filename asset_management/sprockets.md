
## Sprockets

Sprockets is a Ruby library for compiling and serving web assets.
It features declarative dependency management for JavaScript and CSS assets,
as well as a powerful preprocessor pipeline that allows you to write
assets in languages like CoffeeScript, Sass and SCSS.

One way of handling assets in Sinatra is to use Sprockets.

First install sprockets:

```
gem install sprockets
```

or add sprockets gem to your Gemfile:

```
gem 'sprockets'
```

and run `bundle` .

You will need an instance of the Sprockets::Environment class
to access and serve assets from your application:

```
environment = Sprockets::Environment.new
```

and append all desired assets paths:

```
environment.append_path "assets/stylesheets"
environment.append_path "assets/javascripts"
```

A good way to do this is with the map method in `config.ru` .
But you could also set it in you main application file
or add [sinatra extension](http://www.sinatrarb.com/extensions.html).

The Sprockets Environment has methods for retrieving and serving assets,
manipulating the load path, and registering processors. It is also a Rack
application that can be mounted at a URL to serve assets over HTTP.

Now you can keep your files under defined directories:

```
app
├── Gemfile
├── app.rb
├── assets
│   ├── javascripts
│   │   ├── app.js
│   │   ├── articles.coffee
│   │   └── jquery.js
│   └── stylesheets
│       └── app.scss
└── views
    ├── index.erb
    └── layout.erb
```

If you would like to compress your assets
use compressor of your choice:

```
environment.js_compressor  = :uglify
environment.css_compressor = :scss
```

Don't forget to add uglifier and sass gems to your Gemfile.

Example minifiers and required gems:
* `:sass` (gem 'sass')
* `:yui` (gem 'yui-compressor')
* `:closure` (gem 'closure-compiler')
* `:jsmin` (gem 'jsmin')
* `:uglifier` (gem 'uglifier')

Update your layout file:

```html
<!-- app/views/layout.erb -->

<head>
  ...
  <link rel="stylesheet" href="assets/app.css">
  <script src="assets/app.js"></script>
</head>
```

Note that you need to add only core files `app.js` and `app.css`. These very files will be compiled by the Sprockets gem.

If you would like to use asset_path helpers
check [sprocket helpers][sprockets_helpers] gem.

### Javascript Assets

Sprockets allows you to use various directives:

```js
// app/assets/javascripts/app.js

//= require_tree .
```

It will require all files alphabetically.
But if you would like to add files individually remove `require_tree .`
and add each file:

```js
// app/assets/javascripts/app.js

//= require jquery
//= require articles
```

### CSS Assets

Adding CSS files works identically, but in the respective CSS configuration file.

```css
// app/assets/stylesheets/app.css

//= require bootstrap.css
```

### Options

Asset source files can be written in another format, like SCSS or
CoffeeScript, and automatically compiled to CSS or JavaScript by Sprockets.

Sprockets directives can begin with `//=` , `#=` or `/*= */` .

Available directives: `require`, `require_self`, `require_tree`,
`require_directory`, `depend`, `depend_on_asset`, `stub`, `link`,
`link_directory`, `link_tree` .

Summing up, your main application file may look like this:

```ruby
# app/app.rb

# install and require all dependencies
require 'sinatra/base'
require 'sprockets'
require 'uglifier'
require 'sass'
require 'coffee-script'
require 'execjs'

class MyApp < Sinatra::Base
  # initialize new sprockets environment
  set :environment, Sprockets::Environment.new

  # append assets paths
  environment.append_path "assets/stylesheets"
  environment.append_path "assets/javascripts"

  # compress assets
  environment.js_compressor  = :uglify
  environment.css_compressor = :scss

  # get assets
  get "/assets/*" do
    env["PATH_INFO"].sub!("/assets", "")
    settings.environment.call(env)
  end

  get "/" do
    erb :index
  end
end
```

```ruby
# app/config.ru

require './app'

run MyApp.new
```

## Resources

For more information visit:

* [Sprockets](https://github.com/rails/sprockets)
* [Sprocket Helpers][sprockets_helpers]
* [About assets management](http://recipes.sinatrarb.com/p/asset_management/why-asset-management)


[sprockets_helpers]: https://github.com/petebrowne/sprockets-helpers
