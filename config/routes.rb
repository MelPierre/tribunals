Tribunals::Application.routes.draw do

  get '/', to: redirect('/utiac'), as: :root

  #UTIAC to be refactored into all_decisions routes after the 3 new tribunals are done and tested
  get '/utiac/decisions/:id', to:  redirect{|params, request| "/utiac/#{params[:id]}" }
  get '/utiac/decisions', to:  redirect('/utiac')
  
  resources :decisions, path: 'utiac'

  scope ':tribunal_code', tribunal_code: /utiac|utaac|ftt\-tax|eat/  do
    resources :all_decisions, path: ''
  end


  # TODO: These redirect parts seem messy and maybe not the correct way to manage the requirement, need to review
  namespace :admin do
    devise_for :users, controllers: { invitations: 'users/invitations', sessions: 'devise/sessions', passwords: 'devise/passwords', registrations: 'devise/registrations'}

    get '/', to: redirect('/admin/utiac'), as: :decisions

    scope ':tribunal_code', tribunal_code: /utiac|utaac|ftt\-tax|eat/ do
      # resources :categories do
      #   resources :subcategories
      # end
      resources :all_decisions, path: ''
    end
    resources :users
  end

  resource :feedback
end
