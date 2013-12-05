# Using Capybara

## Steak

```ruby
# spec/acceptance/acceptance_helper.rb

ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'steak'
require 'rack/test'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara
end

require File.expand_path '../../../my-app.rb', __FILE__

Capybara.app = Sinatra::Application
```

## My Page Acceptance Spec

```ruby
require File.expand_path '../acceptance_helper.rb', __FILE__

feature "My Page" do

  scenario "greets the visitor" do
    visit "/"
    page.should have_content "Welcome to my page!"
  end

end
```

## Steak Resources

*   [Source on GitHub](https://github.com/cavalle/steak)
*   [Documentation](http://rdoc.info/gems/steak/1.0.1/frames/)
*   [Timeless: BDD with RSpec and Steak](http://timeless.judofyr.net/bdd-with-rspec-and-steak)
*   [More Steak Resources](https://github.com/cavalle/steak/wiki/Resources)

## The Future of Steak

Capybara's acceptance testing DSL was [recently added][dsl-added].  They just
basically consumed Steak, since it was always "a gist that happened to be
distributed as a Ruby gem." It won't be included until the next release of
Capybara, but after that, Steak won't be needed, unless you're using an older
version of Capybara for some reason.

[dsl-added]: https://github.com/jnicklas/capybara/commit/f4897f890d8dd33215fef238902988e8823a6539
