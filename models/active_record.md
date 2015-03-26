# ActiveRecord

First require ActiveRecord gem in your application, then give your database
connection settings:

```ruby
require 'rubygems'
require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'sinatra_application.sqlite3.db'
)
```

Now you can create and use ActiveRecord models just like in Rails (the example
assumes you already have a 'posts' table in your database):

```ruby
class Post < ActiveRecord::Base
end

get '/' do
  @posts = Post.all()
  erb :index
end
```

This will render `./views/index.erb`:

```erb
<% @posts.each do |post| %>
  <h1><%= post.title %></h1>
<% end %>
```
