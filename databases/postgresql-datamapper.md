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
gem install data_mapper
gem install dm-postgres-adapter
```

## Create User and Database (if not already existent)

```
sudo su -i postgres

createuser --interactive <user>

createdb <database>
```


## Connect to the database

```ruby
configure :development do
  DataMapper.setup(:default, 'postgres://user:password@hostname/database')
end

configure :production do
  DataMapper.setup(:default, 'postgres://user:password@hostname/database')
end
```


## Create models

```ruby
# models/article.rb
require 'data_mapper'


class Article
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :content, Text
  property :published, Boolean, default: false
  property :published_on, Date, required: false
  property :likes, Integer, default: 0

  def publish!
    @published = true
    @published_on = Date.today
  end
end

DataMapper.finalize
```

## Migrate models

```
irb
# in irb
irb(main):001:0> require_relative 'main.rb'
=> true
irb(main):002:0> Article.auto_migrate!
```

## Optional classic migrations (as in ActiveRecord)

```ruby
# migrations.rb
require 'dm-migrations/migration_runner'

migration 1, :create_articles_table do
  up do
    create_table :articles do
      column :id,   Integer, :serial => true
      column :title, String
      column :content, Text
      column :published, Boolean, :default => false
      column :published_on, Date, :required => false
      column :likes, Integer, :default => 0
    end
  end

  down do
    drop_table :articles
  end
end

migrate_up!
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
  @article = Article.get(params[:id])
  ...
end

post '/articles' do
  ...
  @article = Article.create(params[:article])
  ...
end

put '/articles/:id/publish' do
  ...
  @article = Article.get(params[:id])
  @article.publish!
  ...
end

delete '/articles/:id' do
  ...
  Article.get(params[:id]).destroy
  ...
end
```
