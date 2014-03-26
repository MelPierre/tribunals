class Admin::AacDecisionsController < ::AacDecisionsController
  layout 'layouts/admin'
  before_filter :authenticate_admin_user!
  before_filter -> { require_tribunal('utaac') }

end
