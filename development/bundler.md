# Bundler

Whether you need a specific gem and version, or a set of gems for a certain
environment; Bundler is a fantastic tool for managing your applications
dependencies.

### Gemfiles

Gemfiles are the source of your bundle, used by bundler to determine what gems
to install and require in different situations. It's important to understand
the difference between the Gemfile and Gemfile.lock; Gemfiles are where you
specify the actual gems required by your application, and the Gemfile.lock is a
definition of all the required gems and the exact versions used by your
application. As it's necessary for other developers to know exactly what
versions of third party libraries you're using, the Gemfile.lock is recommended
to be checked into source control. 

**Gemcutter**

In most cases you're going to require gems from the [official rubygems
repository](http://rubygems.org/). Here's an example Gemfile for an application
that uses Sinatra as a main dependency and RSpec for testing:

```ruby
# define our source to loook for gems
source "http://rubygems.org/"

# declare the sinatra dependency
gem "sinatra" 

# setup our test group and require rspec
group :test do
  gem "rspec"
end

# require a relative gem version
gem "i18n", "~> 0.4.1"
```

**Git**

Bundler also supports the installation of gems through git, so long as the
repository contains a valid gemspec for the gem you're trying to install.

```ruby
# lets use sinatra edge
gem "sinatra", :git => "http://github.com/sinatra/sinatra.git"

# and lets we use the rspec 2.0 release candidate from git
group :test do
  gem "rspec", :git => "http://github.com/rspec/rspec.git", 
    :tag => "v2.0.0.rc"  
end

# as well as i18n from git
gem "i18n", :git => "http://github.com/svenfuchs/i18n.git"
```

### Commands (CLI)

Bundle is the command line utility provided with Bundler to install, update and
manage your bundle. Here's a quick overview of some of the most common
commands.

**Installing**

```bash
# Install specified gems from your Gemfile and Gemfile.lock
bundle install 
```

```bash
# Inspect your bundle to see if you've met your applications requirements
bundle check
```

```bash
# List all gems in your bundle
bundle list
```

```bash
# Show source location of a specific gem in your bundle
bundle show [gemname]
```

```bash
# Generate a skeleton Gemfile to start your path to using Bundler 
bundle init
```

**Updating**

Updating your bundle will look in the given repositories for the latest
versions available. This will bypass your Gemfile.lock and check for completely
new versions. Alternatively you can specify an individual gem to update, and
bundler will only update that gem to the latest version available in the
specified repository.

```bash
# Update all gems specified to the latest versions available
bundle update
```

```bash
# Update just i18n to the latest gem version available
bundle update i18n
```

**Requiring**

Bundler provides two main ways to use your bundle in your application,
`Bundler.setup` and `Bundler.require`. `Setup` basically tells Ruby all
of your gems loadpaths, and `require` will load all of your specified gems.

Requiring `bundler/setup` is the same as calling `Bundler.setup` yourself, and
is the recommended method in the gembundler documentation.

```ruby
# If you're using Ruby 1.9 you'll need to specifically load rubygems
require 'rubygems'

# and now load bundler with your dependencies load paths
require 'bundler/setup'

# next you'll have to do the gem requiring yourself
require 'sinatra'
require 'i18n'
```

Now if say you skip the last step, and just auto require gems from your groups

```ruby
require 'rubygems'
require 'bundler/setup'

# this will require all the gems not specified to a given group (default)
# and gems specified in your test group
Bundler.require(:default, :test)
```

###  Resources

*    [Bundler's Purpose and Rationale](http://gembundler.com/rationale.html) -
For a longer explanation of what Bundler does and how it works
*    [Gemfile Manual](http://gembundler.com/man/gemfile.5.html)
*    [CLI Manual](http://gembundler.com/man/bundle.1.html) - Basic command 
line utilities provided with Bundler
*    [Gems from Git repositories](http://gembundler.com/git.html) - Using git 
repositories with your Gemfile
*    [Using Groups](http://gembundler.com/groups.html) - Using groups with 
bundler
*    [bundle install manual](http://gembundler.com/man/bundle-install.1.html)
*    [bundle update manual](http://gembundler.com/man/bundle-update.1.html)
*    [bundle package manual](http://gembundler.com/man/bundle-package.1.html)
*    [bundle exec manual](http://gembundler.com/man/bundle-exec.1.html)
*    [bundle config manual](http://gembundler.com/man/bundle-config.1.html)


