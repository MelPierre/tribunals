class Admin::RestrictedController < ApplicationController
  layout 'layouts/admin'
  before_filter :authenticate_admin_user!

  helper_method :current_tribunal

  protected
    def current_tribunal
      @tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
    end
end