Rails.application.routes.draw do
  root 'pages#home'
  get 'chat', to: 'pages#chat'
  get 'dashboard', to: 'pages#dashboard'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'register', to: 'pages#signup'
  get 'resources', to: 'pages#resources'
end
