module Features
  module SessionHelpers

    def sign_in(user = nil, password = nil)

      expect(page).to have_content('Sign in')
      
      password ||= password || 'password123'
      user ||= create(:user, password: password)

      within '#new_user' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: password
      end

      click_button 'Sign in'
    end

  end
end