require 'sinatra'
require 'rdiscount'
require 'erb'
require 'sass'

before do
  Dir.chdir('.')
  flist = Dir['**/*.md'].select { |i| i.match(/\//) }.reject { |i| i.match(/README\.md/) }
  @menu = {}
  flist.collect { |i| m = i.split('/'); @menu[:"#{m[0]}"] = [] unless @menu[:"#{m[0]}"].is_a?(Array); @menu[:"#{m[0]}"].push(m[1]); }
end

get '/' do
  readme = File.new "README.md"
  output = RDiscount.new(readme.read).to_html
  erb output
end

get '/p/:topic' do
  readme = File.new "#{params[:topic]}/README.md"
  output = RDiscount.new(readme.read).to_html
  erb output 
end

get '/p/:topic/:article' do
  post = File.new "#{params[:topic]}/#{params[:article]}"
  output = RDiscount.new(post.read).to_html
  erb output
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
    <title>Sinatra Book Contrib</title>
    <link rel="stylesheet" type="text/css" href="/style.css" /> 
  </head>
  <body>
    <div id="header"> 
      <h2>Community contributed recipes and techniques</h2>
      <h1><a href="/">
        <img src="http://github.com/sinatra/sinatra-book/raw/master/images/logo.png" /> 
      </a></h1>
    </div> 
    <div id="menu">
      <ul>
      <% @menu.each_key do |me| %>
        <li><a href="/p/<%= "#{me}" %>"><%= me %></a>
        <ul>
          <% @menu[:"#{me}"].each do |mi| %>
            <li><a href="/p/<%= "#{me}/#{mi}" %>"><%= mi.gsub('_', ' ').gsub('.md', '') %></a></li>
          <% end %>
        </ul></li> 
      <% end %>
      </ul>
    </div>
    <div id="content">
      <%= yield %>
    </div> 
  
    <a href="http://github.com/sinatra">
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
  width: 300px

#header h2
  text-align: right 
  font-style: oblique
  font-size: 1em
  float: right
  width: 450px

#menu
  float: left 
  max-width: 320px 
  word-wrap: break-word
  font-size: .9em
  clear: left

#content
  float: right
  width: 470px 

#content pre
  padding: 10px 
  max-width: 470px
  overflow: auto
  overflow-Y: hidden
  background: #EEE
 


