Sequel
------

Require the Sequel gem in your app:

    require 'rubygems'
    require 'sinatra'
    require 'sequel'

Use a simple in-memory DB:

    DB = Sequel.sqlite

Create a table:

    DB.create_table :links do
     primary_key :id
     varchar :title
     varchar :link
    end

Create the Model class:

    class Link < Sequel::Model
    end

Create the route:
   
    get '/' do
     @links = Link.all
     haml :links
    end


