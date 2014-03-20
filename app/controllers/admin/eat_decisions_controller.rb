class Admin::EatDecisionsController < ::EatDecisionsController
  layout 'layouts/admin'
  before_filter :authenticate_user!
  
end
