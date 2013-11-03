# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'capybara/rails'
require 'capybara/rspec'
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end

def create_campaign(name, budget, platform_names)
  platform_ids = platform_names.map { |pname| Platform.find_or_create_by_name(pname).id }
  Campaign.create!(name: name, budget: budget, platform_ids: platform_ids)
end

def create_platforms(names)
  names.each { |name| Platform.create!(name: name) }
end

def create_admin_user(email, password, superuser = false)
  AdminUser.create!(email: email, password: password, superuser: superuser)
end

def sign_in_admin_user(email, password)
  visit new_admin_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_on "Login"
end
