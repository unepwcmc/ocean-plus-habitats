Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'site#warmwater'

  get '/warmwater', to: 'site#warmwater'
  get '/saltmarshes', to: 'site#saltmarshes'
  get '/mangroves', to: 'site#mangroves'
  get '/seagrasses', to: 'site#seagrasses'
  get '/coldwater', to: 'site#coldwater'
end
