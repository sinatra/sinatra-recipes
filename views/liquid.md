Liquid Templates
----------------

The liquid gem/library is required to render Liquid templates:

    ## You'll need to require liquid in your app
    require 'liquid'

    get '/' do
      liquid :index
    end

Renders `./views/index.liquid`.

Since you cannot call Ruby methods, except for `yield`, from a Liquid
template, you almost always want to pass locals to it:

    liquid :index, :locals => { :key => 'value' }


