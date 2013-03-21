# Shotgun

Shotgun will actually restart your application on every request. This has the
advantage over other reloading techniques of always producing correct results.
However, since it actually restarts your application, it is rather slow
compared to the alternatives. Moreover, since it relies on `fork`, it is not
available on Windows and JRuby.

Usage is rather simple:

```bash
gem install shotgun # run only once, to install shotgun
shotgun my_app.rb
```

If you want to run a modular application, create a file named `config.ru` with
similar content:

```ruby
require File.expand_path '../my_app.rb', __FILE__
run MyApp
```

And run it by calling `shotgun` without arguments.

The `shotgun` executable takes arguments similar to those of the `rackup`
command, run `shotgun --help` for more information.

