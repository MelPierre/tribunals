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

    scenario 'add category to decision' do
      add_eat_decision('EAT99901')

      visit '/admin/eat/EAT99901/edit'

      select('Value Added Tax - Taxes', from: 'Add topic')
      click_button 'Update All decision'

      category = Category.find_by_name('Value Added Tax - Taxes')

      within ".category-#{category.id}" do 
        select('VAT - Taxes - Yearly', from: 'Sub-topic')
      end
      click_button 'Update All decision'

      visit '/admin/eat/EAT99901'

      expect(page).to have_content('Sub-topics: VAT - Taxes - Yearly')
    end

    scenario 'can delete eat decision' do
      add_eat_decision('EAT99901')
      visit "/admin/eat/EAT99901"
      click_link('Delete decision')
      visit "/admin/eat/EAT99901"

      expect(page).to have_content("Decision not found EAT99901")
    end

    scenario 'can edit eat decision' do
      add_eat_decision('EAT99901')
      visit "/admin/eat/EAT99901/edit"

      fill_in('EAT number', with: 'EDIT987789')
      select('Rafael Nadal', from: 'New judge')
      fill_in('Date of hearing', with: '22/05/1981')
      fill_in('Date of upload', with: '04/02/1979')
      fill_in('Notes', with: 'Decision already reached')

      click_button('Update All decision')

      visit "/admin/eat/EDIT987789"


      expect(page).to have_content('Decision Number: EDIT987789')
      expect(page).to have_content('Appellant name: Jonh Smith')
      expect(page).to have_content('Respondent name: Matt Black')
      expect(page).to have_content('Judges: Rafael Nadal')
      expect(page).to have_content('Date of hearing: 22 May 1981')
      expect(page).to have_content('Date of upload: 4 Feb 1979')
      expect(page).to have_content('Notes: Decision already reached')
    end
  end
end
