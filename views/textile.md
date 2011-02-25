Textile Templates
-----------------

The RedCloth gem/library is required to render Textile templates:

    ## You'll need to require redcloth in your app
    require "redcloth"

    get '/' do
      textile :index
    end

Renders `./views/index.textile`.

It is not possible to call methods from textile, nor to pass locals to it. You
therefore will usually use it in combination with another rendering engine:

    erb :overview, :locals => { :text => textile(:introduction) }

Note that you may also call the textile method from within other templates:

    %h1 Hello From Haml!
    %p= textile(:greetings)
   

