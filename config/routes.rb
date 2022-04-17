Rails.application.routes.draw do
  root 'articles#index'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get    '/:year/:month'              => 'articles#index',   constraints: { year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/ }
  get    '/:year/:month/:day'         => 'articles#show',    constraints: { year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/ }, as: 'show'
  get    '/new'                       => 'articles#new'
  post   '/new'                       => 'articles#create'
  get    '/edit/:year/:month/:day'    => 'articles#edit',    constraints: { year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/ }, as: 'edit'
  post   '/:year/:month/:day'         => 'articles#update',  constraints: { year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/ }
  patch  '/:year/:month/:day'         => 'articles#update',  constraints: { year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/ }
  delete '/destroy/:year/:month/:day' => 'articles#destroy', constraints: { year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/ }, as: 'destroy'

  post '/upload'   => 'uploads#upload'
  get  '/search'   => 'articles#search'
  get  '/timeline' => 'articles#timeline'
  post '/migrate'  => 'articles#migrate', as: 'migrate'

  get    '/templates'       => 'templates#index', as: 'templates_index'
  get    '/templates/new'   => 'templates#new',   as: 'templates_new'
  post   '/templates/new'   => 'templates#create'
  get    '/templates/sort'  => 'templates#sort'
  get    '/templates/:uuid' => 'templates#edit'
  post   '/templates/:uuid' => 'templates#update'
  delete '/templates/:uuid' => 'templates#destroy'

  get  '/settings' => 'settings#edit'
  post '/settings' => 'settings#update'

  # get    '/:year/:month/:day/private'         => 'private_articles#show',    constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}
  # get    '/edit/:year/:month/:day/private'    => 'private_articles#edit',    constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}
  # delete '/destroy/:year/:month/:day/private' => 'private_articles#destroy', constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}
  # get    '/private/new'                       => 'private_articles#new'
  # post   '/private/new'                       => 'private_articles#create'
  # post   '/:year/:month/:day/private'         => 'private_articles#update',  constraints: {year: /20[0-9][0-9]/, month: /0[1-9]|1[0-2]/, day: /0[1-9]|[1-2][0-9]|3[0-1]/}

  post   '/upload' => 'uploads#upload'
  get    '/search' => 'articles#search'

      post '/markdown' => 'markdowns#markdown'
    end
  end
end
