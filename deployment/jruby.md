JRuby
=====

The [JRuby][jruby] platform is an excellent deployment choice for just about any
Sinatra application. With its seamless integration to the Java ecosystem your
application can immediately benefit from a rock-solid VM that leaves most non-native
language platforms drooling for more. Years of engineering efforts in scaling
and performance, community-driven libraries and frameworks, and of course truly
multi-threaded applications (no green threads, no GILs) are just some of those
immediate benefits.

## The Basics

There are several ways to install [JRuby][jruby], but that is beyond the scope
of this article. For now, we will assume you are using the excellent [RVM][rvm]
from Wayne Seguin, and proceed from there.

    rvm install jruby # (if you haven't already)
    rvm use jruby

Create a classic Sinatra application and save it to hello.rb:

	require 'rubygems'
	require 'sinatra'
	
	get '/' do
		%Q{
		<html>
			<body>
				hello from the 
				<strong>wonderful</strong> 
				world of JRuby
			</body>
		</html>
		}
	end

Now, you're ready to fire it up.

    ruby /path/to/hello.rb

That's it. Open <http://localhost:4567> in your browser and your Sinatra
application should greet you from the **wonderful** world of [JRuby][jruby].

Of course, you can use a config.ru and rackup as well:

	cat <<EOF>config.ru
	require 'rubygems'
	require 'sinatra'
	require 'hello'
	run Sinatra::Application
	EOF
	
	rackup config.ru

Now go to <http://localhost:9292>.

## Deployment with Trinidad

[Trinidad][trinidad] is a RubyGem that allows you to run any Rack based application
within an embedded Apache Tomcat container.

Again, with our example above, you would do the following:

	gem install trinidad
	trinidad -r config.ru -p 4567 -g ERROR

The _-g_ option sets the logging level to error.

## Deployment with Torquebox

_Coming soon_

[jruby]: http://jruby.org/
[rvm]: http://rvm.beginrescueend.com/
[torquebox]: http://torquebox.org/
[trinidad]: http://thinkincode.net/trinidad/