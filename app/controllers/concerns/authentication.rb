module Concerns
  module Authentication
    extend ActiveSupport::Concern
    included do

      helper_method :is_admin?

      def require_admin!
        unless is_admin?
          flash[:alert] = 'No Access'
          redirect_to after_sign_in_path_for(current_admin_user) and return 
        end
      end

      def require_tribunal(code)
        # return for super admin
        return if is_admin?
        # return for tribunal
        tribunal = Tribunal.where(code: code).first
        return if tribunal && current_admin_user && current_admin_user.has_tribunal?(code)
        flash[:alert] = 'No Access'
        redirect_to current_admin_user.tribunals.count ? after_sign_in_path_for(current_admin_user) : destroy_admin_user_session_path and return
      end

      def is_admin?
        current_admin_user && current_admin_user.admin?
      end

    end #included

  end # Authentication
end # Concerns