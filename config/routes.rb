# frozen_string_literal: true
CtfRegistration::Application.routes.draw do
  devise_for :admins

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get 'home/index'
  get '/home/about'

  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout', confirmation: 'confirm', sign_up: 'new' },
             controllers: { registrations: 'registrations' }

  resource :users, only: [] do
    get :join_team, on: :member
  end

  # Saying resources :users do causes all routes for the team to be generated.
  # By saying only: [] it keeps only the routes specified in the do block to be generated.
  resources :teams, except: [:edit, :destroy, :index] do
    # Custom route for accepting user invites.
    resources :user_invites, only: [:destroy] do
      get :accept, on: :member
    end
    resources :user_requests, only: [:create, :destroy] do
      get :accept, on: :member
    end
    resources :users, only: [] do
      delete :leave_team
      get :promote
    end
  end

  root to: 'home#index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
