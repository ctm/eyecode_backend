source :rubygems

gem 'rails', :git => 'git://github.com/rails/rails.git', :branch => '3-1-stable'
gem 'sprockets', :git => 'git://github.com/sstephenson/sprockets.git'
gem 'will_paginate', '2.3.15'
gem 'formtastic', '1.2.4'
gem 'uuidtools', '2.1.2'
gem 'tzinfo', '~> 0.3.28'
gem 'pg', '0.11.0' # Won't use on SWCP
gem 'authlogic', '3.0.3'
gem 'aspgems-foreign_key_migrations', '~> 2.0.0.beta1'

gem 'thin'

gem 'seed-fu', '2.0.1.rails31'

# Asset template engines
group :assets do
#  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-script'
  gem 'uglifier'
end

# I'm including this due to advice from <http://devcenter.heroku.com/articles/rails31_heroku_cedar>, but I'm skeptical that we need this
gem 'jquery-rails'


group :test, :development do
  gem 'rspec-rails', '>= 2.6.1'
  gem 'autotest', '>= 4.4.6'
  gem 'be_valid_asset', '1.1.1'
  gem 'test-unit', '2.3.0'
  gem 'rcov', '0.9.9'
  gem 'ruby-debug19', '>= 0.11.6'
  gem 'webrat', '>= 0.7.3'
  gem 'turn', :require => false
end

group :test do
  gem 'cover_me', '1.1.1'
  gem 'fakeweb', '1.3.0'
end