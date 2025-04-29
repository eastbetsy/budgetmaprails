Rails.application.routes.draw do
  root 'pages#home'
  get 'dashboard', to: 'pages#dashboard'
  get 'chat', to: 'pages#chat'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
end