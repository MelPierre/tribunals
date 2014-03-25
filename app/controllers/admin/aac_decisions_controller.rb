class Admin::AacDecisionsController < ::FttDecisionsController
  layout 'layouts/admin'
  before_filter :authenticate_user!
  before_filter -> { require_tribunal('utaac') }

end
