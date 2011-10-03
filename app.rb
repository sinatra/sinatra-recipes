require 'sinatra'
require 'rdiscount'
require 'erb'
require 'sass'

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
  @menu = {}
  Dir.glob "#{settings.views}/*/*.md" do |file|
    me, mi = file.split('/')[-2..-1]
    @menu[me] ||= []
    @menu[me] << mi.sub(/\.md$/, '') unless mi == "README.md"
  end
end

get '/' do
  markdown :README
end

get '/p/:topic' do
  pass if params[:topic] == '..'
  markdown :"#{params[:topic]}/README", :layout => !request.xhr?
end

get '/p/:topic/:article' do
  pass if params[:topic] == '..'
  markdown :"#{params[:topic]}/#{params[:article]}", :layout => !request.xhr?
end

get '/style.css' do
  sass :style
end

__END__

@@ layout
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <title>Sinatra Recipes</title>
    <link rel="stylesheet" type="text/css" href="/style.css" /> 
    <script
      type='text/javascript' 
      src='https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js'>
    </script>
    <script type='text/javascript'>
    function load_article(url) {
      jQuery.ajax({
        url: url,
        success: function(response) {
          $('#post').html(response);
          $('#permalink').attr('href', url);
        }
      });
    }
    </script>
  </head>
  <body>
    <a name='top' />
    <div id="header">
      <h2>Community contributed recipes and techniques</h2>
      <h1><a href="/">
        <img src="http://github.com/sinatra/sinatra.github.com/raw/master/images/logo.gif" />
        Sinatra Recipes 
      </a></h1>
    </div>
    <div id="menu">
      <ul>
      <% @menu.each_key do |me| %>
        <li>
          <a href='#<%= "#{me}" %>' onclick="load_article('/p/<%= "#{me}" %>');">
            <%= me %>
          </a>
        <ul>
          <% @menu[me].each do |mi| %>
            <li>
              <a
                href='#<%= "#{me}_#{mi}" %>'
                onclick="load_article('/p/<%= "#{me}/#{mi}" %>');">
                <%= mi.gsub('_', ' ').gsub('.md', '') %>
              </a>
            </li>
          <% end %>
        </ul></li>
      <% end %>
      </ul>
    </div>
    <div id="content">
      <div id="perma"> 
        <a href="<%= request.url %>" id="permalink">
          Permalink 
        </a>
      </div>
      <div id="post"> 
        <%= yield %>
      </div>
    </div>
  
    <a href="http://github.com/sinatra/sinatra-recipes">
      <img style="position: absolute; top: 0; right: 0; border: 0;" src="http://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png" alt="Fork me on GitHub" />
    </a>
  </body>
</html>

@@ style
body
  font-family: 'Lucida Grande', Verdana, sans-serif
  margin: 0 auto
  max-width: 800px

h1, h2, h3, h4, h5
  font-family: georgia, 'bitstream vera serif', serif
  font-weight: normal
  font-size: 2em

a:link, a:visited
  color: #3F3F3F

a:hover, a:active
  color: #8F8F8F

.small
  font-size: .7em

#header
  margin: 10px 0px

#header a
  text-decoration: none

#header h1
  float: left
  width: 250px
  font-size: 1.8em

#header h2
  text-align: right
  font-style: oblique
  font-size: 1em
  float: right
  width: 450px

#header img
  float: left
  width: 100px
  margin-right: 15px
  border: 0

#menu
  float: left
  max-width: 320px
  word-wrap: break-word
  font-size: .9em
  clear: left

#content
  float: right
  width: 470px

#perma
  text-align: right

#content pre
  padding: 10px
  max-width: 470px
  overflow: auto
  overflow-Y: hidden
  background: #EEE
  line-height: 100%

#post
  line-height: 160%
