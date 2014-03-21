require 'spec_helper'

describe Users::InvitationsController do
  let!(:valid_params){ {user: { email: 'test@example.com', admin: true, tribunal_ids: [1,2,3] } } }
  let!(:params) { ActionController::Parameters.new(valid_params)}

  describe '#invite_params' do

    before do
      controller.stub(:params).and_return(params)
    end

    it 'allows email' do
      expect(controller.invite_params).to include(:email)
      expect(controller.invite_params[:email]).to eq('test@example.com')
    end

    it 'allows tribunals_ids' do
      expect(controller.invite_params).to include(:admin)
      expect(controller.invite_params[:admin]).to be_true
    end

    it 'allows admin' do
      expect(controller.invite_params).to include(:tribunal_ids)
      expect(controller.invite_params[:tribunal_ids]).to eq([1,2,3])
    end


  end #invite_params

  describe 'GET #new' do

  end

  describe 'POST #create' do

    it 'should create a new invitation' do
      pending
      #expect{ post :create, valid_params }.to change{ User.count }.by(1)
      post :create, valid_params
    end

  end # POST #create 

end
