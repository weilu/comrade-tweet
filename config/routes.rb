ComradeTweet::Application.routes.draw do
  root :to => 'home#index'
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  match '/approve', to: 'home#approve', via: [:post]
  match '/reject', to: 'home#reject', via: [:post]

  resources :users, :only => [:edit, :update]
end
