require 'spec_helper'

describe Admin::UsersController do
  render_views

  describe 'with no authentication' do
    
    it 'should redirect to sign in' do
      get :index
      expect(response).to redirect_to(new_admin_user_session_path)
    end

  end

  describe 'GET #index' do
    let(:users){ }
    it 'should return users' do
      get :index
    end

  end

end