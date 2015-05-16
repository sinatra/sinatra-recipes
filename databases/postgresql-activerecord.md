# PostgreSQL

[PostgreSQL](http://www.postgresql.org/) is an object-relational database management system (ORDBMS).

The connection between PostgreSQL and Ruby happens via the [`pg`](https://rubygems.org/gems/pg) gem.

## Installation

[Install PostgreSQL](http://www.postgresql.org/download/)


Install Ruby Postgres bridge
```
gem install pg
```

*Note:* OSX Users may have troubles with the installation of the `pg` gem. Read [this](http://stackoverflow.com/a/19850273/2980299)


```
gem install activerecord
gem install sinatra-activerecord
gem install rake # to apply migrations
```


## Connect to the database

Either by making a `config/database.yml` file that gets automatically loaded

```
development:
  adapter: postgresql
  encoding: unicode
  database: database_name
  pool: 2
  username: your_username
  password: your_password

production:
  adapter: postgresql
  encoding: unicode
  database: database_name
  pool: 2
  username: your_username
  password: your_password
```

or by specifying in your sinatra app

```ruby
# app.rb
configure :development do
  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'your_database_name', pool: 2, username: 'your_username', password: 'your_password'}
end

configure :production do
  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'your_database_name', pool: 2, username: 'your_username', password: 'your_password'}
end
```

## Create models
```ruby
# models/article.rb
class Article < ActiveRecord::Base
end
```

## Create migrations

First, create a `Rakefile` or update your `Rakefile` to require `activerecord` and `activerecord/rake`

```
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './app'
...
```

Then create a migration as shown:

```
▶ rake db:create_migration NAME=create_articles

db/migrate/20150516144225_create_articles.rb
```

Now lets edit `db/migrate/20150516144225_create_articles.rb`.

```ruby
class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.boolean :published, :default => false
      t.datetime :published_on, :required => false
      t.integer :likes, :default => 0
      t.timestamps null: false
    end
  end
end
```

## CRUD operations in routes

```ruby
# routes.rb
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

get '/articles' do
  ...
  @articles = Article.all
  ...
end


get '/articles/:id' do
  ...
  @article = Article.find(params[:id])
  ...
end

post '/articles' do
  ...
  @article = Article.create(params[:article])
  ...
end

put '/articles/:id/publish' do
  ...
  @article = Article.find(params[:id])
  @article.publish!
  ...
end

delete '/articles/:id' do
  ...
  Article.destroy(params[:id])
  ...
end
```
