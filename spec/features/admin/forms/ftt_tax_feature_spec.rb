require 'spec_helper'

feature 'First Tier Tribunal Tax Chamber' do
  let(:tribunal){ create(:tribunal, code: 'ftt-tax', name: 'Tax: First-tier Tribunal judgments')}
  let(:user) { create(:user, tribunals: [tribunal]) }

  context 'as standard user' do
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'have access to ftt index page' do
      visit '/admin/ftt-tax'
      expect(page).to have_content('Tax: First-tier Tribunal judgments')
    end

    scenario 'can create a new ftt decision' do
      add_decision

      visit '/admin/ftt-tax/987789'

      expect(page).to have_content('Decision Number: 987789')
      expect(page).to have_content('Appellant name: Jonh Smith')
      expect(page).to have_content('Respondent name: Matt Black')
      expect(page).to have_content('Judges: Rafael Nadal')
      expect(page).to have_content('Date of decision: 21 Jan 1980')
      expect(page).to have_content('Date added: 31 Jan 1978')
      expect(page).to have_content('Date updated: 14 Feb 1967')
      expect(page).to have_content('Category: VAT - Taxes')
      expect(page).to have_content('Notes: filling the notes for testing')


      visit '/admin/ftt-tax/987789/edit'

      select 'VAT - Taxes - Monthly', from: 'Subcategory'
      click_button 'Update All decision'

      visit '/admin/ftt-tax/987789'

      expect(page).to have_content('Sub-Category: VAT - Taxes - Monthly')
    end

    scenario 'add category to decision' do
      add_decision

      visit '/admin/ftt-tax/987789/edit'

      select('Value Added Tax - Taxes', from: 'Add category')
      click_button 'Update All decision'

      category = Category.find_by_name('Value Added Tax - Taxes')

      within ".category-#{category.id}" do 
        select('VAT - Taxes - Yearly', from: 'Subcategory')
      end
      click_button 'Update All decision'

      visit '/admin/ftt-tax/987789'

      expect(page).to have_content('Sub-Category: VAT - Taxes - Yearly')
    end

    scenario 'can delete ftt decision' do
      add_decision
      visit "/admin/ftt-tax/987789"
      click_link('Delete decision')
      visit "/admin/ftt-tax/987789"

      expect(page).to have_content("Decision not found 987789")
    end

    scenario 'can edit ftt decision' do
      add_decision
      visit "/admin/ftt-tax/987789/edit"

      fill_in('Decision No', with: 'EDIT987789')
      fill_in('Appellant Name', with: 'John Smith')
      fill_in('Respondent Name', with: 'Matthew Black')
      select('Jose Mourinho', from: 'New judge')
      fill_in('Decision date', with: '22/05/1981')
      fill_in('Date of Upload', with: '04/02/1979')
      fill_in('Date published', with: '17/03/1968')
      select('Value Added Tax - Taxes', from: 'Category')
      fill_in('Notes', with: 'Decision already reached')

      click_button('Update All decision')

      visit "/admin/ftt-tax/EDIT987789"

      expect(page).to have_content('Decision Number: EDIT987789')
      expect(page).to have_content('Appellant name: John Smith')
      expect(page).to have_content('Respondent name: Matthew Black')
      expect(page).to have_content('Judges: Jose Mourinho')
      expect(page).to have_content('Date of decision: 22 May 1981')
      expect(page).to have_content('Date added: 4 Feb 1979')
      expect(page).to have_content('Date updated: 17 Mar 1968')
      expect(page).to have_content('Category: Value Added Tax - Taxes')
      expect(page).to have_content('Notes: Decision already reached')

      visit "/admin/ftt-tax/EDIT987789/edit"

      select 'VAT - Taxes - Yearly', from: 'Subcategory'
      click_button 'Update All decision'

      visit "/admin/ftt-tax/EDIT987789"
      
      expect(page).to have_content('Sub-Category: VAT - Taxes - Yearly')

    end
  end
end