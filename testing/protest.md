Protest
-------

After installing [Protest][pt], setting it up works similar to `Test::Unit`:

    ENV['RACK_ENV'] = 'test'
    require 'protest'
    require 'rack/test'
 
    begin 
      require_relative 'my-app.rb'
    rescue NameError
      require File.expand_path('my-app.rb', __FILE__)
    end
 
    module TestMixin
      include Rack::Test::Methods
      Protest::TestCase.send(:include, self)
      def app() Sinatra::Application end
    end


