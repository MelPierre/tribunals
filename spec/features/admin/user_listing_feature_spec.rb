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
    let!(:users) { create_list(:user, 20) }
    let!(:admin) { create(:user, admin: true) }

    before do
      visit '/admin'
      sign_in admin
    end
    
    scenario 'follow users link to page' do
      click_link 'Users'
      expect(current_path).to eq('/admin/users')
    end

    scenario 'see a list of users' do
      visit '/admin/users'

      users[0..14].each do |user|
        expect(page).to have_content(user.email)
      end
    end

    scenario 'see a paginated list of users' do
      visit '/admin/users'

      users[15..20].each do |user|
        expect(page).not_to have_content(user.email)
      end
    end

    scenario 'see an option to edit a user' do
      visit '/admin/users'

      expect(page).to have_css("a[href='/admin/users/#{users.first.id}/edit']")
    end

    scenario 'be able to edit a user' do
      visit '/admin/users'

      page.find("a[href='/admin/users/#{users.first.id}/edit']").click
    end

    scenario 'see and option to delete a user' do
      visit '/admin/users'

      expect(page).to have_css("a[href='/admin/users/#{users.first.id}'][method='delete']")
    end

    scenario 'be able to delete a user' do
      pending
    end

  end

end