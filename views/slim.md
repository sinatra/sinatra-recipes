Slim Templates
--------------

The `slim` gem/library is required to render Slim templates:

    # You'll need to require slim in your app
    require 'slim'

    get '/' do
      slim :index
    end

Renders `./views/index.slim`.


