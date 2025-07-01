source "https://rubygems.org"

gem "rack", "2.2.13"  # rackのバージョンを指定

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "sprockets-rails"
gem "puma", ">= 5.0"


# gem 'mysql2'

gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "devise"
gem "bootstrap", "~> 5.2.0"
gem "sassc-rails"  # Bootstrap 5.3.xのSassエンジン依存関係
gem "dotenv-rails", groups: [ :development, :test, :production ]


# 開発環境とテスト環境のみで使用するGem
group :development, :test do
  gem "sqlite3", "~> 2.7" # 開発とテスト用SQLite
  gem "rspec-rails", "~> 6.1.0"
  gem "factory_bot_rails"
  gem "faker"
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "pry-rails"
  gem "better_errors"
  gem "binding_of_caller"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  # → 5.4.0 以上ならOK
  gem "rubocop-rails-omakase", require: false
end

# 開発環境のみで使用するGem
group :development do
  gem "web-console"
  # gem "error_highlight", ">= 0.7.0", platforms: [:ruby]

  gem "letter_opener_web"
  gem "annotate"
  gem "bullet"
end

group :test do
  gem "database_cleaner-active_record"
end

# 本番環境
group :production do
  gem "mysql2", ">= 0.5.3" # 本番用MySQL
end

gem "jsbundling-rails", "~> 1.3"
