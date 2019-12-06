Rails.application.routes.draw do
  root to: 'home#show'

  get 'faq' => 'pages#faq', as: :faq

  resources :user_sessions, only: [:create]
  resources :users, only: [:create]
  resource :user, only: [:show, :edit, :update]

  get 'register' => 'users#new', as: :register
  get 'signin' => 'user_sessions#new', as: :signin
  get 'logout' => 'user_sessions#destroy', as: :logout

  resources :councillors, only: [:index, :show]
  get 'councillors/:id/:view(/:context)' => 'councillors#show'

  resources :local_electoral_areas, path: 'areas', only: [:index, :show]
  get 'areas/:id/:view(/:context)' => 'local_electoral_areas#show'

  resources :parties, only: [:index, :show]
  get 'parties/:id/:view(/:context)' => 'parties#show'

  resources :meetings, only: [:index]
  get 'meetings/:meeting_type/:occurred_on' => 'meetings#show', as: :meeting_path
  get 'meetings/:meeting_type/:occurred_on/:view(/:context)' => 'meetings#show'

  resources :motions, only: [:index, :show]
  get 'motions/:id/:view(/:context)' => 'motions#show'

  resources :amendments, only: [:show]
  get 'amendments/:id/:view(/:context)' => 'amendments#show'

  resources :topics, only: [:index, :show]

  namespace :admin do
    root to: 'dashboard#show'
    resources :councillors, only: [:index, :show] do
      resources :media_mentions, only: [:new, :create]
    end

    resources :events, only: [:index, :show]
    resources :co_options, only: [:new, :create, :edit, :update, :destroy]
    resources :change_of_affiliations, only: [:new, :create, :edit, :update, :destroy]
    resources :elections

    resources :meetings do
      collection { patch :scrape }
      member { post :save_attendance }
      resources :motions, only: [:new, :create]
    end
    get 'meetings/:id/:view(/:context)' => 'meetings#show'

    resources :motions, except: [:new, :create] do
      member do
        post :save_vote
        patch :publish
      end
      resources :media_mentions, only: [:new, :create]
      resources :amendments, only: [:new, :create]
    end
    get 'motions/:id/:view(/:context)' => 'motions#show'

    resources :amendments, except: [:new, :create] do
      member do
        get :votes
        patch :update_votes
      end
    end
    resources :media_mentions, only: [:edit, :update]
  end

  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"
end
