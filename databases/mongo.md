Mongo
-----
- [Finding](#find)
- [Inserting](#insert)
- [Updating](#update)
- [Deleting](#delete)

[Mongo][mongo] is a document-oriented database. Though Object Relational
Mappers (ORMs) are often used to connect to databases, you will see here
that it is very easy to connect your applications to a Mongo database
without the use of an ORM, though several exist. See the 
[Mongo models][mongo_models] page for a discussion of some of the ORMs
available.

The first step is in connecting your application to an instance of Mongo is
to create a connection. You can do this in your _configure_ block:

    require 'rubygems'
    require 'sinatra'
    require 'mongo'
    require 'json' # required for .to_json
  
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

    helpers do
      # a helper method to turn a string ID
      # representation into a BSON::ObjectId
      def object_id val
        BSON::ObjectId.from_string(val)
      end
      
      def document_by_id id
        id = object_id(id) if String === id
        settings.mongo_db['test'].
          find_one(:_id => id).to_json
      end
    end
<span style='font-size: smaller'>([top](#top))</span>

<a name='find' />
###Finding Records###

    # list all documents in the test collection
    get '/documents/?' do
      content_type :json
      settings.mongo_db['test'].find.to_a.to_json
    end

    # find a document by its ID
    get '/document/:id/?' do
      content_type :json
      document_by_id(params[:id]).to_json
    end
<span style='font-size: smaller'>([top](#top))</span>

<a name='insert' />
###Inserting Records###

    # insert a new document from the request parameters,
    # then return the full document
    post '/new_document/?' do
      content_type :json
      new_id = settings.mongo_db['test'].insert params
      document_by_id(new_id).to_json
    end
<span style='font-size: smaller'>([top](#top))</span>

<a name='update' />
###Updating Records###

    # update the document specified by :id, setting its
    # contents to params, then return the full document
    put '/update/:id/?' do
      content_type :json
      id = object_id(params[:id])
      settings.mongo_db['test'].update(:_id => id, params)
      document_by_id(id).to_json
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
      document_by_id(id).to_json
    end
<span style='font-size: smaller'>([top](#top))</span>

<a name='delete' />
###Deleting Records###

    # delete the specified document and return success
    delete '/remove/:id' do
      content_type :json
      settings.mongo_db['test'].
        remove(:_id => object_id(params[:id]))
      {:success => true}.to_json
    end
<span style='font-size: smaller'>([top](#top))</span>

For more information on using the Ruby driver without an ORM take a look at [MongoDB's tutorial][rubydrivertutorial].

[mongo]: http://www.mongodb.org/
[rubydrivertutorial]: http://api.mongodb.org/ruby/current/file.TUTORIAL.html
[mongo_models]: /p/models/mongo
