Builder
-------

The builder gem/library is required to render builder templates:

    ## You'll need to require builder in your app
    require 'builder'

    get '/' do
      builder :index
    end

This will render ./views/index.builder

    get '/' do
      builder do |xml|
        xml.node do
          xml.subnode "Inner text"
        end
      end
    end

This will render the xml inline, directly from the handler.


