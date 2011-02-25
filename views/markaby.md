Markaby Templates
-----------------

The markaby gem/library is required to render Markaby templates:

    ## You'll need to require markaby in your app
    require 'markaby'

    get '/' do
      markaby :index
    end

Renders `./views/index.mab`.


