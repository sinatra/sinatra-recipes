# Features from Cucumber and Webrat

## A Feature Example

```gherkin
Feature: View my page
  In order for visitors to feel welcome
  We must go out of our way
  With a kind greeting

  Scenario: My page
    Given I am viewing my page
    Then I should see "Welcome to my page!"
```

## Step to it

```ruby
Given /^I am viewing my page$/ do
  visit('/')
end

Then /^I should see "([^"]*)"$/ do |text|
  last_response.body.should match(/#{text}/m)
end
```

```ruby
# features/support/env.rb

ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'rack/test'
require 'rspec/expectations'
require 'webrat'

require File.expand_path '../../../my-app.rb', __FILE__

Webrat.configure do |config|
  config.mode = :rack
end

class WebratMixinExample
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end

World{WebratMixinExample.new}
```

## Cucumber Resources

*   [Cucumber Homepage](http://cukes.info/)
*   [Source on GitHub](https://github.com/aslakhellesoy/cucumber)
*   [Documentation](https://github.com/aslakhellesoy/cucumber/wiki/)
