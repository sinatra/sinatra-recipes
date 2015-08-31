# Test::Unit

One of the advantages of using
[Test::Unit](http://rdoc.info/gems/test-unit/2.1.2/frames) is that it already
ships with Ruby **1.8.7** and you can skip the installation part in some cases.

For modern versions of Ruby, you must install the Test::Unit gem:

```bash
gem install test-unit
```

Set up rack-test by including `Rack::Test::Methods` into your test class and
defining `app`:

```ruby
ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'


require File.expand_path '../my-app.rb', __FILE__

class HomepageTest < Test::Unit::TestCase
  include Rack::Test::Methods
  def app() Sinatra::Application end

  def test_homepage
    get '/'
    assert last_response.ok?
  end
end
```

## Shoulda

```ruby
require File.expand_path '../test_helper.rb', __FILE__

class ExampleUnitTest < Test::Unit::TestCase

  include Rack::Test::Methods

  def app() Sinatra::Application end

  context "view my page" do
    setup do
      get '/'
    end

    should "greet the visitor" do
      assert last_response.ok?
      assert_equal 'Welcome to my page!', last_response.body
    end

  end
end
```
