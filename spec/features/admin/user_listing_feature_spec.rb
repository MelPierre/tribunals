require 'spec_helper'

feature 'User listing' do
  let(:tribunal){ create(:tribunal, code: 'utiac', name: 'utiac')}
  let(:user) { create(:user, tribunals: [tribunal]) }

  context 'as standard user' do
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'Cannot access unless super admin' do
      visit '/admin/users'

      expect(page).to have_content('No Access')
    end
  end


  context 'as super admin' do

    scenario 'see a list of users' do
      pending
    end

    scenario 'see a paginated list of users' do
      pending
    end

    scenario 'see an option to edit a user' do
      pending
    end

    scenario 'be able to edit a user' do
      pending
    end

    scenario 'see and option to delete a user' do
      pending
    end

    scenario 'be able to delete a user' do
      pending
    end

  end

end