# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'terryblr/version'

Gem::Specification.new do |s|
  s.name        = "terryblr"
  s.version     = Terryblr::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lachlan Laycock", "Samuel Mendes", "Mathieu Raveaux", "Jérémy Van de Wyngaert"]
  s.email       = ["bonjour@aimele88.com"]
  s.homepage    = "http://aimele88.com"
  s.summary     = "KISS Content Management System"
  s.description = "Terryblr is an engine providing a evented CMS following a KISS principle"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "aasm"
  s.add_dependency "acts-as-taggable-on"
  s.add_dependency "acts_as_commentable"
  s.add_dependency "aws-s3"
  s.add_dependency "barista"
  s.add_dependency "bitly"
  s.add_dependency "bluecloth"
  s.add_dependency "cancan"
  s.add_dependency "delayed_job"
  s.add_dependency "devise"
  s.add_dependency "dropbox"
  s.add_dependency "dynamic_form"
  s.add_dependency "formtastic"
  s.add_dependency "gattica"
  s.add_dependency "oembed_links"
  s.add_dependency "grackle"
  s.add_dependency "haml"
  s.add_dependency "has_scope"
  s.add_dependency "htmlentities"
  s.add_dependency "inherited_resources"
  s.add_dependency "jammit"
  s.add_dependency "jquery-rails"
  s.add_dependency "memcached"
  s.add_dependency "mini_fb"
  s.add_dependency "money"
  s.add_dependency "nokogiri"
  s.add_dependency "paperclip"
  s.add_dependency "rails", "~> 3.0"
  s.add_dependency "responders"
  s.add_dependency "settingslogic"
  s.add_dependency "tumblr-api"
  s.add_dependency "tweetstream"
  s.add_dependency "twitter"
  s.add_dependency "unicode_utils"
  s.add_dependency "validates_email_format_of"
  s.add_dependency "will_paginate", "3.0.pre2"
  s.add_dependency "yard"
  s.add_dependency "memcache-client"
  s.add_dependency "analytical"
  s.add_dependency "yajl-ruby"
  s.add_dependency "disqussion"

  # Async goodness !
  s.add_dependency "rack-fiber_pool"
  s.add_dependency "em-http-request"
  s.add_dependency "em-net-http"
  s.add_dependency "em-synchrony"

  s.add_development_dependency "bundler"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "rcov", ">= 0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails", "~> 2.5"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "webrat"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "cucumber-rails", "~> 0.3.2"
  s.add_development_dependency "autotest"
  s.add_development_dependency "autotest-rails"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "ruby_parser"
  s.add_development_dependency "launchy"
  s.add_development_dependency "hirb"
  s.add_development_dependency "spork"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "wirble"
  # s.add_development_dependency "capybara-firebug"
  if RUBY_PLATFORM =~ /darwin/i
    s.add_development_dependency "rb-fsevent"
  end
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-livereload"
  s.add_development_dependency "hashie"
  s.add_development_dependency "rash"
  
  s.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*"] + ["LICENSE", "README.rdoc"]
end