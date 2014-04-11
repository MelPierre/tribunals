require 'spec_helper'

feature 'Manage FTT categories' do
  let!(:ftt) { create(:tribunal, name: 'ftt-tax', code: 'ftt-tax') }
  let!(:admin) { create(:user, admin: true) }

  context 'without authentication' do

    scenario 'cannot view ftt categories index' do
      visit '/admin/ftt-tax/categories'

      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  
  end

  context 'as admin' do

    background do
      visit '/admin'
      sign_in admin
    end

    scenario 'view the ftt categories index page' do
      visit '/admin/ftt-tax/categories'

      expect(page).to have_content('Categories')
    end

    scenario 'view paginated list of categories' do

    end

    scenario 'view subcategory count' do
      
    end

    scenario 'page through list of categories' do

    end

    scenario 'cannot see category out of scope' do

    end

    scenario 'view category from index page' do

    end

    scenario 'edit category from index page' do

    end

    scenario 'delete category from index page' do

    end

    scenario 'cannot delete a category that is assigned' do

    end

  end


end