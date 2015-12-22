## Slim

Slim is a template language whose goal is to reduce the view syntax to the
essential parts without becoming cryptic.
It is an alternative to `erb` or `haml`.

To start first you need to add `slim` to your Gemfile:

```ruby
gem 'slim'
```

and then run:

```
$ bundle install
```

Your ruby file should require both `sinatra` and `slim`. One important
thing to remember is that you always have to reference templates
with symbols (`:'blog/index'` or `'blog/index'.to_sym`).

```ruby
# app-name/app.rb

require 'sinatra'
require 'slim'

get '/' do
  slim :dashboard
end

get '/blog' do
  @posts = Post.all
  slim :'blog/index'
end
```

Example view files may look like this:


Layout:

```slim
/ app-name/views/layout.slim

doctype html
html
  head
    title app-name
  body
    == slim :header
    == yield
```

In the example above you are rendering template `== slim :header`-
it is an easy way to get partials functionality in Sinatra.

```slim
/ app-name/views/header.slim

ul
  li: a href='/' dashboard
  li: a href='/blog' blog
```

Index is being yielded in `layout.slim`.

```slim
/ app-name/views/blog/index.slim

h1 Welcome to my blog!

  - @posts.each do |post|
    p: a href="posts/#{post.id}"=post.title
    p=post.content
```

## Resources

For more details you may want to visit:
[slim docs](http://slim-lang.com/)
