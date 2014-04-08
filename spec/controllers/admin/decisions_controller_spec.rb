require 'spec_helper'

describe Admin::DecisionsController do
  render_views

  let!(:tribunal) { create(:tribunal,name: 'utiac', code: 'utiac') }
  let!(:user) { create(:user, tribunals: [tribunal]) }

  context 'unauthorized' do
    describe "GET #index" do
      it "requires authentication" do
        pending('WIP')
        get :index
        response.should redirect_to new_admin_user_session_path
      end
    end
  end

  context 'authenticated' do

    before do
      sign_in user
    end

    describe 'GET #index' do
      it "uses the controller scope" do
        pending('WIP')
        subject.class.should_receive(:scope).once.and_call_original
        get :index
      end
    end #GET index

    describe 'GET #show' do

      context 'a decision exists as html, doc and pdf' do
        let(:decision) do
          Decision.create!(decision_hash(pdf_file: sample_pdf_file, doc_file: sample_doc_file, promulgated_on: Date.new(2001, 1, 1)))
        end

        it 'should respond with a html representation' do
          pending('WIP')
          get :show, id: decision.id
          response.should be_success
          response.content_type.should == 'text/html'
        end

        it 'uses the controller scope' do
          pending('WIP')
          subject.class.should_receive(:scope).and_call_original
          get :show, id: decision.id
        end
      end

      context 'only decision metadata exists' do
        let(:decision) do
          Decision.create!(decision_hash(promulgated_on: Date.new(2001, 1, 1)))
        end

        it 'should respond with a html representation' do
          pending('WIP')
          get :show, id: decision.id
          response.should be_success
          response.content_type.should == 'text/html'
        end
      end
    end #GET show

    describe 'POST #update' do
      let(:decision) do
        Decision.create!(decision_hash)
      end

      it 'updates a decision' do
        pending('WIP')
        expect {
          post :update, id: decision.id, decision: { appeal_number: 1234 }
          response.should redirect_to(admin_decisions_path)
        }.to change { decision.reload.appeal_number }
      end
    end #POST update

    describe 'DELETE #destroy' do
      it 'removes a decision' do
        pending('WIP')
        decision = Decision.create!(decision_hash)
        expect {
          delete :destroy, id: decision.id
          response.should redirect_to(admin_decisions_path)
        }.to change { Decision.count }.by(-1)
      end
    end #DELETE destroy

  end
end
