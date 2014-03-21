module Concerns
  module Authentication
    extend ActiveSupport::Concern
    included do

      helper_method :is_admin?

      def require_admin!
        unless is_admin?
          flash[:alert] = 'No Access'
          redirect_to root_path and return 
        end
      end

      def require_tribunal(code)
        # return for super admin
        return if is_admin?
        # return for tribunal
        if tribunal = Tribunal.where(code: code).first && current_user
          return if current_user.has_tribunal?(code)
        end
        
        flash[:alert] = 'No Access'
        redirect_to current_user.tribunals.count ? root_path : destroy_user_session_path and return
      end

      def is_admin?
        current_user && current_user.admin?
      end

    end #included

  end # Authentication
end # Concerns