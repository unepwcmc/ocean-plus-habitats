Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'site#index'

  resources :countries, only: [:index]
  get '/:name' => 'countries#show'
  get 'site/methodologies' => 'site#methodologies', as: 'methodologies'
  get 'site/about' => 'site#about', as: 'about'
  get 'site/download_stats' => 'site#download_stats', as: 'download_stats'
end
