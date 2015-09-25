# RSS Feed

The [builder](https://github.com/jimweirich/builder) gem used for creating XML
markup is required in this recipe.

Let's first write our basic app to begin with:

```ruby
require 'sinatra'
require 'builder' # Don't forget this!

get '/rss' do
  @posts = # ... find posts
  builder :rss
end
```

Then, assuming that your site url is `http://liftoff.msfc.nasa.gov/`, we will
set up our view at `views/rss.builder`:

```ruby
xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Liftoff News"
    xml.description "Liftoff to Space Exploration."
    xml.link "http://liftoff.msfc.nasa.gov/"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link "http://liftoff.msfc.nasa.gov/posts/#{post.id}"
        xml.description post.body
        xml.pubDate Time.parse(post.created_at.to_s).rfc822()
        xml.guid "http://liftoff.msfc.nasa.gov/posts/#{post.id}"
      end
    end
  end
end
```

This will render the RSS inline, directly from the handler.
