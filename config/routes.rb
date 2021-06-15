Rails.application.routes.draw do
  resources :products
  post 'products/create_and_convert', to: 'products#create_and_convert', as: 'create_and_convert_product'
  get 'products/:id/conservative_convert', to: 'products#conservative_convert', as: 'conservative_convert_product'
  get 'products/:id/generous_convert', to: 'products#generous_convert', as: 'generous_convert_product'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
