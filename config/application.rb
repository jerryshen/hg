require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hg
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.enable_dependency_loading = true

    config.autoload_paths += %W(#{config.root}/lib #{config.root}/lib/extras)

    config.i18n.locale = config.i18n.default_locale = :'zh-CN'

    config.generators.stylesheets     = false
    config.generators.javascripts     = false
    config.generators.helper          = false

    config.middleware.use Plezi
    config.middleware.insert_after Warden::Manager, Plezi
  end
end
