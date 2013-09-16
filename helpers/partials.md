# Rails Style Partials

Using partials in your views is a great way to keep them clean.  Since Sinatra
takes the hands off approach to framework design, you'll have to implement a
partial handler yourself.

Depending on the complexity of partials you'd like to use, you should pick
between one of the following three strategies, presented below. A simple demo
of these strategies is available here: [Sinatra Partials Demo](https://github.com/ashleygwilliams/sinatra_partials_demo)

Thanks to [DAZ](https://github.com/daz4126) for a lot of the code, originally published on his blog ["I Did it my Way"](http://ididitmyway.herokuapp.com/past/2010/5/31/partials/)

## Simple Partial 
The simplest implementation of a partial create a method that takes a single
parameter, `template` and uses the same mechanism that is used to render a 
view, i.e. `erb`. However, unlike the traditional view rendering, where we 
would yield the view within a layout, when using a partial, the layout option
is set to false so that the layout is not rendered again. One used to have to
specify this, but that is no longer the case.

```ruby
helpers do
  def simple_partial(template)
    erb template
  end
end
```

Using the code above, calling `partial :header` will render the view 
`header.erb` in your views folder.

## Intermediate Partial 
The simple implementation is fine, but it simply renders a view within a view;
nothing to sophisticated. Web development is just fancy string concatenation
after all :)

Usually we want to do more than simply render a view within a view though, so
let's step it up a notch.

### _underscore Naming Convention 
First off: Rails uses a convention where partials are named beginning with an
underscore, but can be referenced by using a symbol with the template name sans
underscore.

e.g. `partial :header` renders `_header.erb`

In order to do this we can modify our partial to include the line:

```ruby
template = :"_#{template}"
```

This gives us:

```ruby
helpers do
  def intermediate_partial(template)
    template = :"_#{template}"
    erb template      
  end
end
``` 

** NOTE: If you are using [ActiveRecord](/p/models/active_record?#article) or 
any other gem that has ActiveSupport as a dependency, you do not need to
implement this portion of the method, as it will be already assumed that your
partials begin with an underscore and that you reference them with out it.

### Passing Local Variables 
Secondly: it is also useful to be able to pass local variables to your partial.
To implement this we can add a `locals` parameter to our partial. This 
parameter will hold a hash, and will default to `nil`. We will pass this 
`locals` parameter to `erb` alongside our template, like so:

```ruby
erb template, {}, locals
```

** NOTE: `erb` takes ordered parameters, including an options hash between the
`template` and the `locals` hash, so we need to pass an empty hash.

Rails takes this a step further: if the name of the local variable is the same
as the name of the partial, you do not need to explicitly set it. This is
handled by the line: 

```ruby
locals = locals.is_a?(Hash) ? locals : {template.to_sym => locals}
```

This checks to see if locals is a hash, and if it is not, it will build a hash
with a single key value pair, where the key is the name of the template and 
the value is the non-hash value of `locals`.

This leaves us with our finished intermediate partial, which now supports the
underscore naming convention and the explicit and implicit passing of local
variables:

```ruby
helpers do
  def intermediate_partial(template, locals=nil)
    locals = locals.is_a?(Hash) ? locals : {template.to_sym => locals}
    template = :"_#{template}"
    erb template, {}, locals        
  end
end
``` 

The syntax for using this partial is:

 - `<%= partial :partial_name, "local_value" %>`

    where `locals = {:partial_name => "local_value"}`

 - `<%= partial :partial_name, {:local_variable => "local_value"} %>`

    where `locals = {:local_variable => "local_value"}`

All of the above will render the `_partial_name.erb` view.

## Advanced Partial 
Passing local variables is great, but Rails lets us pass collections of local
variables to a partial, rendering it once for each element of the collection.

For example:

If I have a before filter in my `app.rb` that assigns the variable `@cats` a
random number of Cat objects, I would like to call `<%= partial @cats %>` to
render an index of all of my cat objects.

See this exact example in action here: [Sinatra Partials Demo]([Sinatra Partials Demo](https://github.com/ashleygwilliams/sinatra_partials_demo))

Let's take a look at how this code works:

### Which template? 
First we check to see if we have passed the name of a partial at all, or if
simply intend to use the partial that shares a name with the local variable
we are passing. If a template name is passed, we define the template to be
rendered as that (prepending the underscore like we did in the intermediate
partial). This is all accomplished in the first conditional:

```ruby
if template.is_a?(String) || template.is_a?(Symbol)
  template = :"_#{template}"
else
  locals=template
  template = template.is_a?(Array) ? :"_#{template.first.class.to_s.downcase}" : :"_#{template.class.to_s.downcase}"
end
```

If there is no string or symbol passed, it is assumed that we would like to
render the partial named after the class of the object(s) we are passing as a
local variable. We check whether the local variable is a collection, and then
name the template based on the class of the object(s):

```ruby
  template = template.is_a?(Array) ? :"_#{template.first.class.to_s.downcase}" : "_#{template.class.to_s.downcase}"
```

### What local variable(s)? 
Now that we know what template to render, we need to figure out what local 
variables are being passed; we have 4 potentials:

- a value
- a Hash 
- a collection of Objects
- no locals

This is all accomplised in the second conditional:

```ruby
if locals.is_a?(Hash)
  erb template, {}, locals      
elsif locals
  locals=[locals] unless locals.respond_to?(:inject)
  locals.inject([]) do |output,element|
    output << erb(template,{},{template.to_s.delete("_").to_sym => element})
  end.join("\n")
else 
  erb template, {}
end
```

When we put this all together we get:

```ruby
helpers do

  def adv_partial(template,locals=nil)
    if template.is_a?(String) || template.is_a?(Symbol)
      template = :"_#{template}"
    else
      locals=template
      template = template.is_a?(Array) ? :"_#{template.first.class.to_s.downcase}" : :"_#{template.class.to_s.downcase}"
    end
    if locals.is_a?(Hash)
      erb template, {}, locals      
    elsif locals
      locals=[locals] unless locals.respond_to?(:inject)
      locals.inject([]) do |output,element|
        output << erb(template,{},{template.to_s.delete("_").to_sym => element})
      end.join("\n")
    else 
      erb template
    end
  end

end 
```

We can use this partial just as we used the intermediate partial, but we can 
also use it in new ways:

- `<%= partial @object %>` 
    where it renders the template `_object.erb` 
    and `locals = {:object => object}`

- `<%= partial @objects %>` 
    where it renders the template `_object.erb` 
    for each element in `@objects`
    where, for each, `locals = {:object => an_object_from_objects}`

## Complex Partial 
from [Padrino](https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers/render_helpers.rb)

```ruby
def partial(template, options={})
  options.reverse_merge!(:locals => {}, :layout => false)
  path            = template.to_s.split(File::SEPARATOR)
  object_name     = path[-1].to_sym
  path[-1]        = "_#{path[-1]}"
  explicit_engine = options.delete(:engine)
  template_path   = File.join(path).to_sym
  raise 'Partial collection specified but is nil' if options.has_key?(:collection) && options[:collection].nil?
  if collection = options.delete(:collection)
    options.delete(:object)
    counter = 0
    collection.map { |member|
      counter += 1
      options[:locals].merge!(object_name => member, "#{object_name}_counter".to_sym => counter)
      render(explicit_engine, template_path, options.dup)
    }.join("\n").html_safe
  else
    if member = options.delete(:object)
      options[:locals].merge!(object_name => member)
    end
    render(explicit_engine, template_path, options.dup).html_safe
  end
end

alias :render_partial :partial

```
