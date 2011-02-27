Sass
----

The sass gem/library is required to render Sass templates:

    ## You'll need to require sass in your app
    require 'sass'

    get '/' do
      sass :styles
    end

This will render `./views/styles.sass`

[Sass'
options](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#options) can
be set globally through Sinatra's configuration, see [Options and
Configurations](#configuration), and overridden on an individual basis.

    set :sass, :style => :compact # default Sass style is :nested

    get '/stylesheet.css' do
        sass :stylesheet, :style => :expanded # overridden
    end


