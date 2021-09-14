Rails.application.routes.draw do
root to: 'toppages#index'
 
 get 'introduction', to: 'introductions#index'
 
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  
  resources :users  do
    member do
      get :followings
      get :followers
      get :posts
      get :reports
      get :timelines
      get :favorites
    end
    collection do
      get :search
    end
  end
  

  resources :reports do  
    resources :comments, only: [:create, :destroy]  
  end
  
  resources :relationships, only: [:create, :destroy]
  resources :posts
  resources :likes,  only: [:create, :destroy]
end
