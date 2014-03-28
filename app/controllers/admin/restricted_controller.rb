class RestrictedController < ApplicationController
  layout 'layouts/admin'
  before_filter :authenticate_admin_user!
end