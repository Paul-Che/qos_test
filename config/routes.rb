Rails.application.routes.draw do
  root 'sensors#index'
  resources :sensors, only: %i[index show]
  mount Sensors::Base => '/api/'
end
