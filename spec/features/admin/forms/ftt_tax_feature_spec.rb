require 'spec_helper'

feature 'First Tier Tribunal Tax Chamber' do
  let(:tribunal){ create(:tribunal, code: 'ftt-tax', name: 'First Tier Tribunal')}
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
      create(:all_judge, name: 'Iker Casillas', tribunal_id: tribunal.id)
      create(:all_judge, name: 'Rafael Nadal', tribunal_id: tribunal.id)
      create(:category, name: 'VAT - Taxes' , tribunal_id: tribunal.id)
      create(:subcategory, name:  'VAT - Taxes - Monthly', tribunal_id: tribunal.id)
      visit '/admin/ftt-tax/new'
      attach_file('Doc File', "#{File.join(Rails.root, 'spec', 'data', 'test.doc')}")
      fill_in('Decision No', with: '987789')
      fill_in('Appellant Name', with: 'Jonh Smith')
      fill_in('Respondent Name', with: 'Matt Black')
      select('Rafael Nadal', from: 'Judge Name')
      fill_in('Decision date', with: '21/01/1980')
      fill_in('Date of Upload', with: '31/01/1978')
      fill_in('Date published', with: '14/02/1967')
      select('VAT - Taxes', from: 'Category')
      select('VAT - Taxes - Monthly', from: 'Sub-Category')
      fill_in('Notes', with: 'filling the notes for testing')

      click_button('Add decision')

      visit '/admin/ftt-tax/987789'

      expect(page).to have_content('Decision Number: 987789')
      expect(page).to have_content('Appellant name: Jonh Smith')
      expect(page).to have_content('Respondent name: Matt Black')
      expect(page).to have_content('Judges: Rafael Nadal')
      expect(page).to have_content('Date of decision: 21 Jan 1980')
      expect(page).to have_content('Date added: 31 Jan 1978')
      expect(page).to have_content('Date updated: 14 Feb 1967')
      expect(page).to have_content('Category: VAT - Taxes')
      expect(page).to have_content('SubCategories: VAT - Taxes - Monthly')
      expect(page).to have_content('Notes filling the notes for testing')
    end

    # scenario 'list all available ftt decision' do
    #   visit '/admin/ftt-tax'
    #   expect(page).to have_content('No Access')
    # end
  end
end