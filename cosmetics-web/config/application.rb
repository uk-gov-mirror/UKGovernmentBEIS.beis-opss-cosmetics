require File.expand_path("boot", __dir__)

require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cosmetics
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Europe/London"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    config.eager_load_paths << Rails.root.join("presenters")
    config.eager_load_paths << Rails.root.join("services")

    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.deliver_later_queue_name = "cosmetics-mailers"

    # Set the request timeout in seconds. The default set by Slowpoke is 15 seconds.
    # Use a longer timeout on development environments to allow for asset compilation.
    # config.slowpoke.timeout = Rails.env.production? ? 15 : 180

    config.exceptions_app = routes
    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden

    config.active_record.belongs_to_required_by_default = true
    config.antivirus_url = ENV.fetch("ANTIVIRUS_URL", "http://localhost:3006/safe")
    config.search_notify_api_key = ENV.fetch("SEARCH_NOTIFY_API_KEY", "")
    config.submit_notify_api_key = ENV.fetch("NOTIFY_API_KEY", "")
    config.secondary_authentication_enabled = ENV.fetch("TWO_FACTOR_AUTHENTICATION_ENABLED", "true") == "true"
    config.two_factor_attempts = 10
    config.whitelisted_2fa_code = ENV["WHITELISTED_2FA_CODE"]
    config.vcap_application = ENV["VCAP_APPLICATION"]
  end
end
