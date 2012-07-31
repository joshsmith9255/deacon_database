DeaconDatabase::Application.routes.draw do

    # Generated model routes
    resources :clients
    resources :deacons
    resources :assignments
    #resources :sessions

    # Semi-static page routes
    match 'home' => 'home#index', :as => :home
    match 'about' => 'home#about', :as => :about
    match 'contact' => 'home#contact', :as => :contact
    match 'privacy' => 'home#privacy', :as => :privacy
    match 'search' => 'home#search', :as => :search

    # match 'user/edit' => 'users#edit', :as => :edit_current_user
    # match 'signup' => 'users#new', :as => :signup
    # match 'logout' => 'sessions#destroy', :as => :logout
    # match 'login' => 'sessions#new', :as => :login

    # Set the root url
    root :to => 'home#index'

  end

