module Concerns
  module Authentication
    extend ActiveSupport::Concern
    included do

      helper_method :is_admin?

      def require_admin!
        redirect_to root_path status: :forbidden and return unless is_admin?
      end

      def is_admin?
        current_user && current_user.admin?
      end

    end #included

  end # Authentication
end # Concerns