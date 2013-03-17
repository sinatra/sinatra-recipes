require 'sinatra'
require 'sass'
require 'json'
require 'open-uri'
require 'slim'
require 'glorify'

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

Tilt.prefer Sinatra::Glorify::Template
set :markdown, :layout_engine => :slim
set :views, File.dirname(__FILE__)
set :ignored_dirs, %w[tmp log config public bin]

before do
  @menu = Dir.glob("./*/").map do |file|
    next if settings.ignored_dirs.any? {|ignore| /#{ignore}/i =~ file}
    file.split('/')[1]
  end.compact.sort
end

get '/' do
  begin
    open("https://api.github.com/repos/sinatra/sinatra-recipes/contributors") do |api|
      @contributors = JSON.parse(api.read)
    end 
  rescue SocketError => e
  end
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
doctype 5
html
  head
    meta charset="utf-8"
    meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"
    meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, user-scalable=no"
    title Sinatra Recipes
    link rel="stylesheet" type="text/css" href="/stylesheets/styles.css"
    link rel="stylesheet" type="text/css" href="/stylesheets/chosen.css"
    link rel="stylesheet" type="text/css" href="/pygments.css"
    link rel="shortcut icon" href="https://github.com/sinatra/resources/raw/master/logo/favicon.ico"
    script src="/javascripts/scale.fix.js"
    script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"
    script src="/javascripts/chosen.jquery.min.js"
    javascript:
      $(document).ready(function(){
          $("#post h2").each(function(){
            $(this).html(function(_, headingName){
              return headingName+'<small><a id="toplink" href="#top">^Top</a></small>';
            });
          });
          $("#selectNav").chosen().change(function(e){
            window.location.href = this.options[this.selectedIndex].value;
          });
      });

  body
    a name="top"
    .wrapper
      header
        a href="/"
          img id="logo" src="https://github.com/sinatra/resources/raw/master/logo/sinatra-classic-156.png"
          h1 Sinatra Recipes
        p Comunity contributed recipes and techniques
        p.view
          a href="http://github.com/sinatra/sinatra-recipes"
            | View the Project on GitHub <small>sinatra/sinatra</small>
        ul
          li
            a href="https://github.com/sinatra/sinatra-recipes/zipball/master"
              | Download <strong>ZIP File</strong>
          li
            a href="https://github.com/sinatra/sinatra-recipes/tarall/master"
              | Download <strong>TAR File</strong>
          li
            a href="https://github.com/sinatra/sinatra-recipes"
              | Fork on <strong>GitHub</strong> 

        p 
          small Theme based on "Minimal" by <a href="https://github.com/orderedlist">orderedlist</a>

      section
        a name="article"
        nav
          select#selectNav.chosen data-placeholder="Select a topic"
            option
            - @menu.each do |me|
              option value="/p/#{me}?#article" 
                #{me.capitalize.sub('_', ' ')}
        #post
          == yield
          - if @children
            ul
              - @children.each do |child|
                li
                  a href="/p/#{params[:topic]}/#{child}?#article"
                    == child.capitalize.sub('_', ' ')

          - if @readme
            #footer
              h2 Did we miss something?
              p
               | It's very possible we've left something out, that's why we need your help!
               | This is a community driven project after all. Feel free to fork the project 
               | and send us a pull request to get your recipe or tutorial included in the book. 
              p 
               | See the <a href="http://github.com/sinatra/recipes/blob/master/README.md">README</a> 
               | for more details.
          
          - if @contributors
            h2 Contributors
            p 
              | These recipes are provided by the following outsanding members of the Sinatra 
              | community:
            dl id="contributors"
              - @contributors.each do |contributor|
                dt 
                  a href="http://github.com/#{contributor["login"]}"
                    img src="http://www.gravatar.com/avatar/#{contributor["gravatar_id"]}?s=50"
