Rails.application.routes.draw do
  root 'sensors#index'
  resources :sensors do
    resources :values
  end
  mount Sensors::Base => '/api/'
end
