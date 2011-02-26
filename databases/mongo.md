Mongo
-----

[Mongo][mongo] is a document-oriented database. It is easy to connect your
applications to a Mongo database without the use of an Object Relational
Mapper (ORM). The first step is to create a connection to your Mongo instance.
You can do this in your _configure_ block:

    require 'rubygems'
    require 'sinatra'
    require 'mongo'
  
    configure do
      conn = Mongo::Connection.new("localhost", 27017)
      set :mongo_connection, conn
      set :mongo_db,         conn.db('test')
    end

With a connection "in hand" you can connect to any database and collection in
your Mongo instance.

    get '/collections/?' do
      settings.mongo_db.collection_names
    end

Using the Ruby driver you can find, insert, update, or delete from
your database (see more documentation at [MongoDB's tutorial][rubydrivertutorial]):

    helpers do
      # a helper method to turn a string ID
      # representation into a BSON::ObjectId
      def object_id val
        BSON::ObjectId.from_string(val)
      end
    end
    
    # list all documents in the test collection
    get '/list_documents/?' do
      content_type :json
      settings.mongo_db['test'].find.to_a.to_json
    end
    
    # insert a new document from the request parameters,
    # then return the full document
    post '/new_document/?' do
      content_type :json
      new_id = settings.mongo_db['test'].insert params
      settings.mongo_db['test'].
        find_one(:_id => new_id).
        to_json
    end
    
    # update the document specified by :id, setting its
    # contents to params, then return the full document
    put '/update/:id/?' do
      content_type :json
      id = object_id(params[:id])
      settings.mongo_db['test'].update(:_id => id, params)
      settings.mongo_db['test'].find_one(:_id => id).to_json
    end
    
    # update the document specified by :id, setting just its
    # name attribute to params[:name], then return the full
    # document
    put '/update_name/:id/?' do
      content_type :json
      id   = object_id(params[:id])
      name = params[:name]
      settings.mongo_db['test'].
        update(:_id => id, {"$set" => {:name => name}})
      settings.mongo_db['test'].find_one(:_id => id).to_json
    end
    
    # delete the specified document and return success
    delete '/remove/:id' do
      content_type :json
      settings.mongo_db['test'].
        remove(:_id => object_id(params[:id]))
      {:success => true}.to_json
    end
    
[mongo]: http://www.mongodb.org/
[rubydrivertutorial]: http://api.mongodb.org/ruby/current/file.TUTORIAL.html