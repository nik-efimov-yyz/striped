$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift File.dirname(__FILE__)

ENV["RAILS_ENV"] = 'test'

require "rails/all"
require "with_model"
require "rspec/rails"
require "rails_app/config/environment"
require "factory_girl"
require "database_cleaner"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/factories/**/*_factory.rb"].each {|f| require f}

require "striped"

RSpec.configure do |config|
  config.extend WithModel

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Stripe::Customer.stub(retrieve: StripeHelper::Response.new("customer"))
    Stripe::Customer.stub(create: StripeHelper::Response.new("customer"))
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end