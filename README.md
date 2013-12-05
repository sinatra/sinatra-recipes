# Sinatra Recipes

Community contributed recipes and techniques for the [Sinatra Web
Framework][sinatra].

## Why yet another doc project?

Quite simply, the Sinatra README and Book have become long in the tooth.

This project is to extract any redundant and overlap between the two sources,
and create a home for user contributed recipes and documentation to take form.

## How can I help?

Got a recipe or tutorial for [Sinatra][sinatra]? Awesome, this is
the first place you should go if you're looking to contribute.

Once you have [forked the project][github-forking] send a [pull
request][github-pull-requests], just be sure to follow the [styling
guidelines][style-guidelines].

You can also get a hold of us on [irc][irc] or the [mailinglist][mailinglist].

Don't have any ideas? Check out the existing [issue tracker][issues] for
recipes that have been requested or are in progress.

## Here's the run down

To get started you should clone the repository from GitHub:

```bash
git clone git://github.com/sinatra/sinatra-recipes.git
```

Now once you `cd` into `sinatra-recipes` you should see a few things.

First you should take note of the application files:

```bash
app.rb # a tiny application for displaying the contributed recipes
config.ru # rackup file for deploying to heroku
Gemfile # dependencies file for bundler to run the app
```

If you want to run the application yourself first you need the `bundler` gem.

```bash
gem install bundler
```

If you are on Rubinius make sure that you have the latest bundler version
installed. Versions prior to 1.0.10 won't work.

```bash
# then install the application dependencies
bundle install
```

Once that is complete, you should only need to run `rackup` in the application
root and visit: [localhost:9292](http://localhost:9292)

Since the application just maps the flat files, you can browse either the
source or the web app to view recipes.

If you check out the source you will see a few folders listed, in each folder
there is a `README.md` that will briefly explain the topic. This can also be
view by going to `/p/:topic` where `topic` is the folder you wish to view.

In each folder there should be a number of recipes pertaining to each topic.

## On translations

Currently we're not supporting translations in the main repository.

However, if you'd like to maintain a fork for translating the docs then feel
free to do so, and add your fork to the [list of translations in the
wiki][translations].

[sinatra]: http://www.sinatrarb.com/
[sinatra-book]: http://github.com/sinatra/sinatra-book
[issues]: https://github.com/sinatra/sinatra-recipes/issues
[style-guidelines]: http://github.com/sinatra/sinatra-recipes/wiki/Style-Guidelines
[translations]: http://github.com/sinatra/sinatra-recipes/wiki/Translations
[irc]: irc://irc.freenode.net/#sinatra
[mailinglist]: http://groups.google.com/group/sinatrarb
[github-forking]: http://help.github.com/forking/
[github-pull-requests]: http://help.github.com/pull-requests/
