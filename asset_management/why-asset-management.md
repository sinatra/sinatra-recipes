# Why Asset Management

A typical app ends up with many `.css` and `.js` (or `.coffee` for
that matter) especially if you use a lot of external plugins such as
the Compass framework or say, Ember.js

Serving uncompressed/minified assets is not advisable and that is one
of the reason why some of the popular libraries like jQuery and Ember
provide a minified version of the library out of the box.

Even if you have a minifed version of those vendor plugins, if you opt to
follow best practices and write your `.css`|`.sass` and `.js`|`.coffee`
code in a modular fashion, you'll end up with a bunch of those files that
need to be served to the end-user.

To optimize and better manage your workflow involving your app's assets,
there are quite a few tools available. Some of the tools are available as
gems and some are available as GUI applications.

In general, these tools do the following:

* Compile (If they are written in, say, Sass or Coffeescript)
* Concatenate
* Compress
* Cache busting

## Compile

As the name suggests, this step coverts the markup scripts to plain old `css`
or `js` (from `sass`, `coffeescript`)

## Concatenate

Multiple files may be concatenated into a single file and so, instead of
having:

```html
<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript" src="foundation.js"></script>
<script type="text/javascript" src="home.js"></script>
<script type="text/javascript" src="feed.js"></script>
<script type="text/javascript" src="collection.js"></script>
<script type="text/javascript" src="ember.js"></script>
<script type="text/javascript" src="app.js"></script>
```

you'll end up with:

```html
<script type="text/javascript" src="application.js"></script>
```

## Compress

The compress step involves minifying the Javascript files (and CSS files)
by removing extra whitespaces which add to the file size and replacing
long variable names with shorter ones inside function bodies. Note that
it won't change the API – only internal variables will be changed. This
step reduces the sizes of JS and CSS files by a large extent.

## Cache busting

Browser-caching can be used to ensure the files won't be downloaded from
the server for every request. Many browsers check for the availability of
the static files in the local cache before making a request to the
server.

Cache busting is a procedure where the assets are numbered with a unique
number that lets the browser download the latest version of the assets.
For example, assume that the name of the compressed javscript file as
"app.js" for a version of your production app that was pushed yesterday.
If you enabled caching by sending  a `Cache-Control:public`, the "app.js"
gets stored in the browser cache.

Now, if you've changed the "app.js" file today and pushed the new change
to the server, the browser may still load the cached "app.js" and not
the new one.

This problem may be avoided by having a unique number added to the end
of the filename which is changed once for every compilation-concatenation-
compress step. This ensures that the browser knows the version of the file
stored in the cache and the version that is in the server. If there is a
difference between these two, only then the newer asset will be downloaded.
