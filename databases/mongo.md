# Mongo

[Mongo][mongo] is a document-oriented database. Though Object Relational
Mappers (ORMs) are often used to connect to databases, you will see here
that it is very easy to connect your applications to a Mongo database
without the use of an ORM, though several exist. See the
[Mongo models][mongo_models] page for a discussion of some of the ORMs
available.

Install the required gems:

```
gem install mongo
gem install bson_ext
```

The first step is in connecting your application to an instance of Mongo is
to create a connection. You can do this in your _configure_ block:

The examples below are based on MongoDB Ruby driver 2.0.x (it supports MRI
1.9.x and above)

```ruby
require 'rubygems'
require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

configure do
  db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')  
  set :mongo_db, db[:test]
end
```

After creating a client to a MongoDB server, you can use the driver to
communicate with the database.

```ruby
get '/collections/?' do
  content_type :json
  settings.mongo_db.database.collection_names.to_json
end

helpers do
  # a helper method to turn a string ID
  # representation into a BSON::ObjectId
  def object_id val
    begin
      BSON::ObjectId.from_string(val)
    rescue BSON::ObjectId::Invalid
      nil
    end
  end

  def document_by_id id
    id = object_id(id) if String === id
    if id.nil?
      {}.to_json
    else
      document = settings.mongo_db.find(:_id => id).to_a.first
      (document || {}).to_json
    end
  end
end
```

## Finding Records

```ruby
# list all documents in the test collection
get '/documents/?' do
  content_type :json
  settings.mongo_db.find.to_a.to_json
end

# find a document by its ID
get '/document/:id/?' do
  content_type :json
  document_by_id(params[:id])
end
```

## Inserting Records

```ruby
# insert a new document from the request parameters,
# then return the full document
post '/new_document/?' do
  content_type :json
  db = settings.mongo_db
  result = db.insert_one params
  db.find(:_id => result.inserted_id).to_a.first.to_json
end
```

## Updating Records

```ruby
# update the document specified by :id, setting its
# contents to params, then return the full document
put '/update/:id/?' do
  content_type :json
  id = object_id(params[:id])
  settings.mongo_db.find(:_id => id).
    find_one_and_update('$set' => params)
  document_by_id(id)
end

# update the document specified by :id, setting just its
# name attribute to params[:name], then return the full
# document
put '/update_name/:id/?' do
  content_type :json
  id   = object_id(params[:id])
  name = params[:name]
  settings.mongo_db.find(:_id => id).
    find_one_and_update('$set' => {:name => name})
  document_by_id(id)
end
```

## Deleting Records

```ruby
# delete the specified document and return success
delete '/remove/:id' do
  content_type :json
  db = settings.mongo_db
  id = object_id(params[:id])
  documents = db.find(:_id => id)
  if !documents.to_a.first.nil?
    documents.find_one_and_delete
    {:success => true}.to_json
  else
    {:success => false}.to_json
  end
end
```

For more information on using the Ruby driver without an ORM take a look
at [MongoDB's tutorial][rubydrivertutorial].

[mongo]: http://www.mongodb.org/
[rubydrivertutorial]: https://github.com/mongodb/mongo-ruby-driver/wiki/Tutorial
[mongo_models]: http://recipes.sinatrarb.com/p/models/mongo
