require 'spec_helper'

feature 'Manage UTIAC sub categories' do
  let!(:utiac) { create(:tribunal, name: 'utiac', code: 'utiac') }
  let!(:category) { create(:category, tribunal: utiac)}

  context 'without authentication' do

    scenario 'cannot view utiac sub categories index' do
      visit "/admin/utiac/categories/#{category.id}/subcategories"

      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  
  end

  context 'authenticated for utiac' do
    let!(:admin) { create(:user, tribunals: [utiac]) }

    background do
      visit '/admin'
      sign_in admin
    end

    scenario 'view the utiac sub categories index page' do
      visit "/admin/utiac/categories/#{category.id}/subcategories"

      expect(page).to have_content("#{category.name} Sub-categories")
    end


    scenario 'view paginated list of sub categories' do
      subcategories = create_list(:subcategory, 20, category: category)
      visit "/admin/utiac/categories/#{category.id}/subcategories"

      category.subcategories.all[0..9].each do |subcat|
        expect(page).to have_content(subcat.name)
      end

      category.subcategories.all[10..19].each do |subcat|
        expect(page).not_to have_content(subcat.name)
      end

    end

    scenario 'view decision count' do
      subcat = create(:subcategory, category: category)
      decision = create(:all_decision, tribunal: utiac)
      decision.category_decisions.create!(category: category, subcategory: subcat)

      visit "/admin/utiac/categories/#{category.id}/subcategories"

      expect(page).to have_content('1 decision')
    end

    scenario 'page through list of categories' do
      subcategories = create_list(:subcategory, 20, category: category)
      visit "/admin/utiac/categories/#{category.id}/subcategories"

      within '.pagination-row.top' do
        click_link('Next →')
      end
      
      category.subcategories.all[10..19].each do |subcat|
        expect(page).to have_content(subcat.name)
      end

    end

    scenario 'edit subcategory from index page' do
      category = create(:category,tribunal: utiac)
      subcategory = create(:subcategory, category: category)

      visit "/admin/utiac/categories/#{category.id}/subcategories"

      click_link 'Edit'

      expect(current_path).to eq("/admin/utiac/categories/#{category.id}/subcategories/#{subcategory.id}/edit")
    end

    scenario 'delete subcategory from index page' do
      category = create(:category,tribunal: utiac)
      subcategory = create(:subcategory, category: category)

      visit "/admin/utiac/categories/#{category.id}/subcategories"
      click_link 'Delete'

      expect(current_path).to eq("/admin/utiac/categories/#{category.id}/subcategories")
      expect{ category.find(subcategory.id) }.to raise_exception
    end

    scenario 'cannot delete a subcategory that is assigned' do
      category = create(:category,tribunal: utiac)
      subcategory = create(:subcategory, category: category)

      decision = create(:all_decision)
      decision.category_decisions.create!(category: category, subcategory: subcategory)

      visit "/admin/utiac/categories/#{category.id}/subcategories"
      click_link 'Delete'

      expect(category.subcategories.find(subcategory.id)).to be_true
    end

    scenario 'create a subategory' do
      category = create(:category,tribunal: utiac)

      visit "/admin/utiac/categories/#{category.id}/subcategories/new"
      fill_in 'Name', with: 'New subcategory'

      click_button 'Create Subcategory'

      visit "/admin/utiac/categories/#{category.id}/subcategories"

      expect(page).to have_content('New subcategory')
    end

    scenario 'edit a subcategory' do
      category = create(:category,tribunal: utiac)
      subcategory = create(:subcategory, category: category)
      visit "/admin/utiac/categories/#{category.id}/subcategories/#{subcategory.id}/edit"

      fill_in 'Name', with: 'Updated subcategory'

      click_button 'Update Subcategory'

      visit "/admin/utiac/categories/#{category.id}/subcategories"

      expect(page).to have_content('Updated subcategory')
    end
  end
end