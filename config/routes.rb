Rails.application.routes.draw do

  root 'articles#index'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get    '/:year/:month'              => 'articles#index',   constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/}
  get    '/:year/:month/:day'         => 'articles#show',    constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}
  get    '/edit/:year/:month/:day'    => 'articles#edit',    constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}
  delete '/destroy/:year/:month/:day' => 'articles#destroy', constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}
  get    '/new'                       => 'articles#new'
  post   '/new'                       => 'articles#create'
  post   '/:year/:month/:day'         => 'articles#update',  constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
