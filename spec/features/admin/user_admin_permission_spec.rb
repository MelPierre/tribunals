require 'spec_helper'

feature 'Admin user can see the links for edit and show in the listing all decision page' do
  let(:tribunal){ create(:tribunal, code: 'ftt-tax', name: 'First Tier Tribunal', title: 'Tax: First-tier Tribunal judgments')}
  let(:user) { create(:user, tribunals: [tribunal]) }

  context 'as standard admin user' do
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'can see the edit and delete buttons on the admin page' do
      add_ftt_decision

      visit '/admin/ftt-tax/987789'

      expect(page).to have_content('Edit this decision')
      expect(page).to have_content('Delete decision')

    end

    scenario 'can not see the edit and delete buttons on the public page' do
      add_ftt_decision

      visit '/ftt-tax/987789'

      expect(page).to_not have_content('Edit this decision')
      expect(page).to_not have_content('Delete decision')

    end

    scenario 'the link to a decision points to a admin page if you visit admin' do
      add_ftt_decision

      visit '/admin/ftt-tax'

      expect(find_link('987789')[:href]).to eql('/admin/ftt-tax/987789')

    end

    scenario 'the link to a decision points to a public page if you visit a public page' do
      add_ftt_decision

      visit '/ftt-tax'

      expect(find_link('987789')[:href]).to eql('/ftt-tax/987789')

    end

  end
end
