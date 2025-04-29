Rails.application.routes.draw do
  root 'pages#home'
  get 'chat', to: 'pages#chat'
  get 'dashboard', to: 'pages#dashboard'
end
