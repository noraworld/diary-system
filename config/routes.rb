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
  get    '/search'                    => 'articles#search'

  post   '/upload' => 'uploads#upload'

  get    '/templates'       => 'templates#index'
  get    '/templates/new'   => 'templates#new'
  post   '/templates/new'   => 'templates#create'
  get    '/templates/:name' => 'templates#edit'
  post   '/templates/:name' => 'templates#update'
  delete '/templates/:name' => 'templates#destroy'

  get    '/sample' => 'sample_articles#show'
end
