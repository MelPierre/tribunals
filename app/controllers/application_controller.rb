class ApplicationController < ActionController::Base
  def enable_varnish
    headers['X-Varnish-Enable'] = '1'
  end

  def set_cache_control(timestamp)
    fresh_when(last_modified: timestamp, public: true)
  end

  def after_sign_in_path_for(resource)
    admin_path
  end
end
