require 'sinatra'
require 'rdiscount'
require 'erb'
require 'sass'
require 'json'
require 'open-uri'

set :public_folder, File.dirname(__FILE__) + '/public'
configure :production do
  sha1, date = `git log HEAD~1..HEAD --pretty=format:%h^%ci`.strip.split('^')

  require 'rack/cache'
  use Rack::Cache

  before do
    cache_control :public, :must_revalidate, :max_age=>300
    etag sha1
    last_modified date
  end
end

set :markdown, :layout_engine => :erb
set :views, File.dirname(__FILE__)

before do
  @menu = Dir.glob("./*/").map do |file|
    next if file =~ /tmp/ or file =~ /log/ or file =~ /config/ or file =~ /public/
    file.split('/')[1]
  end.compact.sort
end

get '/' do
  open("https://api.github.com/repos/sinatra/sinatra-recipes/contributors") { |api|
    @contributors = JSON.parse(api.read)
  }

  markdown :README
end

get '/p/:topic' do
  pass if params[:topic] == '..'
  @readme = true
  @children = Dir.glob("./#{params[:topic]}/*.md").map do |file|
    next if file =~ /README/
    next if file.empty? or file.nil?
    file.split('/')[-1].sub(/\.md$/, '')
  end.compact.sort
  markdown :"#{params[:topic]}/README"
end

get '/p/:topic/:article' do
  pass if params[:topic] == '..'
  markdown :"#{params[:topic]}/#{params[:article]}"
end

__END__

@@ layout
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <title>Sinatra Recipes</title>
    <link rel="stylesheet" type="text/css" href="/stylesheets/styles.css" /> 
    <link rel="stylesheet" type="text/css" href="/stylesheets/pygment_trac.css" /> 
    <link rel="shortcut icon" href="https://github.com/sinatra/resources/raw/master/logo/favicon.ico">
    <script src="/javascripts/scale.fix.js"/>
    <script type='text/javascript' 
      src='https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js'>
    </script>
  </head>
  <body>
    <div class="wrapper">
    <aside>
        <header>
            <img src="https://github.com/sinatra/resources/raw/master/logo/sinatra-classic-156.png" />
          <h1>
            Sinatra Recipes
          </h1>
          <p>Community contributed recipes and techniques</p>
          <p class="view"><a href="http://github.com/sinatra/sinatra-recipes">View the Project on GitHub <small>sinatra/sinatra-recipes</small></a></p>
          <ul>
            <li><a href="https://github.com/sinatra/sinatra-recipes/zipball/master">Download <strong>ZIP File</strong></a></li>
            <li><a href="https://github.com/sinatra/sinatra-recipes/tarball/master">Download <strong>TAR Ball</strong></a></li>
            <li><a href="http://github.com/sinatra/sinatra-recipes">Fork On <strong>GitHub</strong></a></li>
          </ul>
        </header>
        <nav>
          <h2>Topics</h2>
          <dl>
            <% @menu.each do |me| %>
              <dt>
                <a href='/p/<%= "#{me}" %>'>
                  <%= me.capitalize.sub('_', ' ') %>
                </a>
              </dt>
            <% end %>
          </dl>
        </nav>
      </aside>
      <section>
        <div id="post"> 
          <%= yield %>
          <% if @children %>
            <div id="children">
              <ul>
              <% @children.each do |child| %>
                <li>
                  <a href='/p/<%= "#{params[:topic]}/#{child}" %>'>
                    <%= child.capitalize.sub('_', ' ') %>
                  </a>
                </li>
              <% end %>
              </ul>
            </div>
          <% end %>

          <% if @readme %>
            <div id="footer">
              <h2>Did we miss something?</h2>
              <p>It's very possible we've left something out, thats why we need your help! This
              is a community driven project after all. Feel free to fork the project and send
              us a pull request to get your recipe or tutorial included in the book.</p>
              <p>See the <a href="http://github.com/sinatra/recipes/blob/master/README.md">README</a> for more details.</p>
            </div>
          <% end %>

          <% if @contributors %>
            <h2>Contributors</h2>
            <p>These recipes are provided by the following outstanding members of the Sinatra community:</p>
            <ul id="contributors">
              <% @contributors.each do |contributor| %>
                <li>
                  <a href="http://github.com/<%= contributor["login"] %>">
                    <img src="http://www.gravatar.com/avatar/<%= contributor["gravatar_id"] %>?s=50" />
                  </a>
                </li>
              <% end %>
            </ul>
          <% end %>
        </div>
      </section>
    
      <footer>
        <p><small>Theme by <a href="https://github.com/orderedlist">orderedlist</a></small></p>
      </footer>
      <a href="http://github.com/sinatra/sinatra-recipes">
        <img style="position: absolute; top: 0; right: 0; border: 0;" src="http://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png" alt="Fork me on GitHub" />
      </a>
    </div>
  </body>
</html>


