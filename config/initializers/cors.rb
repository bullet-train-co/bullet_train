# Be sure to restart your server when you modify this file.
#
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.
#
# Read more: https://github.com/cyu/rack-cors
#
# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins 'example.com'
#
#     resource '*',
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end

# Permit CORS from any origin for API routes
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"
    resource "/api/*", headers: :any
  end
end
