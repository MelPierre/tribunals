Tribunals::Application.routes.draw do
  get '/', to: redirect('/utiac')
  get '/utiac/decisions', to:  redirect('/utiac')
  get '/utiac', to: 'decisions#index', as: :root

  get '/utaac', to: 'aac_decisions#index'
  get '/eat', to: 'eat_decisions#index'
  get '/ftt-tax', to: 'ftt_decisions#index'

  scope '/utiac' do
    resources :decisions, path: ''
    get '/decisions/:id', to: redirect('/utiac/%{id}')
  end

  scope '/utaac' do
    resources :aac_decisions, path: ''
  end

  scope '/eat' do
    resources :eat_decisions, path: ''
  end

  scope '/ftt-tax' do
    resources :ftt_decisions, path: ''
  end

  namespace :admin do
    #TODO: Temporarily redirecting to UTIAC, but later on admins should be redirected to their respective tribunal's admin panel.
    get '/', to: redirect('/admin/utiac')
    scope '/utiac' do    
      resources :decisions, path: ''
    end
    resource :authentication do
      get :logout
    end
  end

  resource :feedback
end
