class Admin::RestrictedController < ApplicationController
  layout 'layouts/admin'
  before_filter :authenticate_admin_user!

  helper_method :current_tribunal

  def default_url_options(options = {})
    options[:tribunal_code] = current_tribunal.code if current_tribunal
    options
  end

  protected
    def current_tribunal
      @tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
    end
end