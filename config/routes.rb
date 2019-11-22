Rails.application.routes.draw do
  root to: 'home#show'
  get 'faq' => 'pages#faq', as: :faq

  resources :user_sessions, only: [:create]
  resources :users, only: [:create]
  resource :user, only: [:show, :edit, :update]

  get 'register' => 'users#new', as: :register
  get 'signin' => 'user_sessions#new', as: :signin
  get 'logout' => 'user_sessions#destroy', as: :logout

  resources :councillors, only: [:index, :show] do
    member do
      get 'votes'
      get 'motions'
      get 'amendments'
      get 'attendances'
    end
  end

  resources :local_electoral_areas, path: 'areas', only: [:index, :show] do
    member do
      get 'councillors'
      get 'motions'
    end
  end

  resources :parties, only: [:index, :show] do
    member do
      get 'councillors'
    end
  end

  resources :meetings, only: [:index] do
    member do
      get 'motions'
      get 'attendances'
    end
  end

  resources :motions, only: [:index, :show] do
    member do
      get 'votes'
      get 'amendments'
    end
  end

  resources :amendments, only: [:show] do
    member do
      get 'votes'
    end
  end

  resources :topics, only: [:index, :show]

  get 'meetings/:meeting_type/:occurred_on' => 'meetings#show', as: :meeting
  get 'meetings/:meeting_type/:occurred_on/motions/:id' => 'motion#show', as: :meeting_motion
  get 'meetings/:meeting_type/:occurred_on/motions/:motion_id/amendments/:id' => 'amendment#show', as: :meeting_motion_amendment

  namespace :admin do
    root to: 'dashboard#show'
    resources :councillors do
      resources :media_mentions, only: [:new, :create]
    end
    resources :events, only: [:index, :show]
    resources :co_options, only: [:new, :create, :edit, :update, :destroy]
    resources :change_of_affiliations, only: [:new, :create, :edit, :update, :destroy]
    resources :elections

    resources :meetings do
      collection { patch :scrape }
      member do
        get :attendances
        patch :update_attendances
      end
      resources :motions, only: [:new, :create]
    end
    resources :motions, except: [:new, :create] do
      member do
        get :votes
        patch :update_votes
        patch :publish
      end
      resources :media_mentions, only: [:new, :create]
      resources :amendments, only: [:new, :create]
    end
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
