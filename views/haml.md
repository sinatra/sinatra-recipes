Haml
----

The haml gem/library is required to render HAML templates:

    set :haml, :format => :html5 # default Haml format is :xhtml

    get '/' do
      haml :index, :format => :html4 # overridden
    end

This will render ./views/index.haml

[Haml's
options](http://haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html#options) can
be set globally through Sinatra’s configurations, see [Options and
Configurations](#configuration), and overridden on an individual basis. 


