# Alternative approach using Rails credentials
# Run this command to edit credentials:
# For development: rails credentials:edit --environment development
# For production: rails credentials:edit

# This will open an editor with your encrypted credentials file
# Add your Plaid keys in this format:
# 
# plaid:
#   client_id: your_client_id
#   sandbox_secret: your_sandbox_secret
#   development_secret: your_development_secret
#   production_secret: your_production_secret
#

# Then in your initializer, use:
# config/initializers/plaid.rb

require 'plaid'

configuration = Plaid::Configuration.new
configuration.server_index = Plaid::Configuration::Environment["sandbox"]
configuration.api_key["PLAID-CLIENT-ID"] = Rails.application.credentials.dig(:plaid, :client_id)
configuration.api_key["PLAID-SECRET"] = Rails.application.credentials.dig(:plaid, :sandbox_secret)

@plaid_client = Plaid::ApiClient.new(
  configuration
)

# Make the client accessible throughout the app
Rails.application.config.plaid_client = @plaid_client