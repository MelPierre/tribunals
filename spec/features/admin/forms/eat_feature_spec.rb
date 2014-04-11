require 'spec_helper'

feature 'Employment Appeals Tribunal' do
  let(:tribunal){ create(:tribunal, code: 'eat', name: 'Employment Appeals Tribunal')}
  let(:user) { create(:user, tribunals: [tribunal]) }

  context 'as standard user' do
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'have access to eat index page' do
      visit '/admin/eat'
      expect(page).to have_content('Employment Appeals Tribunal')
    end

    scenario 'can create a new eat decision' do
      add_eat_decision('EAT99901')

      visit '/admin/eat/EAT99901'

      expect(page).to have_content('Decision Number: EAT99901')
      expect(page).to have_content('Appellant name: Jonh Smith')
      expect(page).to have_content('Respondent name: Matt Black')
      expect(page).to have_content('Judges: Rafael Nadal')
      expect(page).to have_content('Date of hearing: 21 Jan 1980')
      expect(page).to have_content('Date of upload: 31 Jan 1978')
      expect(page).to have_content('Topics: VAT - Taxes')
      expect(page).to have_content('Notes: filling the notes for testing')


      visit '/admin/eat/EAT99901/edit'

      select 'VAT - Taxes - Monthly', from: 'Sub-topic'
      click_button 'Update All decision'

      visit '/admin/eat/EAT99901'

      expect(page).to have_content('Sub-topics: VAT - Taxes - Monthly')
    end

    # scenario 'add category to decision' do
    #   add_decision

    #   visit '/admin/eat/987789/edit'

    #   select('Value Added Tax - Taxes', from: 'Add category')
    #   click_button 'Update All decision'

    #   category = Category.find_by_name('Value Added Tax - Taxes')

    #   within ".category-#{category.id}" do 
    #     select('VAT - Taxes - Yearly', from: 'Subcategory')
    #   end
    #   click_button 'Update All decision'

    #   visit '/admin/eat/987789'

    #   expect(page).to have_content('Sub-Category: VAT - Taxes - Yearly')
    # end

    # scenario 'can delete eat decision' do
    #   add_decision
    #   visit "/admin/eat/987789"
    #   click_link('Delete decision')
    #   visit "/admin/eat/987789"

    #   expect(page).to have_content("Decision not found 987789")
    # end

    # scenario 'can edit eat decision' do
    #   add_decision
    #   visit "/admin/eat/987789/edit"

    #   fill_in('Decision No', with: 'EDIT987789')
    #   fill_in('Appellant name', with: 'John Smith')
    #   fill_in('Respondent name', with: 'Matthew Black')
    #   select('Jose Mourinho', from: 'New judge')
    #   fill_in('Decision date', with: '22/05/1981')
    #   fill_in('Date of Upload', with: '04/02/1979')
    #   fill_in('Date published', with: '17/03/1968')
    #   select('Value Added Tax - Taxes', from: 'Category')
    #   fill_in('Notes', with: 'Decision already reached')

    #   click_button('Update All decision')

    #   visit "/admin/eat/EDIT987789"

    #   expect(page).to have_content('Decision Number: EDIT987789')
    #   expect(page).to have_content('Appellant name: John Smith')
    #   expect(page).to have_content('Respondent name: Matthew Black')
    #   expect(page).to have_content('Judges: Jose Mourinho')
    #   expect(page).to have_content('Date of decision: 22 May 1981')
    #   expect(page).to have_content('Date added: 4 Feb 1979')
    #   expect(page).to have_content('Date updated: 17 Mar 1968')
    #   expect(page).to have_content('Category: Value Added Tax - Taxes')
    #   expect(page).to have_content('Notes: Decision already reached')

    #   visit "/admin/eat/EDIT987789/edit"

    #   select 'VAT - Taxes - Yearly', from: 'Subcategory'
    #   click_button 'Update All decision'

    #   visit "/admin/eat/EDIT987789"
      
    #   expect(page).to have_content('Sub-Category: VAT - Taxes - Yearly')

    # end
  end
end
