Nokogiri
--------

The nokogiri gem/library is required to render nokogiri templates:

    ## You'll need to require nokogiri in your app
    require 'nokogiri'

    get '/' do
      nokogiri :index
    end

Renders `./views/index.nokogiri`.


