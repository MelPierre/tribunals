class Admin::FttDecisionsController < ::FttDecisionsController
  layout 'layouts/admin'
  before_filter :authenticate_admin_user!
  before_filter -> { require_tribunal('ftt-tax') }

end
