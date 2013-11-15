Tribunals::Application.routes.draw do
  get '/utiac/decisions', to: 'decisions#index', as: :root
  get '/utaac', to: 'aac_decisions#index'
  get '/employment', to: 'eat_decisions#index'
  get '/tax', to: 'ftt_decisions#index'

  scope '/utiac' do
    resources :decisions
    get '/' => redirect('/utiac/decisions')
  end

  scope '/utaac' do
    resources :aac_decisions
  end

  scope '/employment' do
    resources :eat_decisions
  end

  scope '/tax' do
    resources :ftt_decisions
  end

  namespace :admin do
    resources :decisions
    resource :authentication do
      get :logout
    end
  end
  get '/' => redirect('/utiac/decisions')

  resource :feedback
end
