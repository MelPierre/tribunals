require 'spec_helper'

feature 'Manage FTT sub categories' do
  let!(:ftt) { create(:tribunal, name: 'ftt-tax', code: 'ftt-tax') }
  let!(:category) { create(:category, tribunal: ftt)}

  context 'without authentication' do

    scenario 'cannot view ftt sub categories index' do
      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  
  end

  context 'authenticated for ftt' do
    let!(:admin) { create(:user, tribunals: [ftt]) }

    background do
      visit '/admin'
      sign_in admin
    end

    scenario 'view the ftt sub categories index page' do
      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      expect(page).to have_content("#{category.name} Sub-categories")
    end


    scenario 'view paginated list of sub categories' do
      subcategories = create_list(:subcategory, 20, category: category)
      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      category.subcategories.all[0..9].each do |subcat|
        expect(page).to have_content(subcat.name)
      end

      category.subcategories.all[10..19].each do |subcat|
        expect(page).not_to have_content(subcat.name)
      end

    end

    scenario 'view decision count' do
      subcat = create(:subcategory, category: category)
      decision = create(:all_decision, tribunal: ftt)
      decision.category_decisions.create!(category: category, subcategory: subcat)

      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      expect(page).to have_content('1 decision')
    end

    scenario 'page through list of categories' do
      subcategories = create_list(:subcategory, 20, category: category)
      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      within '.pagination-row.top' do
        click_link('Next →')
      end
      
      category.subcategories.all[10..19].each do |subcat|
        expect(page).to have_content(subcat.name)
      end

    end

    scenario 'edit subcategory from index page' do
      category = create(:category,tribunal: ftt)
      subcategory = create(:subcategory, category: category)

      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      click_link 'Edit'

      expect(current_path).to eq("/admin/ftt-tax/categories/#{category.id}/subcategories/#{subcategory.id}/edit")
    end

    scenario 'delete subcategory from index page' do
      category = create(:category,tribunal: ftt)
      subcategory = create(:subcategory, category: category)

      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"
      click_link 'Delete'

      expect(current_path).to eq("/admin/ftt-tax/categories/#{category.id}/subcategories")
      expect{ category.find(subcategory.id) }.to raise_exception
    end

    scenario 'cannot delete a category that is assigned' do
      category = create(:category,tribunal: ftt)
      subcategory = create(:subcategory, category: category)

      decision = create(:all_decision)
      decision.category_decisions.create!(category: category, subcategory: subcategory)

      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"
      click_link 'Delete'

      expect(category.subcategories.find(subcategory.id)).to be_true
    end

    scenario 'create a category' do
      category = create(:category,tribunal: ftt)

      visit "/admin/ftt-tax/categories/#{category.id}/subcategories/new"
      fill_in 'Name', with: 'New subcategory'

      click_button 'Create Subcategory'

      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      expect(page).to have_content('New subcategory')
    end

    scenario 'edit a category' do
      category = create(:category,tribunal: ftt)
      subcategory = create(:subcategory, category: category)
      visit "/admin/ftt-tax/categories/#{category.id}/subcategories/#{subcategory.id}/edit"

      fill_in 'Name', with: 'Updated subcategory'
      click_button 'Update Subcategory'

      visit "/admin/ftt-tax/categories/#{category.id}/subcategories"

      expect(page).to have_content('Updated subcategory')
    end
  end
end