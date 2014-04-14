require 'spec_helper'

feature 'Administrative appeals chamber: decisions on appeals to the Upper Tribunal' do
  let(:tribunal){ create(:tribunal, code: 'utaac', title: 'Administrative Appeals Chamber')}
  let(:user) { create(:user, tribunals: [tribunal]) }

  context 'as standard user' do
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'have access to utaac index page' do
      visit '/admin/utaac'
      expect(page).to have_content('Administrative Appeals Chamber')
    end

    scenario 'can create a new utaac decision' do
      file_number = "DC1234567"
      add_utaac_decision(file_number)

      visit "/admin/utaac/#{file_number}"

      expect(page).to have_content('2013UKUT000AAC')
      expect(page).to have_content("File no: #{file_number}")
      expect(page).to have_content('Appellant name: Jonh Smith')
      expect(page).to have_content('Respondent name: Matt Black')
      expect(page).to have_content('Judges: Rafael Nadal')
      expect(page).to have_content('Date of decision: 21 Jan 1980')
      expect(page).to have_content('Date added: 31 Jan 1978')
      expect(page).to have_content('Categories: VAT - Taxes')
      #expect(page).to have_content('Sub-Categories: VAT - Taxes - Monthly')
      expect(page).to have_content('Notes: Filling the notes for testing')

      # visit '/admin/ftt-tax/987789/edit'

      # select 'VAT - Taxes - Monthly', from: 'Subcategory'
      # click_button 'Update All decision'

      # visit '/admin/ftt-tax/987789'

      # expect(page).to have_content('Sub-Category: VAT - Taxes - Monthly')
    end

  end
end
