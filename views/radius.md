Radius Templates
----------------

The radius gem/library is required to render Radius templates:

    ## You'll need to require radius in your app
    require 'radius'

    get '/' do
      radius :index
    end

Renders `./views/index.radius`.

Since you cannot call Ruby methods, except for `yield`, from a Radius
template, you almost always want to pass locals to it:

    radius :index, :locals => { :key => 'value' }


