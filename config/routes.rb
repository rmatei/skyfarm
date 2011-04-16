Skyfarm::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.  
  # (Using this for Active Scaffold routes, since it's not a Rails 3 plugin)
  match ':controller(/:action(/:id(.:format)))'
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'enter_tallied_consumption' => 'tallied_consumptions#enter_tallied_consumption'
  match 'save_tallied_consumption' => 'tallied_consumptions#save_tallied_consumption'  
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # resources :products
  
  # map.resources :users, :active_scaffold :user
  
  # RESTful routing (not used now except for named routes - legacy Rails routing is higher priority b/c Active Scaffold is old)
  resources :users
  resources :expenses
  resources :tallied_items
  resources :tallied_consumptions
  resources :billing_periods
  resources :payments

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"
  
end
