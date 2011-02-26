require 'rubygems'
require 'bundler/setup'
require "#{File.dirname(__FILE__)}/app"
run Sinatra::Application
