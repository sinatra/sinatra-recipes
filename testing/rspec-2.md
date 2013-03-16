RSpec 2.x
---------

**spec_helper**

    require 'rack/test'

    require File.expand_path '../../my-app.rb', __FILE__

    module RSpecMixin
      include Rack::Test::Methods
      def app() Sinatra::Application end
    end

    RSpec.configure { |c| c.include RSpecMixin }

If your app was defined using the [modular style](http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps), use

    def app() described_class end

instead of

    def app() Sinatra::Application end

**Shared Example Groups**

[Shared Example Groups](http://relishapp.com/rspec/rspec-core/v/2-3/dir/example-groups/shared-example-group)

    File.expand_path '../spec_helper.rb', __FILE__

    shared_examples_for "my example app" do
      before(:each) do
        @expected = 'Frank'
      end
      it "should return a welcome greeting" do
        post '/', :name => @expected 
        last_response.body.should == "Hello #{@expected}!"
      end
    end

    describe "my session handler" do
      it_behaves_like "my example app"

      it "should return the name parameter from a session" do
        get '/session', {}, 'rack.session' => { 'name' => @expected }
        last_response.body.should == "Hello #{@expected}!" 
      end
    end

**RSpec 2.x Resources**

*   [RSpec 2.x Docs](http://relishapp.com/rspec)
*   [Source on github](https://github.com/rspec/rspec)
*   [Resources for RSpec 2.x developers/contributors](https://github.com/rspec/rspec-dev)


