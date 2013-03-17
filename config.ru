require 'rubygems'
require 'bundler/setup'
require File.expand_path '../app.rb', __FILE__
run Sinatra::Application
