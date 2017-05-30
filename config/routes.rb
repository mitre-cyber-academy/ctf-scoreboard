# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
CtfRegistration::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get 'home/index'
  get '/home/about'

  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout', confirmation: 'confirm', sign_up: 'new' },
             controllers: { registrations: 'registrations', sessions: 'sessions', confirmations: 'confirmations' }

  resource :users, only: [] do
    get :join_team, on: :member
  end

  # Saying resources :users do causes all routes for the team to be generated.
  # By saying only: [] it keeps only the routes specified in the do block to be generated.
  resources :teams, except: %i[destroy] do
    # Different route for inviting a user to the team.
    member do
      patch :invite
      put :invite
    end
    # Custom route for accepting user invites.
    resources :user_invites, only: [:destroy] do
      get :accept, on: :member
    end
    resources :user_requests, only: %i[create destroy] do
      get :accept, on: :member
    end
    resources :users, only: [] do
      delete :leave_team
      get :promote
    end
  end

  # game
  resource :game, only: [:show] do
    resources :messages, only: [:index]
    resources :achievements, only: [:index]
    resources :divisions, only: [:index]
    resources :flags, only: [:index] # Prank route!
    resources :challenges, only: %i[show update] do
    end
  end

  get '/game/summary' => 'games#summary'
  get '/game/teams' => 'games#teams'

  resources :users, only: %i[index show] do
    get :download, on: :member
  end

  root to: 'home#index'
end
# rubocop:enable Metrics/BlockLength
