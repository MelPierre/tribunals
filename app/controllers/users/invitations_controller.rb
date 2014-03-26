class Users::InvitationsController < Devise::InvitationsController
  before_filter :require_admin!, only: [:new, :destroy]

  def invite_params
    params.require(:admin_user).permit(:email, :admin, tribunal_ids: [])
  end

end