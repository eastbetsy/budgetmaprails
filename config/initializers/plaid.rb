require 'plaid'

configuration = Plaid::Configuration.new
configuration.server_index = Plaid::Configuration::Environment['sandbox']

begin
  # Access environment-specific credentials
  configuration.api_key['PLAID-CLIENT-ID'] = Rails.application.credentials.dig(Rails.env.to_sym, :plaid, :client_id) || raise('Missing PLAID_CLIENT_ID')
  configuration.api_key['PLAID-SECRET'] = Rails.application.credentials.dig(Rails.env.to_sym, :plaid, :sandbox_secret) || raise('Missing PLAID_SECRET')
rescue StandardError => e
  Rails.logger.error("Failed to load Plaid credentials: #{e.message}")
  raise e # Re-raise to halt server until fixed
end

PlaidClient = Plaid::ApiClient.new(configuration)
Rails.application.config.plaid_client = PlaidClient