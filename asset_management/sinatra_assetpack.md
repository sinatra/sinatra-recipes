# Sinatra-Assetpack

Install the gem using:

```
gem install sinatra-assetpack
```

and require it in your app file:

```ruby
require 'sinatra/base'
require 'sinatra/assetpack'

class App < Sinatra::Base
  register Sinatra::AssetPack
  assets do
    # read on
  end

  # Rest of your app
end
```

## Generic Structure

__Defaults__

If you do not use any CSS dev tools such as Compass or Foundation, and have a
simple app structure that you generate on a per-project basis, there are
certain defaults added to `Sinatra::Assetpack`. By default, the gem assumes
your asset files are located under a folder called "app" in your app's root
directory.

This is the default structure which when used, makes it possible to use the
gem with almost zero configuration.

```
app
  |- js/
       |- jquery.js
       |- app.js
  |- css/
       |- jqueryui.css
       |- reset.css
       |- foundation.sass
       |- app.sass
myapp.rb
```

Some points of note:

* There is no need to stick to this structure. The filepaths can be
configured in `sinatra-assetpack` in case you need it.
* There is no need for the `public` folder which is the default asset
look-up path for Sinatra.
* The `.sass` files go into the `css` directory. The conversion will be
handled by `sinatra-assetpack` automatically. You just need the `sass` gem
installed and loaded using `require 'sass'`.

Inside the `myapp.rb` file, inside the `assets do .. end` block,
the paths to the files need to be specified:

```ruby
assets do

  js :application, [
    '/js/jquery.js',
    '/js/app.js'
    # You can also do this: 'js/*.js'
  ]

  css :application, [
    '/css/jqueryui.css',
    '/css/reset.css',
    '/css/foundation.css',
    '/css/app.css'
   ]

  js_compression :jsmin
  css_compression :sass

end
```

Note that while listing out the CSS files in the `css :application`
block, the extension remains `.css` even though the source file is a
`SASS` file. `Sinatra::Assetpack` understands the extension and
converts the file automatically.

The symbol that is sent to the `js` and `css` methods becomes the access
helper in your views. You can use those helpers like so:

```erb
<%= css :application %>
<%= js :application %>
```
Which gets expanded to:

```html
<link rel="stylesheet" href="/css/application.css"/>
<script src="/js/application.js" type="text/javascript"></script>
```

That is it!

## Custom structure

__Level 2__

In case you have a different app directory structure, say:

```
assets
  |- javascripts/
       |- jquery.js
       |- app.js
  |- stylesheets/
       |- jqueryui.css
       |- reset.css
       |- foundation.sass
       |- app.sass
myapp.rb
```

The `serve` method can be specified so that the folder from which the
assets gets served from may be explained to the gem.

```ruby
  assets do

    serve '/js', :from => 'assets/javascripts'
    js :application, [
      '/js/jquery.js',
      '/js/app.js'
      # You can also do this: 'js/*.js'
    ]

    serve '/css', :from => 'assets/stylesheets'
    css :application, [
      '/css/jqueryui.css',
      '/css/reset.css',
      '/css/foundation.css',
      '/css/app.css'
     ]

    js_compression :jsmin
    css_compression :sass
  end
```

And everything else remains the same.

## Foundation framework + Compass

__Level Awesome__

The previous sections dealt with limited number of assets. What if
you have vendor assets that need to be served in a particular order?

__This document reflects the usage of Foundation 5.__

This section deals with using the foundation framework with
`sinatra-assetpack`. The example also uses the `compass` gem to start a
project with the `Zurb-Foundation` framework.
A sample project is available at
[sinatra_assetpack_foundation_sample](https://github.com/kgrz/sinatra_assetpack_foundation_sample)


```
gem install foundation
gem install compass
```

Install the `npm` modules of `bower` and `grunt-cli`. The instructions
are provided [here](http://foundation.zurb.com/docs/sass.html). Then
run:

    foundation new <project name>

This will create a project with the following structure:

```
bower_components/
 |---- jquery/
 |---- modernizr/
 |---- ...some more libraries ...
js/
 |---- app.js
scss/
 |---- _settings.scss
 |---- app.scss
stylesheets/
 |---- app.css
config.rb
index.html
bower.json
```

In this app, the `.sass`/`.scss` to `.css` conversion is handled by running
`compass watch` which compiles the `.scss` files whenever it detects a
change. Note that as of Sinatra-Assetpack version `0.3.2`, any URL
element inside a css file will cause the processor to crash and
Foundation 5 uses one such declaration. So, for this example, we will
ignore the management of CSS files via Sinatra-Assetpack and load it
directly from the app. To do this, the compass app needs to output the
compiled CSS into a `public/stylesheets` folder. Let's ensure that's
done by creating a `public` directory and changing the `config.rb`
settings to the following:


```ruby
# config.rb
add_import_path "bower_components/foundation/scss" # unchanged

http_path = "/"                                    # unchanged
css_dir = "public/stylesheets"
sass_dir = "scss"                                  # unchanged
images_dir = "images"                              # unchanged
javascripts_dir = "js"                             # unchanged
```

Now, when we run `compass watch`, the compiled `app.css` will be placed
in the `public/stylesheets` directory. That minor change completed, we
need to load the app-related JavaScript files from the `js` folder. We
also need to require the libraries in the `bower_components` folder.
More specifically, we will use the following files:

1. `bower_components/jquery/dist/jquery.js`
2. `bower_components/foundation/js/foundation.js`
3. `bower_components/modernizr/modernizr.js`

The aim would be to recreate the structure of `index.html` in the
foundation app folder with Sinatra and a `layout.erb` file

Inside our `app.rb`, this would be the structure:

```ruby
assets do
  serve '/js', from: 'js'
  serve '/bower_components', from: 'bower_components'

  js :modernizr, [
    '/bower_components/modernizr/modernizr.js',
  ]

  js :libs, [
    '/bower_components/jquery/dist/jquery.js',
    '/bower_components/foundation/js/foundation.js'
  ]

  js :application, [
    '/js/app.js'
  ]

  js_compression :jsmin
end
```

Inside the `views/layout.erb`:

```erb
<!DOCTYPE html>
<!--[if IE 9]><html class="lt-ie10" lang="en" > <![endif]-->
<html class="no-js" lang="en" >

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My App</title>
  <link rel="stylesheet" href="/stylesheets/app.css"/>

  <%= js :modernizr %>
</head>
<body>
  <%= yield %>

  <%= js :libs %>
  <%= js :application %>
</body>
</html>
```

And you're set!

## Merging

If you have tried the code samples, you might've observed that the files are
not getting merged before they are sent to the browser. This is true and
happens only in development mode. Change it to production:

```
export RACK_ENV="production"
```

Voila! Now you should see only three asset files being loaded viz.,
"application.css", "application.js" and "foundation.js".

## Pre-compilation

Up until now, the concatenation, compression are done after a request
reaches the server for the first time. This step is done only once for the
first request. However, if you need to pre-generate the compressed and
concatenated assets, you can use the rake task provided in the gem:

Create a `Rakefile` in your app directory with the following contents:

```ruby
APP_FILE  = 'app.rb'
APP_CLASS = 'Sinatra::Application'

require 'sinatra/assetpack/rake'
```

And run `rake assetpack:build` to generate the assets which automatically
get stored in a `public` directory.

## Resources

* [Sinatra-Assetpack](https://github.com/rstacruz/sinatra-assetpack)
* [Foundation Framework](http://foundation.zurb.com/docs/index.html)
* [Compass Framework](http://compass-style.org/)
