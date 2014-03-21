class ApplicationController < ActionController::Base
  include Concerns::Authentication

  def enable_varnish
    headers['X-Varnish-Enable'] = '1'
  end

  def set_cache_control(timestamp)
    fresh_when(last_modified: timestamp, public: true)
  end

  def after_sign_in_path_for(resource)
    "/admin/#{(resource.tribunals.first.try(:code))}"
  end

end
