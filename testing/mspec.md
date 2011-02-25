MSpec
-----

After installing [MSpec][ms], you set it up like this:

    ENV['RACK_ENV'] = 'test'
    require 'mspec'
    require 'rack/test'
    
    begin 
      require_relative 'my-app.rb'
    rescue NameError
      require File.expand_path('my-app.rb', __FILE__)
    end
 
    include Rack::Test::Methods
    def app() Sinatra::Application end


