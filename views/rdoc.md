RDoc Templates
--------------

The RDoc gem/library is required to render RDoc templates:

    ## You'll need to require rdoc in your app
    require "rdoc"

    get '/' do
      rdoc :index
    end

Renders `./views/index.rdoc`.

It is not possible to call methods from rdoc, nor to pass locals to it. You
therefore will usually use it in combination with another rendering engine:

    erb :overview, :locals => { :text => rdoc(:introduction) }

Note that you may also call the rdoc method from within other templates:

    %h1 Hello From Haml!
    %p= rdoc(:greetings)


