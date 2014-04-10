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
      visit '/admin/utacc'
      expect(page).to have_content('Upper Tribunal')
    end
  end
end
