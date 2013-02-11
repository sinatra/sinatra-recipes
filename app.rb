require 'sinatra'
require 'rdiscount'
require 'sass'
require 'json'
require 'open-uri'
require 'slim'

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
    meta http-equiv="X-UA-Compatible" content="chrome=1"
    title Sinatra Recipes
    link rel="stylesheet" type="text/css" href="/stylesheets/styles.css"
    link rel="shortcut icon" href="https://github.com/sinatra/resources/raw/master/logo/favicon.ico"
    script src="/javascripts/scale.fix.js"
    script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"
  body
    #wrapper
      aside
        header
          img src="https://github.com/sinatra/resources/raw/master/logo/sinatra-classic-156.png"
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

        nav
          h2 Topics
          dl
            - @menu.each do |me|
              dt
                a href="/p/#{me}" #{me.capitalize.sub('_', ' ')}
          p 
            small Theme by <a href="https://github.com/orderedlist">orderedlist</a>

      section
        #post
          == yield
          - if @children
            ul
              - @children.each do |child|
                li
                  a href="/p/#{params[:topic]}/#{child}"
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
            ul id="contributors"
              - @contributors.each do |contributor|
                li
                  a href="http://github.com/#{contributor["login"]}"
                    img src="http://www.gravatar.com/avatar/#{contributor["gravatar_id"]}?s=50"

    a href="http://github.com/sinatra/sinatra-recipes"
      img style="position: absolute;top:0;right:0;border:0;" src="http://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png" alt="Fork me on GitHub"

