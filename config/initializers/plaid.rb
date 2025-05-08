# Initialize Plaid configuration
plaid_config = Plaid::Configuration.new
plaid_config.server_index = Plaid::Configuration::Environment["sandbox"]  # or another environment as needed
plaid_config.api_key["PLAID-CLIENT-ID"] = Rails.application.credentials.dig(:development, :plaid, :client_id)
plaid_config.api_key["PLAID-SECRET"] = Rails.application.credentials.dig(:development, :plaid, :secret)

# Create an API client instance
api_client = Plaid::ApiClient.new(plaid_config)

# Create a Plaid API instance to use across the application
PlaidClient = Plaid::PlaidApi.new(api_client)

api_client.create_connection do |builder|
  builder.use Faraday::Response::Logger
end