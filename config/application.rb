require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HeroesAndMagic
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W(#{Rails.root}/app/modules)
    config.autoload_paths += %W(#{Rails.root}/app/services)
    config.autoload_paths += %W(#{Rails.root}/app/services/modules)
    config.autoload_paths += %W(#{Rails.root}/app/services/classes)
    config.autoload_paths += %W(#{Rails.root}/app/services/classes/interfaces)
    config.autoload_paths += %W(#{Rails.root}/app/services/buffs/mage)
    config.autoload_paths += %W(#{Rails.root}/app/services/buffs/priest)
    config.autoload_paths += %W(#{Rails.root}/app/services/buffs/warrior)
    config.autoload_paths += %W(#{Rails.root}/app/services/buffs/public)

    config.generators do |g|
      g.template_engine :haml
      g.test_framework          :rspec, fixtures: true, view: false
      g.fixture_replacement    :factory_girl, dir: "spec/factories"
    end
  end
end
