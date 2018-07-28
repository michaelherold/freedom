# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :development do
  gem 'benchmark-ips'
  gem 'guard-bundler'
  gem 'guard-inch'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-yard'
  gem 'inch'
  gem 'rubocop', '0.58.2'
  gem 'yard', '~> 0.9'
  gem 'yard-doctest'
  gem 'yardstick'

  group :test do
    gem 'pry'
    gem 'rake'
  end
end

group :ci do
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov', require: false
end

group :test do
  gem 'rspec', '~> 3.6'
end
