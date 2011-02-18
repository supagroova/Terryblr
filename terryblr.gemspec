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
  s.description = "Terryblr is an engine providing a CMS following a KISS principle"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "aasm"
  s.add_dependency "rails", "~> 3.0"
  s.add_dependency "memcached"
  s.add_dependency "aasm"
  s.add_dependency "will_paginate", "3.0.pre"
  s.add_dependency "haml"
  s.add_dependency "settingslogic"
  s.add_dependency "formtastic"
  s.add_dependency "unicode_utils"
  s.add_dependency "makandra_resource_controller"
  s.add_dependency "acts-as-taggable-on"
  s.add_dependency "acts_as_commentable"
  s.add_dependency "cannikin-gattica"
  s.add_dependency "tweetstream"
  s.add_dependency "money"
  s.add_dependency "jammit"
  s.add_dependency "settingslogic"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rcov", ">= 0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails", "~> 2.5"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "capybara", "~> 0.4"
  s.add_development_dependency "webrat"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "cucumber-rails"
  s.add_development_dependency "autotest"
  s.add_development_dependency "autotest-rails"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl_rails"

  s.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*"] + ["LICENSE", "README.rdoc"]
end