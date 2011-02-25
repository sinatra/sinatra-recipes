Less Templates
--------------

The less gem/library is required to render Less templates:

    ## You'll need to require less in your app
    require 'less'

    get '/stylesheet.css' do
      less :stylesheet
    end

Renders `./views/stylesheet.less`.


