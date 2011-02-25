RSpec 1.x
---------

[RSpec][rs] is the main competitor to Test::Unit. It is feature rich and
pleasant to read, but to heavy for some. Therefore most other frameworks
mentioned here (except Minitest, Test::Unit and Cucumber) try to adopt its API
without its inner complexity. The 1.x version of RSpec is still widely spread
and 2.x still lacks major adoption.

In your spec file or your spec helper, you can setup `Rack::Test` like this:

    # spec/spec_helper.rb
    ENV['RACK_ENV'] = 'test'
    require 'test/unit'
    require 'rack/test'
    
    begin 
      require_relative 'my-app'
    rescue NameError
      require File.expand_path('my-app', __FILE__)
    end

    module TestMixin
      include Rack::Test::Methods
      def app() Sinatra::Application end
    end
    
    Spec::Runner.configure { |c| c.include TestMixin }

And use it in your specs:

    begin 
      require_relative '../spec_helper'
    rescue NameError
      require File.expand_path('../spec_helper', __FILE__)
    end
    
    describe "My Sinatra Application" do
      it "should allow accessing the home page" do
        get '/'
        last_response.should be_ok
      end
    end

**RSpec 1.x Resources**

*   [RSpec 1.x Docs](http://rspec.info/)
*   [Source on github](https://github.com/dchelimsky/rspec)
*   [Resources for RSpec 1.x developers/contributors](https://github.com/dchelimsky/rspec-dev)


