class Users::InvitationsController < Devise::InvitationsController


  def invite_params
    params.require(:user).permit(:email, :admin, tribunal_ids: [])
  end
  
end