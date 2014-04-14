require 'spec_helper'

feature 'Manage UTIAC categories' do
  let!(:utiac) { create(:tribunal, name: 'utiac', code: 'utiac') }
  let!(:eat) { create(:tribunal, name: 'eat', code: 'eat') }

  context 'without authentication' do

    scenario 'cannot view utiac categories index' do
      visit '/admin/utiac/categories'

      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  
  end

  context 'authenticated for utiac' do
    let!(:admin) { create(:user, tribunals: [utiac]) }

    background do
      visit '/admin'
      sign_in admin
    end

    scenario 'view the utiac categories index page' do
      visit '/admin/utiac/categories'

      expect(page).to have_content('Categories')
    end

    scenario 'denied access to othertrib categories index page' do
      visit '/admin/eat/categories'

      expect(page).to have_content('No Access')
    end

    scenario 'view paginated list of categories' do
      categories = create_list(:category, 20, tribunal: utiac)
      visit '/admin/utiac/categories'

      utiac.categories.all[0..9].each do |cat|
        expect(page).to have_content(cat.name)
      end

      utiac.categories.all[10..19].each do |cat|
        expect(page).not_to have_content(cat.name)
      end

    end

    scenario 'only see utiac categories' do
      category = create(:category,tribunal: utiac)
      eat_category = create(:category, tribunal: eat)

      visit '/admin/utiac/categories'

      expect(page).to have_content(category.name)
      expect(page).not_to have_content(eat_category.name)
    end

    scenario 'view subcategory count' do
      category = create(:category, tribunal: utiac)
      create(:subcategory, category: category)

      visit '/admin/utiac/categories'

      expect(page).to have_content('1 sub-categories')
    end

    scenario 'page through list of categories' do
      categories = create_list(:category, 20, tribunal: utiac)
      visit '/admin/utiac/categories'

      within '.pagination-row.top' do
        click_link('Next →')
      end
      
      utiac.categories.all[10..19].each do |cat|
        expect(page).to have_content(cat.name)
      end

    end

    scenario 'view category from index page' do
      category = create(:category,tribunal: utiac)

      visit '/admin/utiac/categories'

      click_link category.name

      expect(current_path).to eq("/admin/utiac/categories/#{category.id}/subcategories")
    end

    scenario 'edit category from index page' do
      category = create(:category,tribunal: utiac)

      visit '/admin/utiac/categories'

      click_link 'Edit'

      expect(current_path).to eq("/admin/utiac/categories/#{category.id}/edit")
    end

    scenario 'delete category from index page' do
      category = create(:category,tribunal: utiac)
      visit '/admin/utiac/categories'
      click_link 'Delete'

      expect(current_path).to eq('/admin/utiac/categories')
      expect{ utiac.categories.find(category.id) }.to raise_exception
    end

    scenario 'cannot delete a category that is assigned' do
      category = create(:category,tribunal: utiac)
      create(:subcategory, category: category)

      visit '/admin/utiac/categories'
      click_link 'Delete'

      expect(utiac.categories.find(category.id)).to be_true
    end

    scenario 'create a category' do
      visit '/admin/utiac/categories/new'
      fill_in 'Name', with: 'New category'

      click_button 'Create Category'

      visit '/admin/utiac/categories'

      expect(page).to have_content('New category')
    end

    scenario 'edit a category' do
      category = create(:category,tribunal: utiac)
      visit "/admin/utiac/categories/#{category.id}/edit"

      fill_in 'Name', with: 'Updated category'

      click_button 'Update Category'

      visit '/admin/utiac/categories'

      expect(page).to have_content('Updated category')
    end

  end


end