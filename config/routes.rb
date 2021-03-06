App::Application.routes.draw do
  
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
  
  #root to: "static_pages#home"
  root :to => 'static_pages#home'


  match "/", :to => 'static_pages#home', :via => 'get'
  match "/monthly_view", :to => 'static_pages#monthly_view', :via => 'get'

  match '/daily',  :to => 'static_pages#daily_view', :via => 'get'
  match '/users_config',  :to => 'static_pages#users_config', :via => 'get'
  match '/add_projects',  :to => 'static_pages#add_project', :via => 'get'
  match '/reports',  :to => 'static_pages#reports', :via => 'get'

  resources :static_pages, :only => [:new] do
    get :autocomplete_project_name, :on => :collection
    get :autocomplete_user_name, :on => :collection
  end

  resources :searchs
  resources :users, :only => [:create, :show, :index, :edit, :update] do
    get :autocomplete_user_name, :on => :collection
  end

  resources :projects, :only => [:new, :create, :show, :index, :edit, :update] do
    get :autocomplete_project_name, :on => :collection
  end
  resources :timetables
  
  resources :historics
  match '/clone',  :to => 'historics#clone', :via => 'get'
  match '/confirm',  :to => 'users#confirm', :via => 'post'
  resources :relations, :only => [:create,  :destroy]


  get "users/new"
  match '/signup',  :to => 'users#new', :via => 'get'

  resources :sessions, :only => [:new, :create, :destroy]
  match '/signin',  :to => 'sessions#new', :via => 'get'
  match '/signout',  :to => 'sessions#destroy', :via => 'delete'
  
  match ':controller(/:action(/:id(.:format)))'
end
