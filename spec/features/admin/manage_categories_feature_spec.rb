require 'spec_helper'

codes = ['eat', 'utaac', 'utiac', 'ftt-tax']
codes.each do |code|
  other_code = codes.reject{|c| c == code}.first

  feature "Manage #{code} categories" do
    let!(:tribunal) { create(:tribunal, name: code, code: code) }
    let!(:other_trib) { create(:tribunal, name: other_code , code: other_code) }

    context 'without authentication' do

      scenario 'cannot view eat categories index' do
        visit "/admin/#{code}/categories"

        expect(page).to have_content('You need to sign in or sign up before continuing')
      end
    
    end

    context 'authenticated for eat' do
      let!(:admin) { create(:user, tribunals: [tribunal]) }

      background do
        visit '/admin'
        sign_in admin
      end

      scenario "view the #{tribunal} categories index page" do
        visit "/admin/#{code}/categories"

        expect(page).to have_content('Categories')
      end

      scenario 'denied access to othertrib categories index page' do
        visit "/admin/#{other_code}/categories"

        expect(page).to have_content('No Access')
      end

      scenario 'view paginated list of categories' do
        categories = create_list(:category, 50, tribunal: tribunal)
        visit "/admin/#{code}/categories"

        tribunal.categories.all[0..24].each do |cat|
          expect(page).to have_content(cat.name)
        end

        tribunal.categories.all[25..30].each do |cat|
          expect(page).not_to have_content(cat.name)
        end

      end

      scenario "only see #{code} categories" do
        category = create(:category,tribunal: tribunal)
        other_cat = create(:category, tribunal: other_trib)

        visit "/admin/#{code}/categories"

        expect(page).to have_content(category.name)
        expect(page).not_to have_content(other_cat.name)
      end

      scenario 'view subcategory count' do
        category = create(:category, tribunal: tribunal)
        create(:subcategory, category: category)

        visit "/admin/#{code}/categories"

        expect(page).to have_content('1 sub-category')
      end

      scenario 'page through list of categories' do
        categories = create_list(:category, 50, tribunal: tribunal)
        visit "/admin/#{code}/categories"

        within '.pagination-row.top' do
          click_link('Next →')
        end
        
        tribunal.categories.all[25..49].each do |cat|
          expect(page).to have_content(cat.name)
        end

      end

      scenario 'view category from index page' do
        category = create(:category,tribunal: tribunal)

        visit "/admin/#{code}/categories"

        click_link category.name

        expect(current_path).to eq("/admin/#{code}/categories/#{category.id}/subcategories")
      end

      scenario 'edit category from index page' do
        category = create(:category,tribunal: tribunal)

        visit "/admin/#{code}/categories"

        click_link 'Edit'

        expect(current_path).to eq("/admin/#{code}/categories/#{category.id}/edit")
      end

      scenario 'delete category from index page' do
        category = create(:category,tribunal: tribunal)
        visit "/admin/#{code}/categories"
        click_link 'Delete'

        expect(current_path).to eq("/admin/#{code}/categories")
        expect{ tribunal.categories.find(category.id) }.to raise_exception
      end

      scenario 'cannot delete a category that is assigned' do
        category = create(:category,tribunal: tribunal)
        create(:subcategory, category: category)

        visit "/admin/#{code}/categories"
        click_link 'Delete'

        expect( tribunal.categories.find(category.id)).to be_true
      end

      scenario 'create a category' do
        visit "/admin/#{code}/categories/new"
        fill_in 'Name', with: 'New category'

        click_button 'Create Category'

        visit "/admin/#{code}/categories"

        expect(page).to have_content('New category')
      end

      scenario 'edit a category' do
        category = create(:category,tribunal: tribunal)
        visit "/admin/#{code}/categories/#{category.id}/edit"

        fill_in 'Name', with: 'Updated category'

        click_button 'Update Category'

        visit "/admin/#{code}/categories"

        expect(page).to have_content('Updated category')
      end

    end
  end

end