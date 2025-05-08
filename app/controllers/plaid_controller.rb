class PlaidController < ApplicationController
    before_action :authenticate_user!
    protect_from_forgery with: :null_session # to handle CSRF protection for API requests
  
    def index
    end
  
    def create_link_token
      user = current_user
      link_token_create_request = Plaid::LinkTokenCreateRequest.new({
        user: { client_user_id: user.id.to_s },
        client_name: 'Your App Name',
        products: %w[auth transactions],
        country_codes: ['US'],
        language: 'en'
      })
  
      begin
        link_token_response = PlaidClient.link_token_create(link_token_create_request)
        render json: { link_token: link_token_response.link_token }
      rescue Plaid::ApiError => e
        Rails.logger.error("Plaid API error: #{e.response_body}")
        render json: { error: e.response_body }, status: :internal_server_error
      end
    end
  
    def exchange_public_token
      Rails.logger.debug("Received public_token: #{params[:public_token]}")
  
      if params[:public_token].blank?
        Rails.logger.error('No public_token received')
        return render json: { error: 'No public_token received' }, status: :bad_request
      end
  
      begin
        exchange_token(params[:public_token])
        render json: { message: 'Bank account linked successfully.' }, status: :ok
      rescue Plaid::ApiError => e
        Rails.logger.error("Plaid API error: #{e.response_body}")
        render json: { error: e.response_body }, status: :internal_server_error
      end
    end
  
    def exchange_token(public_token)
      request = Plaid::ItemPublicTokenExchangeRequest.new({ public_token: public_token })
  
      response = PlaidClient.item_public_token_exchange(request)
      access_token = response.access_token
      item_id = response.item_id
  
      Rails.logger.debug("Access token: #{access_token}")
      Rails.logger.debug("Item ID: #{item_id}")
  
      if current_user.update(plaid_access_token: access_token, plaid_item_id: item_id)
        Rails.logger.debug('Access token and item ID saved successfully.')
        Rails.logger.debug("Current user after save: #{current_user.inspect}")
      else
        Rails.logger.error("Failed to save access token and item ID. Errors: #{current_user.errors.full_messages.join(', ')}")
      end
    end
  
    def accounts
      access_token = current_user.plaid_access_token
  
      if access_token.blank?
        flash[:error] = 'Access token is missing. Please link your account again.'
        return redirect_to root_path
      end
  
      begin
        accounts_request = Plaid::AccountsGetRequest.new({ access_token: access_token })
        accounts_response = PlaidClient.accounts_get(accounts_request)
        @accounts = accounts_response.accounts
      rescue Plaid::ApiError => e
        Rails.logger.error("Plaid API error: #{e.response_body}")
        flash[:error] = "Plaid API error: #{e.response_body}"
        return redirect_to root_path
      rescue StandardError => e
        Rails.logger.error("Internal server error: #{e.message}")
        flash[:error] = 'Internal server error'
        return redirect_to root_path
      end
    end
  end