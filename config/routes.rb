Gallery::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'posts#index'

  devise_for :users, :controllers => {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  get 'users/finish_signup'

  resources :identities, only: [:destroy]

  resources :posts, :has_many => :events
  resources :comments, :has_many => :events

  resource :events, only: [:index]

  get 'events/index' => 'events#index', as: 'events'
  get 'tags/:tag', to: 'posts#index', as: :tag
  post 'posts/comments/comment_file' => 'comments#comment_file'


  mount Resque::Server, :at => '/resque'



end