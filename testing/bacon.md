Testing with Bacon
------------------

After installing [Bacon][bc], setting it up works similar to `Test::Unit`:

    ENV['RACK_ENV'] = 'test'
    require 'bacon'
    require 'rack/test'
    
    require File.expand_path '../my-app.rb', __FILE__
 
    module TestMixin
      include Rack::Test::Methods
      Bacon::Context.send(:include, self)
      def app() Sinatra::Application end
    end


