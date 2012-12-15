Dreamhost Deployment via Passenger
----------------------------------

You can deploy your Sinatra apps to Dreamhost, a shared web hosting service,
via Passenger with relative ease. Here's how.

1. Setting up the account in the Dreamhost interface

       Domains -> Manage Domains -> Edit (web hosting column)
       Enable 'Ruby on Rails Passenger (mod_rails)'
       Add the public directory to the web directory box. So if you were using 'rails.com', it would change to 'rails.com/public'
       Save your changes

2. Creating the directory structure
       
        domain.com/
        domain.com/tmp
        domain.com/public
        # a vendored version of sinatra - not necessary if you use the gem
        domain.com/sinatra

3. Here is an example config.ru file that does two things.  First, it requires
   your main app file, whatever it's called. In the example, it will look for
   `myapp.rb`.  Second, run your application.  If you're subclassing, use the
   subclass's name, otherwise use Sinatra::Application.

        require "myapp"

        run Sinatra::Application

4. A very simple Sinatra application

        # this is myapp.rb referred to above
        require 'sinatra'
        get '/' do
          "Worked on dreamhost"
        end
         
        get '/foo/:bar' do
          "You asked for foo/#{params[:bar]}"
        end

And that's all there is to it! Once it's all setup, point your browser at your 
domain, and you should see a 'Worked on Dreamhost' page. To restart the 
application after making changes, you need to run `touch tmp/restart.txt`.

Please note that currently passenger 2.0.3 has a bug where it can cause Sinatra to not find
the view directory. In that case, add `:views => '/path/to/views/'` to the Sinatra options
in your Rackup file.

You may encounter the dreaded "Ruby (Rack) application could not be started" 
error with this message "can't activate rack (>= 0.9.1, < 1.0, runtime), 
already activated rack-0.4.0". This happens because DreamHost has version 0.4.0
installed, when recent versions of Sinatra require more recent versions of Rack.
The solution is to explicitly require the rack and sinatra gems in your 
config.ru. Add the following two lines to the start of your config.ru file:
  
       require '/home/USERNAME/.gem/ruby/1.8/gems/rack-VERSION-OF-RACK-GEM-YOU-HAVE-INSTALLELD/lib/rack.rb'
       require '/home/USERNAME/.gem/ruby/1.8/gems/sinatra-VERSION-OF-SINATRA-GEM-YOU-HAVE-INSTALLELD/lib/sinatra.rb'

