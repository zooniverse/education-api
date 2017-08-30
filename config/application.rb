require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EducationApi
  class Application < Rails::Application
    attr_accessor :revision

    config.action_controller.permit_all_parameters = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.middleware.insert_before 0, Rack::Cors do
      Array.wrap(EducationApi.cors_config.allows).each do |allow_config|
        allow do
          origins allow_config["origins"]
          resource allow_config["resource"],
            headers: EducationApi.cors_config.headers,
            methods: EducationApi.cors_config.request_methods,
            expose: EducationApi.cors_config.expose,
            max_age: EducationApi.cors_config.max_age
        end
      end
    end
  end
end
