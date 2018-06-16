Rails.application.routes.draw do
  root 'sensors#index'
  resources :sensors
  mount Sensors::SensorsAPI => '/api/sensors'
end
