Rails.application.routes.draw do
  resources :recipes, only: %i[show create update destroy], format: 'json'
end
