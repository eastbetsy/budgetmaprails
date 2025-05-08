Rails.application.routes.draw do
  root 'pages#home'
  get 'chat', to: 'pages#chat'
  get 'dashboard', to: 'pages#dashboard'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'signup', to: 'pages#signup'
  get 'resources', to: 'pages#resources'
end

Rails.application.routes.draw do
  root 'plaid#index'
  post 'plaid/create_link_token', to: 'plaid#create_link_token'
  post 'plaid/exchange_public_token', to: 'plaid#exchange_public_token'
  get 'plaid/accounts', to: 'plaid#accounts'
end