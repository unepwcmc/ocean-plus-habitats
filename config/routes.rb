Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'site#index'

  # custom error routes
  match '/404' => 'errors#not_found', :via => :all
  match '/422' => 'errors#unprocessable_entity', :via => :all
  match '/500' => 'errors#internal_server_error', :via => :all

  get 'site/about' => 'site#about', as: 'about'
  get 'site/legal' => 'site#legal', as: 'legal'

  get '/:name' => 'countries#show'
end
