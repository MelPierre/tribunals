require 'spec_helper'

feature 'Manage FTT categories' do
  let!(:ftt) { create(:tribunal, name: 'ftt-tax', code: 'ftt-tax') }
  let!(:eat) { create(:tribunal, name: 'eat', code: 'eat') }

  context 'without authentication' do

    scenario 'cannot view ftt categories index' do
      visit '/admin/ftt-tax/categories'

      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  
  end

  context 'authenticated for ftt' do
    let!(:admin) { create(:user, tribunals: [ftt]) }

    background do
      visit '/admin'
      sign_in admin
    end

    scenario 'view the ftt categories index page' do
      visit '/admin/ftt-tax/categories'

      expect(page).to have_content('Categories')
    end

    scenario 'denied access to othertrib categories index page' do
      visit '/admin/eat/categories'

      expect(page).to have_content('No Access')
    end

    scenario 'view paginated list of categories' do
      categories = create_list(:category, 20, tribunal: ftt)
      visit '/admin/ftt-tax/categories'

      ftt.categories.all[0..9].each do |cat|
        expect(page).to have_content(cat.name)
      end

      ftt.categories.all[10..19].each do |cat|
        expect(page).not_to have_content(cat.name)
      end

    end

    scenario 'only see ftt categories' do
      category = create(:category,tribunal: ftt)
      eat_category = create(:category, tribunal: eat)

      visit '/admin/ftt-tax/categories'

      expect(page).to have_content(category.name)
      expect(page).not_to have_content(eat_category.name)
    end

    scenario 'view subcategory count' do
      category = create(:category, tribunal: ftt)
      create(:subcategory, category: category)

      visit '/admin/ftt-tax/categories'

      expect(page).to have_content('1 sub-categories')
    end

    scenario 'page through list of categories' do
      categories = create_list(:category, 20, tribunal: ftt)
      visit '/admin/ftt-tax/categories'

      within '.pagination-row.top' do
        click_link('Next →')
      end
      
      ftt.categories.all[10..19].each do |cat|
        expect(page).to have_content(cat.name)
      end

    end

    scenario 'view category from index page' do
      category = create(:category,tribunal: ftt)

      visit '/admin/ftt-tax/categories'

      click_link category.name

      expect(current_path).to eq("/admin/ftt-tax/categories/#{category.id}/subcategories")
    end

    scenario 'edit category from index page' do
      category = create(:category,tribunal: ftt)

      visit '/admin/ftt-tax/categories'

      click_link 'Edit'

      expect(current_path).to eq("/admin/ftt-tax/categories/#{category.id}/edit")
    end

    scenario 'delete category from index page' do
      category = create(:category,tribunal: ftt)
      visit '/admin/ftt-tax/categories'
      click_link 'Delete'

      expect(current_path).to eq('/admin/ftt-tax/categories')
      expect{ ftt.categories.find(category.id) }.to raise_exception
    end

    scenario 'cannot delete a category that is assigned' do
      category = create(:category,tribunal: ftt)
      create(:subcategory, category: category)

      visit '/admin/ftt-tax/categories'
      click_link 'Delete'

      expect(ftt.categories.find(category.id)).to be_true
    end

    scenario 'create a category' do
      visit '/admin/ftt-tax/categories/new'
      fill_in 'Name', with: 'New category'

      click_button 'Create Category'

      visit '/admin/ftt-tax/categories'

      expect(page).to have_content('New category')
    end

    scenario 'edit a category' do
      category = create(:category,tribunal: ftt)
      visit "/admin/ftt-tax/categories/#{category.id}/edit"

      fill_in 'Name', with: 'Updated category'

      click_button 'Update Category'

      visit '/admin/ftt-tax/categories'

      expect(page).to have_content('Updated category')
    end

  end


end