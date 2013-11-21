Tribunals::Application.routes.draw do
  get '/utiac/decisions', to: 'decisions#index', as: :root
  get '/utaac', to: 'aac_decisions#index'
  get '/tax', to: 'ftt_decisions#index'

  scope '/utiac' do
    resources :decisions
    get '/' => redirect('/utiac/decisions')
  end

  scope '/utaac' do
    get '/', to: 'aac_decisions#index', as: :aac_decisions
    get ':id', to: 'aac_decisions#show', as: :aac_decision
  end

  scope '/eat' do
    get '/', to: 'eat_decisions#index', as: :eat_decisions
    get ':id', to: 'eat_decisions#show', as: :eat_decision
  end

  scope '/ftt-tax' do
    get '/', to: 'ftt_decisions#index', as: :ftt_decisions
    get ':id', to: 'ftt_decisions#show', as: :ftt_decision
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
