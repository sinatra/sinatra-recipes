# Using Rack::Parser to encapsulate parsing logic in web service applications

Sinatra is often used for web service applications. One common need these
applications have is to parse incoming messages, typically JSON or XML.

Often this is a two step process -- first parsing the message string into
predictable data structures, then loading that into models. So a typical route
might look like

```ruby
post '/messages' do
  message = Message.from_hash( ::MultiJson.decode(request.body) )
  message.save
  halt 201, {'Location' => "/messages/#{message.id}"}, ''
end
```

And your Message model would have an appropriate `#from_hash` method that
grabs what it needs from the parsed message and throws it into a new instance.

If your application has several different endpoints, all using the same
content-type, you could save some repetition by moving it to a helper:

```ruby
helpers do
  def parsed_body
    ::MultiJson.decode(request.body)
  end
end

post '/orders' do
  order = Order.from_hash( parsed_body )
  order.process
  # ....
end
```

This works fine for simple scenarios. But if you have multiple content-types,
need to validate the message format, or do other pre-processing on it, moving
the parsing logic out of your application itself starts to become attractive.

One option is to move it into a module that your app extends.

But another option is to do the parsing in a middleware. That way, your app is
not responsible for doing the basic parsing at all -- it's done and exposed to
your app by the time the request arrives.

The idea is *to mimic what Rack does to process form data*, which is to populate
the `env[rack.request.form_hash]` with a hash, and then expose that through the
`params` hash. But instead of parsing url parameters or multipart form data, it
will parse the XML or JSON body.

**`Rack::Parser`** is a Rack middleware that does just that, and lets you
configure custom parsing routines for any given content-type.

So using Rack::Parser, the example above would be changed to

```ruby
# in config.ru
use Rack::Parser, :content_types => {
  'application/json'  => Proc.new { |body| ::MultiJson.decode body }
}

# in application
post '/orders' do
  order = Order.from_hash( params['order'] )
  order.process
  # ....
end
```

This is quite convenient if your app accepts either form data or JSON for a
given endpoint -- since the code is then identical whether a user submits a
form directly or some web-service client submits a JSON request.

## Custom parsing

Note that the content-type handlers are just procs (or anything that responds to
`#call`) that take a single parameter -- the request body.

This makes it quite easy to set up custom parsing, validation, or other pre-
processing.

Rack::Parser also has recently added support for error handling, so that errors
in parsing can be mapped into a suitable http response, and logged. This is
quite useful for handling validation errors.

For instance, say you have set up vendor-specific json message formats, which
you want to validate using a `validate_input` class method on your models.

```ruby
class MyJsonParser

  def initialize(validator_class)
    @klass = validator_class
  end

  def call(body)
    json = ::MultiJson.decode(body)
    if @klass.respond_to?(:validate_input)
      @klass.validate_input(json)
    end
    json
  end

end

use Rack::Parser, :parsers => {
  'application/vnd-my-message+json' => MyJsonParser.new(Message),
  'application/vnd-my-order+json'   => MyJsonParser.new(Order)
}
```


Then any parsing error raised in `MulitJson.decode` or validation error in
`validate_input` will result in a 400 (bad request) response *in the same
content-type as the request* -- like

```ruby
{"errors": "Validation error in input - cannot set 'private_info'"}
```

This is the default; you can also completely customize how errors are converted
into responses, per content-type. Both the error and the content type is passed
down to the handler.

```ruby
use Rack::Parser, :handlers => {
  'application/xml' => proc { |err, type| [400, '<?xml version="1.0"?><response><error>Something went wrong</error></response>'] }
}
```


## For more info

[Rack::Parser](https://github.com/achiu/rack-parser)
