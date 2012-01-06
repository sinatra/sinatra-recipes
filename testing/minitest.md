Minitest
--------

Since Ruby 1.9, [Minitest](http://rubydoc.info/gems/minitest/2.0.1/frames) is
shipped with the standard library. If you want to use it on 1.8, it is still
installable via Rubygems.

After installing Minitest, setting it up works similar to `Test::Unit`:

If you have multiple test files, you could create a test helper file and do
all the setup in there:

    # test_helper.rb
    ENV['RACK_ENV'] = 'test'
    require 'minitest/autorun'
    require 'rack/test'
    
    begin
      require_relative 'my-app'
    rescue NameError 
      require File.expand_path('my-app', __FILE__)
    end
  
In your test files you only have to require that helper:

    # test.rb
    begin 
      require_relative 'test_helper'
    rescue NameError
      require File.expand_path('test_helper', __FILE__)
    end

    class MyTest < MiniTest::Unit::TestCase
      
      include Rack::Test::Methods

      def app() Sinatra::Application end
    
      def test_hello_world
        get '/'
        assert last_response.ok?
        assert_equal "Hello, World!", last_response.body
      end
    end

If your app was defined using the [modular style](http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps), use 

    def app
        MyApp # <- your application class name
    end
    
instead of 

    def app() Sinatra::Application end

### Specs and Benchmarks with Minitest

**Specs**

    begin 
      require_relative 'test_helper'
    rescue NameError
      require File.expand_path('test_helper', __FILE__)
    end

    include Rack::Test::Methods

    def app() Sinatra::Application end

    describe "my example app" do
      it "should successfully return a greeting" do
        get '/' 
        assert_equal 'Welcome to my page!', last_response.body 
      end
    end

**Benchmarks**

    begin 
      require_relative 'test_helper'
    rescue NameError
      require File.expand_path('test_helper', __FILE__)
    end
    
    require 'minitest/benchmark'

    include Rack::Test::Methods
    def app() Sinatra::Application end

    describe "my example app" do
      bench_range { bench_exp 1, 10_000 } 
      bench_performance_linear "welcome message", 0.9999 do |n|
        n.times do
          get '/'
          assert_equal 'Welcome to my page!', last_response.body 
        end 
      end
    end

**Rake**

When you're ready to start using MiniTest as an automated testing framework,
you'll need to setup a Rake TestTask. Here's one we'll use to run our
MiniTest::Specs:

    require 'rake/testtask'
    Rake::TestTask.new do |t|
      t.pattern = "spec/*_spec.rb" 
    end 

Now run your MiniSpecs with `rake test`.

More on [Rake::TestTask](http://rake.rubyforge.org/classes/Rake/TestTask.html)


**MiniTest Resources**

*   [Source on github](https://github.com/seattlerb/minitest)
*   [Documentation](http://rdoc.info/gems/minitest/2.0.2/frames)
*   [Official Blog Archive](http://blog.zenspider.com/minitest/) 
*   [1.9.2 Stdlib Documentation](http://rdoc.info/stdlib/minitest/1.9.2/frames)
*   [Bootspring MiniTest Blog Post](http://www.bootspring.com/2010/09/22/minitest-rubys-test-framework/)


