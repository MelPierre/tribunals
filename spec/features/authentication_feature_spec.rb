require 'spec_helper'

feature 'User Authentication' do

  context 'with standard access to tribunal utiac' do
    let!(:tribunal) { create(:tribunal,name: 'utiac', code: 'utiac') }
    let!(:user) { create(:user, tribunals: [tribunal]) }

    before do
      visit '/admin/'
    end

    scenario 'User can sign in ' do
      pending
      sign_in user
      expect(page).to have_content('Administrator view')
    end

    scenario 'Super admin can sign in' do
      pending
      user.update_attribute(:admin, true)

      sign_in user
      expect(page).to have_content('Administrator view')
    end

    scenario 'User cannot switch to tribunal without access' do
      pending
      sign_in user

      visit '/admin/eat'
      expect(page).to have_content('No Access')
    end
  end

  context 'without standard access to tribunal utiac' do
    
    scenario 'User cannot sign in' do
      pending
    end
  end

  context 'with super admin access to tribunal' do
    scenario 'User can sign in' do
      pending
    end

    scenario 'User can access all tribunals' do
      pending
    end
  end

end