require 'spec_helper'

feature 'Manage EAT categories' do
  let!(:eat) { create(:tribunal, name: 'eat', code: 'eat') }
  let!(:utaac) { create(:tribunal, name: 'utaac', code: 'utaac') }

  context 'without authentication' do

    scenario 'cannot view eat categories index' do
      visit '/admin/eat/categories'

      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  
  end

  context 'authenticated for eat' do
    let!(:admin) { create(:user, tribunals: [eat]) }

    background do
      visit '/admin'
      sign_in admin
    end

    scenario 'view the eat categories index page' do
      visit '/admin/eat/categories'

      expect(page).to have_content('Categories')
    end

    scenario 'denied access to othertrib categories index page' do
      visit '/admin/utaac/categories'

      expect(page).to have_content('No Access')
    end

    scenario 'view paginated list of categories' do
      categories = create_list(:category, 20, tribunal: eat)
      visit '/admin/eat/categories'

      eat.categories.all[0..9].each do |cat|
        expect(page).to have_content(cat.name)
      end

      eat.categories.all[10..19].each do |cat|
        expect(page).not_to have_content(cat.name)
      end

    end

    scenario 'only see eat categories' do
      category = create(:category,tribunal: eat)
      utaac_category = create(:category, tribunal: utaac)

      visit '/admin/eat/categories'

      expect(page).to have_content(category.name)
      expect(page).not_to have_content(utaac_category.name)
    end

    scenario 'view subcategory count' do
      category = create(:category, tribunal: eat)
      create(:subcategory, category: category)

      visit '/admin/eat/categories'

      expect(page).to have_content('1 sub-categories')
    end

    scenario 'page through list of categories' do
      categories = create_list(:category, 20, tribunal: eat)
      visit '/admin/eat/categories'

      within '.pagination-row.top' do
        click_link('Next →')
      end
      
      eat.categories.all[10..19].each do |cat|
        expect(page).to have_content(cat.name)
      end

    end

    scenario 'view category from index page' do
      category = create(:category,tribunal: eat)

      visit '/admin/eat/categories'

      click_link category.name

      expect(current_path).to eq("/admin/eat/categories/#{category.id}/subcategories")
    end

    scenario 'edit category from index page' do
      category = create(:category,tribunal: eat)

      visit '/admin/eat/categories'

      click_link 'Edit'

      expect(current_path).to eq("/admin/eat/categories/#{category.id}/edit")
    end

    scenario 'delete category from index page' do
      category = create(:category,tribunal: eat)
      visit '/admin/eat/categories'
      click_link 'Delete'

      expect(current_path).to eq('/admin/eat/categories')
      expect{ eat.categories.find(category.id) }.to raise_exception
    end

    scenario 'cannot delete a category that is assigned' do
      category = create(:category,tribunal: eat)
      create(:subcategory, category: category)

      visit '/admin/eat/categories'
      click_link 'Delete'

      expect(eat.categories.find(category.id)).to be_true
    end

    scenario 'create a category' do
      visit '/admin/eat/categories/new'
      fill_in 'Name', with: 'New category'

      click_button 'Create Category'

      visit '/admin/eat/categories'

      expect(page).to have_content('New category')
    end

    scenario 'edit a category' do
      category = create(:category,tribunal: eat)
      visit "/admin/eat/categories/#{category.id}/edit"

      fill_in 'Name', with: 'Updated category'

      click_button 'Update Category'

      visit '/admin/eat/categories'

      expect(page).to have_content('Updated category')
    end

  end


end