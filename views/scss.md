Scss Templates
--------------

The sass gem/library is required to render Scss templates:

    ## You'll need to require haml or sass in your app
    require 'sass'

    get '/stylesheet.css' do
      scss :stylesheet
    end

Renders `./views/stylesheet.scss`.

[Scss' options](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#options)
can be set globally through Sinatra's configurations,
see [Options and Configurations](#configuration),
and overridden on an individual basis.

    set :scss, :style => :compact # default Scss style is :nested

    get '/stylesheet.css' do
      scss :stylesheet, :style => :expanded # overridden
    end


