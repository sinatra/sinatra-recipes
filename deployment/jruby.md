# JRuby

The [JRuby][jruby] platform is an excellent deployment choice for just about any
Sinatra application. With its seamless integration to the Java ecosystem your
application can immediately benefit from a rock-solid VM that leaves most
language platforms drooling for more. Years of engineering efforts in scaling
and performance, community-driven libraries and frameworks, and of course truly
multi-threaded applications (no green threads, no GILs) are just some of those
immediate benefits.

The deployment landscape for [JRuby][jruby] is easy to navigate. You can deploy
using Mongrel, Thin (experimental), Webrick (but who would do that?), and even
Java-centric application containers like Glassfish, Tomcat, or JBoss. We will
discuss just a few of these approaches.

## The Basics

There are several ways to install [JRuby][jruby], but that is beyond the scope
of this article. For now, we will assume you are using the excellent [RVM][rvm]
, from Wayne Seguin, and proceed from there.

```bash
rvm install jruby    # (if you haven't already)
rvm use jruby
gem install mongrel
```

Create a classic Sinatra application and save it to hello.rb:

```ruby
require 'rubygems'
require 'sinatra'

get '/' do
  %Q{
    <html>
      <body>
        Hello from the
        <strong>wonderful</strong>
        world of JRuby!
      </body>
    </html>
  }
end
```

Now, you're ready to fire it up.

```
ruby /path/to/hello.rb
```

That's it. Open <http://localhost:4567> in your browser and your Sinatra
application should greet you from the **wonderful** world of [JRuby][jruby].

Of course, you can use a config.ru and rackup as well:

```ruby
require 'rubygems'
require 'sinatra'
require File.expand_path '../hello.rb', __FILE__
run Sinatra::Application
```

Then launch app with the following command:

```bash
rackup config.ru
```

Now go to <http://localhost:9292> and you'll see the same **wonderful**
greeting.

## Deployment with Trinidad

[Trinidad][trinidad] is a RubyGem that allows you to run any Rack based
application within an embedded Apache Tomcat container.

Again, with our example above, you would do the following:

```bash
gem install trinidad
trinidad -r config.ru -p 4567 -g ERROR
```

The _-g_ option sets the logging level to error.

## Deployment with TorqueBox

[TorqueBox][TorqueBox] is built on the JBoss Application Server. Out of the
mouths of the [TorqueBox][TorqueBox] developers themselves:
>JBoss AS includes high-performance clustering, caching and messaging
functionality. By building Ruby capabilities on top of this foundation,
your Ruby applications gain more capabilities right out-of-the-box.

Deployment on [TorqueBox][TorqueBox] is pretty simple, just like the other
deployments we've seen so far -- it embraces Rake for accomplishing its tasks.
For installation help checkout
[their tutorial](http://TorqueBox.org/documentation/DEV/installation.html).

During the installation of [TorqueBox][TorqueBox] you probably set a JBOSS_HOME
variable, if not make sure you have set it like this:

```bash
export JBOSS_HOME=/path/to/TorqueBox/jboss
```

In your Rakefile add this line:

```ruby
require 'TorqueBox/tasks'
```

Now, you are ready to deploy your application:

```bash
rake TorqueBox:deploy
```

To deploy a production version of your application:

```bash
RACK_ENV=production rake TorqueBox:deploy
```

To take your application down, you run:

```bash
rake TorqueBox:undeploy
```

[TorqueBox][TorqueBox] also allows you deploy to a non-root context:

```bash
rake TorqueBox:deploy['/hello']
```

## Conclusion

That's it. Pretty simple, eh?! There are other players in the field, like
[Glassfish][glassfish] and [Jetty][jetty].

Becoming familiar with each of these deployment options, what one offers over
the other, strengths and weaknesses, etc. is not an easy task. So here are
some basic tips:

- If your application just needs a rock-solid, easy deployment without all of
the enterprise-y bells and whistles that many Java app servers offer you,
choose a simple bare-bones JRuby deployment with Mongrel or Jetty with
[jetty-rackup][jetty-rackup].

- If you need highly scalable, clustered deployments consider TorqueBox or
Glassfish. Both are solid performers with messaging capabilities built in.
TorqueBox may be a simpler approach.

- If your company or service provider already supports Tomcat, use Trinidad.

If you aren't sure... try all of them. I would suggest spending some effort
in writing a benchmark suite so that you have a good comparison of what really
matters in the end -- performance, memory consumption, disk space, scalability,
etc. You could even start with TorqueBox's
[speedmetal](https://github.com/TorqueBox/speedmetal) benchmarking suite and
craft it to suit your fancy. Read up on TorqueBox's benchmarking efforts at
<http://TorqueBox.org/news/2011/02/23/benchmarking-TorqueBox>.

[jruby]: http://jruby.org/
[rvm]: http://rvm.io/
[TorqueBox]: http://TorqueBox.org/
[trinidad]: http://thinkincode.net/trinidad/
[glassfish]: http://glassfish.java.net/
[jetty]: http://jetty.codehaus.org/jetty/
[jetty-rackup]: https://github.com/geekq/jetty-rackup
