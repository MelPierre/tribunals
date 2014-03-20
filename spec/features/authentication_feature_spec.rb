require 'spec_helper'

feature 'User Authentication' do

  context 'with standard access to tribunal utiac' do
    let!(:tribunal) { create(:tribunal,name: 'utiac', code: 'utiac') }
    let!(:user) { create(:user, tribunals: [tribunal]) }

    before do
      visit '/admin'
    end

    scenario 'User can sign in ' do
      sign_in user
      expect(page).to have_content('Administrator view')
    end

    scenario 'Super admin can sign in' do
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
  
  end # with standard access to tribunal utiac

  context 'unknown user' do
    
    scenario 'User cannot sign in' do
      visit '/admin'
      fill_in 'Email', with: 'nobody@example.com'
      fill_in 'Password', with: 'invalid'
      click_button 'Sign in'

      expect(page).to have_content('Invalid email or password')
    end

  end #unknown user


  context 'with super admin access' do
    let!(:user) { create(:user, admin: true) }
    
    before do
      visit '/admin'
    end

    scenario 'User can sign in' do
      sign_in user
      expect(page).to have_content('Administrator view')
    end

    scenario 'User can access all tribunals' do
      pending
      sign_in user
      visit '/admin/eat'

      expect(page).to.not have_content('No Access')
    end

  end #with super admin access

end