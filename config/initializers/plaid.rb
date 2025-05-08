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