require 'spec_helper'

feature 'Administrative appeals chamber: decisions on appeals to the Upper Tribunal' do
  let(:tribunal){ create(:tribunal, code: 'utacc', title: 'Administrative appeals chamber: decisions on appeals to the Upper Tribunal')}
  let(:user) { create(:user, tribunals: [tribunal]) }

  context 'as standard user' do
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'have access to utaac index page' do
      visit '/admin/utaac'
      expect(page).to have_content('Administrative appeals chamber: decisions on appeals to the Upper Tribunal')
    end

    scenario 'can create a new utaac decision' do
      add_utaac_decision

      visit '/admin/utaac/987789'

      expect(page).to have_content('2013 UKUT AAC')
      expect(page).to have_content('File No. CN 0002 0003')
      expect(page).to have_content('Appellant name: Jonh Smith')
      expect(page).to have_content('Respondent name: Matt Black')
      expect(page).to have_content('Judge name: Rafael Nadal')
      expect(page).to have_content('Date of decision: 21/01/1980')
      expect(page).to have_content('Date added: 31/01/1978')
      expect(page).to have_content('Category: VAT - Taxes')
      expect(page).to have_content('Sub-category: VAT - Taxes - Monthly')
      expect(page).to have_content('Notes: Filling the notes for testing')
      expect(page).to have_content('Related decisions: http://google.com')

      # visit '/admin/ftt-tax/987789/edit'

      # select 'VAT - Taxes - Monthly', from: 'Subcategory'
      # click_button 'Update All decision'

      # visit '/admin/ftt-tax/987789'

      # expect(page).to have_content('Sub-Category: VAT - Taxes - Monthly')
    end

  end
end
