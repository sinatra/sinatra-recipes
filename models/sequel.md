# Sequel

Require the Sequel gem in your app:

```ruby
require 'rubygems'
require 'sinatra'
require 'sequel'
```

Use a simple in-memory DB:

```ruby
require 'sqlite3'
DB = Sequel.sqlite
```

Create a table:

```ruby
DB.create_table :links do
  primary_key :id
  varchar :title
  varchar :link
end
```

Create the Model class:

```ruby
class Link < Sequel::Model; end
```

Create the route:

```ruby
get '/' do
  @links = Link.all
  haml :links
end
```
