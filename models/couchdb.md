CouchDB
-------

There are several data modelling libraries for CouchDB. We're going to introduce CouchRest Model.

Require couchrest_model gem in your app:

    require 'couchrest_model'
    
Specify the database URL:

    configure do
      $COUCH = CouchRest.new ENV["COUCHDB_URL"]
      $COUCH.default_database = ENV["COUCHDB_DEFAULT_DB"]
      $COUCHDB = $COUCH.default_database
    end

Create the Model class:

    class Post < CouchRest::Model::Base
      use_database $COUCHDB

      property :title, String
      property :body, String

      design do
        view :by_title
      end
    end

Save a new instance of your model from a route:

    post '/post' do
      @post = Post.create :title => params[:title], :body => params[:body]
      redirect "/posts/#{@post.title}"
    end

Find and render instances of your model matching a criteria:

    get '/posts/:title' do
      @posts = Post.by_title(:key => params[:title])
      erb :posts
    end

This will render ./views/posts.erb:

    <% for post in @posts %>
    <div>
      <h1><%= post.title %></h1>
      <p><%= post.body %></p>
    </div>
    <% end %>

Full documentation on [CouchRest and CouchRest Model](http://www.couchrest.info/).