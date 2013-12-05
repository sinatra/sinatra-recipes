# Minitest

Since Ruby 1.9, [Minitest](https://github.com/seattlerb/minitest) is
shipped with the standard library. If you want to use it on 1.8, it is still
available via Rubygems.

After installing Minitest, setting it up works similar to `Test::Unit`.

If you have multiple test files, you could create a test helper file and do
all the setup in there:

```ruby
# test_helper.rb
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../my-app.rb', __FILE__
```

In your test files you only have to require that helper:

```ruby
# test.rb
require File.expand_path '../test_helper.rb', __FILE__

class MyTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal "Hello, World!", last_response.body
  end
end
```

If your app was defined using the [modular style][modular-style], use

```ruby
def app
  MyApp # <- your application class name
end
```

instead of

```ruby
def app
  Sinatra::Application
end
```

## Specs and Benchmarks with Minitest

**Specs**

```ruby
require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "my example app" do
  it "should successfully return a greeting" do
    get '/'
    last_response.body.must_include 'Welcome to my page!'
  end
end
```

**Benchmarks**

```ruby
require File.expand_path '../test_helper.rb', __FILE__

require 'minitest/benchmark'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "my example app" do
  bench_range { bench_exp 1, 10_000 }
  bench_performance_linear "welcome message", 0.9999 do |n|
    n.times do
      get '/'
      last_response.body.must_include 'Welcome to my page!'
    end
  end
end
```

**Rake**

When you're ready to start using MiniTest as an automated testing framework,
you'll need to setup a Rake TestTask. Here's one we'll use to run our
MiniTest::Specs:

```ruby
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end
```

Now run your MiniSpecs with `rake test`.

More on [Rake::TestTask](http://rake.rubyforge.org/classes/Rake/TestTask.html)

## MiniTest Resources

*   [Source on github](https://github.com/seattlerb/minitest)
*   [Documentation](http://rdoc.info/gems/minitest)
*   [Official Blog Archive](http://blog.zenspider.com/minitest/)

[modular-style]: (http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps
