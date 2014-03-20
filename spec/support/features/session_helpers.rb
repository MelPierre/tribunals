module Features
  module SessionHelpers

    def sign_in(user = nil, password = nil)

      expect(page).to have_content('Sign in')
      
      password ||= password || 'password123'
      user ||= create(:user, password: password)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: password

      save_and_open_page

      click_button 'Sign in'
    end

  end
end