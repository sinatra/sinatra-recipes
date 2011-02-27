Ohm
------------

[Ohm](http://ohm.keyvalue.org/) is an object hash-mapping library for the [Redis](http://redis.io/) database.

Require the Ohm gem in your app:

    require 'rubygems'
    require 'sinatra'
    require 'ohm'

Configure Ohm for your environment:

    configure :production do
      Ohm.connect(:url => ENV["MY_REDIS_URL"])
    end

Create a model class and a Redis index to allow fast lookups:

    class Post < Ohm::Model
      attribute :title
      attribute :body
      index :title
    end
    
Save a new instance of your model from a route:

    post '/post' do
      Post.create :title => params[:title],
                  :body => params[:body]
    end

Find and render instances of your model matching a criteria:

    get '/posts/:title' do
      @posts = Post.find(:title => params[:title])
      erb :index
    end
    
This will render ./views/index.erb:

    <% for post in @posts %>
      <h1><%= post.title %></h1>
    <% end %>
    
