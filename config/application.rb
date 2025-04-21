require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SimplyWishlistApp
  class Application < Rails::Application
    config.action_dispatch.default_headers['P3P'] = 'CP="Not used"'
    config.action_dispatch.default_headers.delete('X-Frame-Options')
    config.time_zone = 'Islamabad'
    config.active_record.default_timezone = :local
    require 'rack/cors'
		config.middleware.use Rack::Cors do
			allow do
				origins '*'
				resource '*', :headers => :any, :methods => [:get, :post, :options, :delete, :put, :patch]
			end
		end
		config.active_record.raise_in_transactional_callbacks = true
  end
end
