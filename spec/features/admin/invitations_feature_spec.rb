require 'spec_helper'

feature 'User invitiations' do
  let!(:utiac) { create(:tribunal, name: 'utiac', code: 'utiac') }
  let!(:utaac) { create(:tribunal, name: 'utaac', code: 'utaac') }
  let!(:admin) { create(:user, admin: true) }

  scenario 'as a standard user' do
    user = create(:user, tribunals: [utiac] )
    visit '/admin'
    sign_in user
  
    visit '/users/invitation/new'
    expect(page).to have_content('No Access')
  end

  context 'as admin' do

    background do
      clear_emails
      visit '/admin'
      sign_in admin
      visit '/users/invitation/new'
    end

    scenario 'requires email' do
      click_button 'Send an invitation'
      within 'div.user_email' do
        expect(page).to have_content("can't be blank")
      end
    end

    scenario 'send an invite for a single tribunal' do
      pending = attributes_for(:user)

      fill_in 'Email', with: pending[:email]
      select 'utiac', from: 'Tribunals'
      expect{click_button('Send an invitation')}.to change{all_emails.length}.by(1)

      open_email(pending[:email])
      expect(current_email).to have_content('Accept invitation')
      User.last.tribunals.should eq([utiac])
    end

    scenario 'send an invite for multiple tribunals' do
      pending = attributes_for(:user)
      fill_in 'Email', with: pending[:email]
      select 'utiac', from: 'Tribunals'
      select 'utaac', from: 'Tribunals'
      expect{click_button('Send an invitation')}.to change{all_emails.length}.by(1)

      open_email(pending[:email])
      expect(current_email).to have_content('Accept invitation')
      User.last.tribunals.should include(utiac)
      User.last.tribunals.should include(utaac)
    end

    scenario 'send an invite with admin access' do
      pending = attributes_for(:user)
      fill_in 'Email', with: pending[:email]
      check 'Admin'
      expect{click_button('Send an invitation')}.to change{all_emails.length}.by(1)

      open_email(pending[:email])
      expect(current_email).to have_content('Accept invitation')
      User.last.admin?.should be_true
    end

  end

  context 'as invited user' do
    let!(:pending) { attributes_for(:user) }

    background do
      clear_emails
      visit '/admin'
      sign_in admin
      visit '/users/invitation/new'
      fill_in 'Email', with: pending[:email]
      select 'utiac', from: 'Tribunals'
      expect{click_button('Send an invitation')}.to change{all_emails.length}.by(1)
    end

    context 'before accepting' do
      scenario 'cannot login with unaccepted invite' do
        sign_out
        visit '/admin'
        invited_user = User.last
        sign_in invited_user

        expect(page).to have_content('Invalid email or password')
      end
    end

    scenario 'accept an invite' do
      user = User.last
      open_email(user.email)
      current_email.click_link 'Accept invitation'
      expect(current_path).to eq("/users/invitation/accept")

      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'
      click_button 'Set my password'
      expect(page).to have_content('Your password was set successfully. You are now signed in')

      sign_out
      visit '/admin'
      sign_in user, 'password123'
      expect(page).to have_content('Signed in successfully')
    end

  end

end