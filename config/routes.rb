Tribunals::Application.routes.draw do

  get '/', to: redirect('/utiac'), as: :root
  get '/utiac/decisions/:id', to:  redirect{|params, request| "/utiac/#{params[:id]}" }
  get '/utiac/decisions', to:  redirect('/utiac')

  resources :decisions, path: 'utiac'
  resources :aac_decisions, path: 'utaac'
  resources :eat_decisions, path: 'eat'
  resources :ftt_decisions, path: 'ftt-tax'

  resources :all_decisions, path: 'all'


  # TODO: These redirect parts seem messy and maybe not the correct way to manage the requirement, need to review
  namespace :admin do
    devise_for :users, controllers: { invitations: 'users/invitations', sessions: 'devise/sessions', passwords: 'devise/passwords', registrations: 'devise/registrations'}
    #TODO: Temporarily redirecting to UTIAC, but later on admins should be redirected to their respective tribunal's admin panel.
    get '/', to: redirect('/admin/utiac'), as: :decisions

    scope ':tribunal_code' do
      resources :all_decisions, path: ''
    end
    # resources :decisions, path: 'utiac'
    # resources :aac_decisions, path: 'utaac'
    # resources :eat_decisions, path: 'eat'
    # resources :ftt_decisions, path: 'ftt-tax'
    resources :users
  end

  resource :feedback
end
