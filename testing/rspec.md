# RSpec

[RSpec][rs] is the main competitor to Test::Unit. It is feature rich and
pleasant to read, but too heavy for some. Therefore most other frameworks
mentioned here (except Minitest, Test::Unit and Cucumber) try to adopt its API
without its inner complexity.

In your spec file or your spec helper, you can setup `Rack::Test` like this:

```ruby
# spec/spec_helper.rb
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../my-app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }
# If you use RSpec 1.x you should use this instead:
Spec::Runner.configure { |c| c.include RSpecMixin }
```

If your app was defined using the [modular style][modular], use

```ruby
def app() described_class end
```

instead of

```ruby
def app() Sinatra::Application end
```

Now use it in your specs

```ruby
# spec/app_spec.rb
require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    # Rspec 2.x
    expect(last_response).to be_ok

    # Rspec 1.x
    last_response.should be_ok
  end
end
```

## RSpec 2.x Resources

*   [RSpec 2.x Docs](http://relishapp.com/rspec)
*   [Source on GitHub](https://github.com/rspec/rspec)
*   [Resources for RSpec 2.x developers/contributors](https://github.com/rspec/rspec-dev)

## RSpec 1.x Resources

*   [RSpec 1.x Docs](http://rspec.info/)
*   [Source on GitHub](https://github.com/dchelimsky/rspec)
*   [Resources for RSpec 1.x developers/contributors](https://github.com/dchelimsky/rspec-dev)

[rs]: http://rspec.info
[modular]: http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps
