# Asset Management
There are quite a few reasons why a production app should have proper 
asset management (CSS, JS, Image files).


## Why Asset Management
  "Why should I care about asset management?"

  A typical app ends up with many `.css` and `.js` (or `.coffee` for that matter)
especially if you use a lot of external plugins such as the excellent Compass 
framework or say, Ember.js

Serving uncompressed/minified assets is a crime in itself and that's one reason 
why many libraries like jQuery and Ember provide a minified version of the library.

Even if you have a minifed version of those vendor plugins, you probably follow 
best practices and write your `.css`|`.sass` and `.js`|`.coffee` code in a modular 
fashion and end up with a bunch of those files that need to be served to the end-user.

There are many tools available that would optimize the assets for you. Some of the tools
available in Ruby are:

* Sinatra-Assetpack
* Sprockets
* Rake-pipeline

In general, these tools do the following:

* Compile (If they are written in, say, Sass or Coffeescript)
* Concatenate 
* Compress
* Cache busting


### Compile

If you use sass/scss/less/coffeescript in your app, before serving the files, they 
need to be compiled into CSS/Javascript. 

### Concatenate

Multiple files may be concatenated into a single file and so, instead of having:

    script src="jquery.js"
    script src="foundation.js"
    script src="home.js"
    script src="feed.js"
    script src="collections.js"
    script src="ember.js"
    script src="app.js"

you'll end up with:
    
    script src="application.js"


### Compress

The compress step involves minifying the Javascript files (and CSS files) by removing extra 
whitespaces which add to the file size and replacing long variable names with shorter ones 
inside function bodies. Note that it won't change the API – only internal variables will 
be changed. This step reduces the sizes of JS and CSS files by a huge margin.

### Cache busting

Browser-caching can be used to ensure the files won't be downloaded from the server for 
every request. Many browsers check for the availability of the static files in the local 
cache before sending the request to the server. 

Cache busting is a procedure where the assets are numbered with a unique number that lets 
the browser download the latest version of the assets. For example, assume that the 
name of the compressed javscript file as "app.js" for a version of your production app 
that was pushed yesterday. If you enabled caching by sending  a "Cache-Control:public",
the "app.js" gets stored in the browser cache.

Now, if you've changed the "app.js" file today and pushed the new change to the server, the 
browser may still load the cached "app.js" and not the new one. 

This problem may be avoided by having a unique number after the name that changed per commit 
that lets the browser know the latest version of the asset.



All the above steps are handled by the tools mentioned previously.


## Thinking in pipelines in Sinatra


A typical app consists of many assets usually stored in the public directory 
which is the default for Sinatra application. The structure is something similar 
to this:

    app.rb
    |
    |public/
           |css
           |js
           |images
 
The files then are accessible in the views with the urls: `css/app.css`, 
'js/app.js` etc. If your app uses other plugins such as the excellent Compass 
framekwork or Ember.js, you'll find that the number of files and the file sizes 
increase which slows the download of your app/site when deployed in production.

For this reason, a lot of tools have been developed to ensure that the files are 
concatenated and compressed. Some of the tools are:

* Sinatra-assetpack
* Sprockets
* Rake-pipeline


