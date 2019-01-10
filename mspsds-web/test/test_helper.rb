ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)

# It's important that simplecov is "require"d early in the file
require 'simplecov'
require 'simplecov-console'
require 'shared/web/coveralls_formatter'
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
  Shared::Web::CoverallsFormatter
]
SimpleCov.start

require "rails/test_help"
require "rspec/mocks/standalone"

class ActiveSupport::TestCase
  include ::RSpec::Mocks::ExampleMethods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Import all relevant models into Elasticsearch
  def self.import_into_elasticsearch
    unless @models_imported
      ActiveRecord::Base.descendants.each do |model|
        if model.respond_to?(:__elasticsearch__)
          model.import force: true, refresh: true
        end
      end
      @models_imported = true
    end
  end

  def setup
    self.class.import_into_elasticsearch
  end

  def sign_in_as_user_with_organisation(is_admin: false, other_users: [admin_user, test_user_two, test_user_three], user: test_user)
    group = organisations[0].id
    user = user
    user.organisation = organisations[0]
    user_groups = [{ id: user[:id], groups: [group] }].to_json

    stub_user_credentials(user: user, groups: [group], is_admin: is_admin)
    stub_user_group_data(user_groups: user_groups)
    stub_user_data(users: other_users.push(user) )
    stub_client_config
  end

  def sign_in_as_admin_with_organisation
    sign_in_as_user_with_organisation(is_admin: true, other_users: [test_user, test_user_two, test_user_three], user: admin_user)
  end

  def logout
    allow(Keycloak::Client).to receive(:auth_server_url).and_call_original
    allow(Keycloak::Client).to receive(:user_signed_in?).and_call_original
    allow(Keycloak::Client).to receive(:get_userinfo).and_call_original
    allow(Keycloak::Client).to receive(:has_role?).and_call_original

    reset_user_data
  end

  def assert_same_elements(expected, actual, msg = nil)
    full_message = message(msg, '') { diff(expected, actual) }
    condition = (expected.size == actual.size) && (expected - actual == [])
    assert(condition, full_message)
  end

private

  def admin_user
    User.new(id: SecureRandom.uuid, email: "admin@example.com", first_name: "Test", last_name: "Admin")
  end

  def test_user
    User.new(id: SecureRandom.uuid, email: "user@example.com", first_name: "Test", last_name: "User_one")
  end

  def test_user_two
    User.new(id: SecureRandom.uuid, email: "user@example.com", first_name: "Test", last_name: "User_two")
  end

  def test_user_three
    User.new(id: SecureRandom.uuid, email: "user@example.com", first_name: "Test", last_name: "User_three")
  end

  def group_data
    [
      {
        id: "13763657-d228-4209-a3de-523dcab13810",
        name: "Group 1",
        path: "/Group 1",
        subGroups: []
      }, {
        id: "512c85e6-5a7f-4289-95e2-a78c0e40f05c",
        name: "Organisations",
        path: "/Organisations",
        subGroups: organisations_json
      }, {
        id: "10036801-2182-4c5b-92d9-b34b1e0a421b",
        name: "Group 2",
        path: "/Group 2",
        subGroups: []
      }
    ].to_json
  end

  def organisations_json
    [
      {id: "def4eef8-1a33-4322-8b8c-fc7fa95a2e3b", name: "Organisation 1", path: "/Organisations/Organisation 1"},
      {id: "1a612aea-1d3d-47ee-8c3a-76b4448bb97b", name: "Organisation 2", path: "/Organisations/Organisation 2"},
    ]
  end

  def organisations
    [
      Organisation.new(id: "def4eef8-1a33-4322-8b8c-fc7fa95a2e3b", name: "Organisation 1", path: "/Organisations/Organisation 1"),
      Organisation.new(id: "1a612aea-1d3d-47ee-8c3a-76b4448bb97b", name: "Organisation 2", path: "/Organisations/Organisation 2"),
    ]
  end

  def stub_user_credentials(user:, groups:, is_admin: false)
    allow(Keycloak::Client).to receive(:user_signed_in?).and_return(true)
    allow(Keycloak::Client).to receive(:get_userinfo).and_return(format_user_for_get_userinfo(user, groups))
    allow(Keycloak::Client).to receive(:has_role?).with(:admin).and_return(is_admin)
  end

  def format_user_for_get_userinfo(user, groups)
    { sub: user[:id], email: user[:email], groups: groups, given_name: user[:first_name], family_name: user[:last_name] }.to_json
  end

  def stub_client_config
    allow(Keycloak::Client).to receive(:auth_server_url).and_return("localhost")
  end

  def stub_user_data(users:)
    allow(Keycloak::Internal).to receive(:get_users).and_return(format_user_for_get_users(users))
    User.all
  end

  def stub_user_group_data(user_groups:)
    stub_group_data
    allow(Keycloak::Internal).to receive(:get_user_groups).and_return(user_groups)
  end

  def stub_group_data
    KeycloakClient.instance # Instantiate the class to create the get_groups method before stubbing it
    allow(Keycloak::Internal).to receive(:get_groups).and_return(group_data)
    Organisation.all
  end

  def format_user_for_get_users(users)
    users.map { |user| { id: user[:id], email: user[:email], firstName: user[:first_name], lastName: user[:last_name] } }.to_json
  end

  def reset_user_data
    allow(Keycloak::Internal).to receive(:get_groups).and_call_original
    allow(Keycloak::Internal).to receive(:get_users).and_call_original
    allow(Keycloak::Internal).to receive(:get_user_groups).and_call_original
    Rails.cache.delete(:keycloak_users)
  end
end
