Spree::Core::Engine.routes.draw do
  devise_for :user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords' },
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' }
end

Spree::Core::Engine.routes.prepend do
  resources :users, :only => [:edit, :update]

  devise_scope :user do
    get '/login' => 'user_sessions#new', :as => :login
    get '/signup' => 'user_registrations#new', :as => :signup
  end

  match '/checkout/registration' => 'checkout#registration', :via => :get, :as => :checkout_registration
  match '/checkout/registration' => 'checkout#update_registration', :via => :put, :as => :update_checkout_registration

  match '/orders/:id/token/:token' => 'orders#show', :via => :get, :as => :token_order

  resource :session do
    member do
      get :nav_bar
    end
  end

  resource :account, :controller => 'users'
end


Refinery::Core::Engine.routes.draw do
  begin
    devise_for :user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords' },
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' }

    # Override Devise's other routes for convenience methods.
    devise_scope :user do
      get '/refinery/login', :to => "sessions#new", :as => :new_refinery_user_session
      get '/refinery/logout', :to => "sessions#destroy", :as => :destroy_refinery_user_session
      get '/refinery/users/register' => 'users#new', :as => :new_refinery_user_registration
      post '/refinery/users/register' => 'users#create', :as => :refinery_user_registration
    end
  rescue RuntimeError => exc
    if exc.message =~ /ORM/
      # We don't want to complain on a fresh installation.
      if (ARGV || []).exclude?('--fresh-installation')
        puts "---\nYou can safely ignore the following warning if you're currently installing Refinery as Devise support files have not yet been copied to your application:\n\n"
        puts exc.message
        puts '---'
      end
    else
      raise exc
    end
  end

  namespace :admin, :path => 'refinery' do
    resources :users, :except => :show
  end
end
