## Omniauth

[OmniAuth](https://github.com/intridea/omniauth) is an authentication solution
that standarizes multi-provider authentication for web applications. It
provides several strategies (released as gems) that provides authentication
for a lot of systems, such as
Facebook ([omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook)),
Twitter ([omniauth-twitter](https://github.com/arunagw/omniauth-twitter)),
Google ([omniauth-google-oauth2](https://github.com/zquestz/omniauth-google-oauth2)),
GitHub ([omniauth-github](https://github.com/intridea/omniauth-github)),
LDAP ([omniauth-ldap](https://github.com/intridea/omniauth-ldap)),
and many more.

Each strategy is a Rack middleware, so it's very easy to integrate with
Sinatra. This recipe will show you how to add user authentication to your
Sinatra application using Twitter as your authentication provider.

First, you have to create a new application on
[Twitter Developers](https://dev.twitter.com/). It's very important to set
the `Callback url` to `http://example.com/auth/twitter/callback`. This url is
where twitter will redirect when the user is successfully authenticated. Once
you created your application, you have to remember it's `Consumer key` and
`Consumer secret`. You will need them when you configure Omniauth, like this:

```ruby
require 'sinatra'
require 'omniauth-twitter'

configure do
  enable :sessions

  use OmniAuth::Builder do
    # replace CONSUMER_KEY and CONSUMER_SECRET with
    # the appropiate info
    provider :twitter, CONSUMER_KEY, CONSUMER_SECRET
  end
end
```

Then, you have to secure your application by redirecting non-authenticated
users to twitter, so they can sign in:

```ruby
helpers do
  # define a current_user method, so we can be sure if an user is authenticated
  def current_user
    !session[:uid].nil?
  end
end

before do
  # we do not want to redirect to twitter when the path info starts
  # with /auth/
  pass if request.path_info =~ /^\/auth\//

  # /auth/twitter is captured by omniauth:
  # when the path info matches /auth/twitter, omniauth will redirect to twitter
  redirect to('/auth/twitter') unless current_user
end
```

Lastly, you have create a new user session when the authentication was
successful:

```ruby
get '/auth/twitter/callback' do
  # probably you will need to create a user in the database too...
  session[:uid] = env['omniauth.auth']['uid']
  redirect to('/')
end

get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
end
```

## Complete example

```ruby
require 'sinatra'
require 'omniauth-twitter'

configure do
  enable :sessions

  use OmniAuth::Builder do
    # replace CONSUMER_KEY and CONSUMER_SECRET with
    # the appropiate info
    provider :twitter, CONSUMER_KEY, CONSUMER_SECRET
  end
end

helpers do
  # define a current_user method, so we can be sure if an user is authenticated
  def current_user
    !session[:uid].nil?
  end
end

before do
  # we do not want to redirect to twitter when the path info starts
  # with /auth/
  pass if request.path_info =~ /^\/auth\//

  # /auth/twitter is captured by omniauth:
  # when the path info matches /auth/twitter, omniauth will redirect to twitter
  redirect to('/auth/twitter') unless current_user
end

get '/auth/twitter/callback' do
  # probably you will need to create a user in the database too...
  session[:uid] = env['omniauth.auth']['uid']
  redirect to('/')
end

get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem.
  # so you can implement this as you please
end

get '/' do
  'Hello Omniauth!'
end
```
