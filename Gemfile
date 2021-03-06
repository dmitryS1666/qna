source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'rubocop', '~> 0.47.1', require: false
gem 'redis'
gem 'slim-rails'
gem 'devise'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'materialize-sass'
gem 'material_icons'
gem 'responders', '~> 2.0'
gem 'cancancan'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'doorkeeper', '4.2.6'
gem 'active_model_serializers'
# для ускорения работы преобразования to_json
gem 'oj'
gem 'oj_mimic_json'
gem 'skim'
gem 'sprockets'
gem 'gon'
# фоновые задачи
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'whenever'
gem 'mysql2'
gem 'thinking-sphinx', '3.3.0'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'therubyracer'
gem 'unicorn'
gem 'redis-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'capybara-webkit' # sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'json_spec'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]