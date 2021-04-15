# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.2.2"
# Use sqlite3 as the database for Active Record
gem "sqlite3"
# Use mysql as the database for Active Record
gem "mysql2"
# Use Puma as the app server
gem "puma", "~> 3.11"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.2"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Use Bootstrap toolkit
gem "bootstrap", "~> 4.2.1"

# Use jQuery
gem "jquery-rails"

# Use Octicon
gem "octicons_helper"

# Use Net-scp
gem "net-scp", "~> 1.2", ">= 1.2.1"

# Use Net-ssh
gem "net-ssh", "~> 5.1"

# Use will_paginate for pagination
gem "will_paginate", "~> 3.1.6"
gem "will_paginate-bootstrap4", "~> 0.2.2"

# Use telegram-bot-ruby for telegram notification
gem "telegram-bot-ruby"

# Use dotenv-rails for environment variables
gem "dotenv-rails"

# Whenever
gem "whenever", "~> 0.10.0"

# Use rb-readline for rb-readline errors
gem "rb-readline"

gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

# Mimemagic
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  # Use Pry
  gem "pry", "~> 0.12.2"

  # Use Pronto
  gem "pronto"
  gem "pronto-rubocop", require: false
  gem "pronto-flay", require: false
  gem "pronto-reek", require: false
  gem "pronto-rails_best_practices", require: false
  gem "pronto-rails_schema", require: false

  # Use Capistrano
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem "capistrano-rbenv", "~> 2.1"
  gem "capistrano3-puma", "~> 3.1", ">= 3.1.1"
  gem "capistrano-yarn", "~> 2.0", ">= 2.0.2"
  gem "sshkit-sudo", "~> 0.1.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem "chromedriver-helper"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
