# MongoDB

There are many ORMs out there for Mongo (or _ODMs_ in this case).
This page will go over just a few.

## Mongo

[Looking for the official
driver?](http://recipes.sinatrarb.com/p/databases/mongo?#article)

## MongoMapper

```ruby
require 'mongo_mapper'
```

Create the Model class

```ruby
class Link
  include MongoMapper::Document
  key :title, String
  key :link, String
end
```

Create the route:

```ruby
get '/' do
  @links = Link.all
  haml :links
end
```

## Mongoid

```ruby
require 'mongoid'
```

Create the Model class

```ruby
class Link
  include Mongoid::Document
  field :title, :type => String
  field :link, :type => String
end
```

Create the route:

```ruby
get '/' do
  @links = Link.all
  haml :links
end
```

## Candy

```ruby
require 'candy'
```

Create the Model class

```ruby
class Link
  include Candy::Piece
end

class Links
  include Candy::Collection
  collects :link   # Declares the Mongo collection is 'Link'
end

Link.connection # => Defaults to localhost port 27017
Link.db         # => Defaults to your username, or 'candy' if unknown
Link.collection # => Defaults to the class name ('Link')
```

Create the route:

```ruby
get '/' do
  @links = Links.all
  haml :links
end
```

## Mongomatic

```ruby
require 'mongomatic'
```

Create the Model class

```ruby
class Link < Mongomatic::Base
  def validate
    self.errors.add "title", "blank" if self["title"].blank?
    self.errors.add "link",  "blank" if self["link"].blank?
  end
end
```

Create the route:

```ruby
get '/' do
  @links = Link.all
  haml :links
end

def validate
  self.errors.add "name", "blank" if self["name"].blank?
  self.errors.add "email", "blank" if self["email"].blank?
  self.errors.add "address.zip", "blank" if (self["address"] || {})["zip"].blank?
end
```

## MongoODM

```ruby
require 'mongo_odm'
```

Create the Model class

```ruby
class Link
  include MongoODM::Document
  field :title
  field :link
end
```

Create the route:

```ruby
get '/' do
  @links = Link.find.to_a
  haml :links
end
```

## GitHub links

* [MongoMapper][mongomapper]
* [Mongoid][mongoid]
* [Candy][candy]
* [Mongomatic][mongomatic]
* [MongoODM][mongoodm]

[mongomapper]: http://mongomapper.com/
[mongoid]: http://mongoid.org/
[candy]: https://github.com/SFEley/candy
[mongomatic]: http://mongomatic.com/
[mongoodm]: https://github.com/carlosparamio/mongo_odm
