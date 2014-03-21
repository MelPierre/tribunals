class Admin::EatDecisionsController < ::EatDecisionsController
  layout 'layouts/admin'
  before_filter :authenticate_user!
  before_filter -> { require_tribunal('eat') }

end
