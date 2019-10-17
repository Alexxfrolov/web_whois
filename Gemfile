# frozen_string_literal: true

ruby '~> 2.6.5'

source 'https://rubygems.org'

gem 'dry-auto_inject'
gem 'hanami', '~> 1.3'
# gem 'hanami-model', '~> 1.3'
gem 'rake'

# base dependency to lookup domain/ip
# gem 'whois', '~> 5.0'
gem 'whois-parser'

# gem 'mysql2'

# Monitoring and logging
# gem 'rollbar'
# gem 'semantic_logger'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
  gem 'pry-byebug'
end

group :test do
  gem 'rspec'
end

group :production do
  gem 'puma'
end
