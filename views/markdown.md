# Markdown Templates

The rdiscount gem/library is required to render Markdown templates:

```ruby
## You'll need to require rdiscount in your app
require "rdiscount"

get '/' do
  markdown :index
end
```

Renders `./views/index.markdown` (+md+ and +mkd+ are also valid file
extensions).

It is not possible to call methods from markdown, nor to pass locals to it. You
therefore will usually use it in combination with another rendering engine:

```ruby
erb :overview, :locals => { :text => markdown(:introduction) }
```

Note that you may also call the markdown method from within other templates:

```haml
%h1 Hello From Haml!
%p= markdown(:greetings)
```
