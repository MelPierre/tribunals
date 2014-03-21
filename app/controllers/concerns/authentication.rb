module Concerns
  module Authentication
    extend ActiveSupport::Concern
    included do

      helper_method :is_admin?

      def require_admin!
        unless is_admin?
          flash[:alert] = 'No Access'
          redirect_to admin_path and return 
        end
      end

      def require_tribunal(code)
        if tribunal = Tribunal.where(code: code).first && current_user
          return if is_admin? || current_user.has_tribunal?(code)
        end
        
        flash[:alert] = 'No Access'
        redirect_to admin_path and return
      end

      def is_admin?
        current_user && current_user.admin?
      end

    end #included

  end # Authentication
end # Concerns