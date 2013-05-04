require 'time'
require 'sinatra'
require 'sass'
require 'json'
require 'open-uri'
require 'slim'
require 'glorify'
require 'rdoc'

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
set :ignored_dirs, %w[tmp log config public bin activity]

before do
  @menu = Dir.glob("./*/").map do |file|
    next if settings.ignored_dirs.any? {|ignore| /#{ignore}/i =~ file}
    file.split('/')[1]
  end.compact.sort
end

before '/p/:topic/:article' do
  @title = prepare_title(params[:topic], params[:article])
end

before '/p/:topic' do
  @title = prepare_title(params[:topic])
end

helpers do

  def de_underscore(string)
    string.gsub('_', ' ').split(" ").map(&:capitalize).join(" ")
  end

  def prepare_title(*args)
    "Sinatra Recipes - #{args.map {|x| de_underscore(x)}.join(' - ')}"
  end

  def commits_url
    "https://api.github.com/repos/sinatra/sinatra-recipes/commits"
  end

  def contributors_url
    "https://api.github.com/repos/sinatra/sinatra-recipes/contributors"
  end

  def contributors
    JSON.parse(open(contributors_url).read)
  end

  def commits
    JSON.parse(open(commits_url).read)
  end

  def get_authors
    commits.map do |x|
      {
        :name => x['author']['login'],
        :avatar => x['author']['avatar_url'],
        :url => x['author']['html_url']
      }
    end.uniq.flatten.group_by {|x| x[:name]}
  end

  def get_activity
    commits.map do |x|
      {
        :author_name => x['author']['login'],
        :merge_date => Time.parse(x['commit']['author']['date']).strftime("%d-%B-%Y"),
        :commit_message => x['commit']['message'],
        :commit_url => "https://github.com/sinatra/sinatra-recipes/commit/#{x['sha']}"
      }
    end.group_by {|x| x[:merge_date] }
  end

  def get_activity_by_author
    get_activity.map do |k,v|
      {
        :date => k,
        :activity_by_author => v.group_by {|z| z[:author_name] }
      }
    end
  end
end

get '/' do
  begin
    @contributors = contributors
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
  md = File.read("#{params[:topic]}/#{params[:article]}.md")
  formatter = RDoc::Markup::ToTableOfContents.new
  @toc = RDoc::Markdown.parse(md).accept(formatter)
  markdown md
end

get '/activity' do
  pass if params[:topic] == '..'
  @authors = get_authors
  @activity = get_activity_by_author
  markdown :'activity/README'
end

get '/style.css' do
  sass :style
end

__END__

@@ layout
doctype 5
html
  head
    meta charset="utf-8"
    meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"
    meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, user-scalable=no"
    title #{@title || 'Sinatra Recipes'}
    link rel="stylesheet" type="text/css" href="/style.css"
    link rel="stylesheet" type="text/css" href="/stylesheets/pygment_trac.css"
    link rel="stylesheet" type="text/css" href="/stylesheets/chosen.css"
    link rel="shortcut icon" href="https://github.com/sinatra/resources/raw/master/logo/favicon.ico"
    script src="/javascripts/scale.fix.js"
    script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"
    script src="/javascripts/chosen.jquery.min.js"
    javascript:
      $(document).ready(function(){
        $("#selectNav").chosen().change(function(e){
          window.location.href = this.options[this.selectedIndex].value;
        });
      });

  body
    a name="documentation"
    .wrapper
      #header
        a href="/"
          img id="logo" src="https://github.com/sinatra/resources/raw/master/logo/sinatra-classic-156.png"
          h1 Sinatra Recipes
          .caption Community contributed recipes and techniques
      .clear
      #sidebar
        nav
          select#selectNav.chosen data-placeholder="Select a topic"
            option
            - @menu.each do |me|
              option value="/p/#{me}?#article" #{de_underscore(me)}
        - if @toc and @toc.any?
          h2 Chapters
          ol
            - @toc.each do |toc|
              li
                a href="##{toc.aref}"
                  == toc.plain_html
      #content
        #post
          == yield
          - if @children
            ul
              - @children.each do |child|
                li
                  a href="/p/#{params[:topic]}/#{child}?#article"
                    == de_underscore(child)
          - if @activity
            #activity
              - @activity.each do |x|
                h3 #{x[:date]}
                hr
                ul.nodec
                  - x[:activity_by_author].each do |author_name, activities|
                    - author = @authors[author_name].first
                    li
                      | <img src="#{author[:avatar]}">
                      | <a href="#{author[:url]}">#{author[:name]}</a> 
                      | authored the changes:
                      ul.nodec
                        - activities.each do |activity|
                          li
                            pre
                              = "#{activity[:commit_message]}"
                            small 
                              a href="#{activity[:commit_url]}"
                                | View this commit on github
        #contributors
          - if @contributors
            h2 Contributors
            p
              |Browse the <a href="/activity">latest activity</a>
            p
              | These recipes are provided by the following outsanding members of the Sinatra 
              | community:
            dl id="contributors"
              - @contributors.each do |contributor|
                dt
                  a href="http://github.com/#{contributor["login"]}"
                    img src="http://www.gravatar.com/avatar/#{contributor["gravatar_id"]}?s=50"
        #footer
          - if @readme
            h3 Did we miss something?
            p
             | It's very possible we've left something out, that's why we need your help!
             | This is a community driven project after all. Feel free to fork the project 
             | and send us a pull request to get your recipe or tutorial included in the book. 
            p 
             | See the <a href="http://github.com/sinatra/sinatra-recipes#readme">README</a> 
             | for more details.

        small
          a href="#top" Top


@@ style
body
  font-family: 'Lucida Grande', Verdana, sans-serif
  margin: 0 auto
  max-width: 976px
  font-size: 0.85em
  line-height: 1.25em
  color: #444444

.nodec li
  display: block
  margin-top: 25px


h1, h2, h3, h4, h5
  font-family: Georgia, 'bitstream vera serif', serif
  margin: 40px 0 20px 0
  color: #222222
  line-height: 1.5em

h1
  font-size: 2em

h2
  font-size: 1.5em

h3
  font-size: 1.35em

h4
  font-size: 1.2em

a:link, a:visited
  color: #3F3F3F

a:hover, a:active
  color: #8F8F8F

small
  font-size: .7em

#header
  margin: 10px 0px 50px 0px
  overflow: hidden
  a
    text-decoration: none
    float:left
    overflow: hidden
  h1
    margin: 20px 0 10px 0
  .caption
    float: left
    font-family: Georgia
    font-style: oblique

  img
    float: left
    width: 100px
    margin: 20px 15px 0px 0px
    border: 0

nav
  #selectNav
    width: 100%


#contributors dt
  display: inline-block

#children
  ul li
    float: left
    width: 275px
    height: 40px

li
  p
    margin: 0

#content
  float:left
  width: 70%
  h1, h2, h3, h4, h5
    span
      font-size: .8em
      margin-left: 10px
      a
        text-decoration: none
      a:link, a:visited
        color: #CCC
      a:hover, a:active
        color: #8F8F8F
#activity
  img
    height: 50px
    width: 50px
    padding-right: 15px
  ul
    padding-left: 0px
#sidebar
  width: 25%
  float: right
  margin-top: 30px
  padding: 0 20px

code, pre, tt
  font-family: 'Monaco', 'Menlo', consolas, inconsolata, monospace
  font-size: 0.85em
  border: 1px solid #cccccc
  border-radius: 3px
  background: #fafafa
  padding: 1px 2px

.clear
  clear: both
pre
  line-height: 1.6em
  padding: 5px 20px
  overflow: auto
  overflow-Y: hidden

#footer
  clear: both
  margin-top: 50px
  width: 70%
