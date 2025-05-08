require 'plaid'

configuration = Plaid::Configuration.new
configuration.server_index = Plaid::Configuration::Environment['sandbox']

begin
  # Access environment-specific credentials
  credentials = Rails.application.credentials.dig(Rails.env.to_sym, :plaid)
  unless credentials
    raise 'Plaid credentials not found for environment: #{Rails.env}'
  end

  client_id = credentials[:client_id]
  sandbox_secret = credentials[:sandbox_secret]

  raise 'Missing PLAID_CLIENT_ID' unless client_id
  raise 'Missing PLAID_SECRET' unless sandbox_secret

  configuration.api_key['PLAID-CLIENT-ID'] = client_id
  configuration.api_key['PLAID-SECRET'] = sandbox_secret
rescue StandardError => e
  Rails.logger.error("Failed to load Plaid credentials: #{e.message}")
  raise # Re-raise to halt server until fixed
end

PlaidClient = Plaid::ApiClient.new(configuration)
Rails.application.config.plaid_client = PlaidClient