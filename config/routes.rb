Rails.application.routes.draw do
  resources :products
  get 'products/:id/convert', to: 'products#convert', as: 'convert_product'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
