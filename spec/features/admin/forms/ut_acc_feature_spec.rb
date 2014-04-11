require 'spec_helper'

feature 'Administrative appeals chamber: decisions on appeals to the Upper Tribunal' do
  let(:tribunal){ create(:tribunal,
    code: 'utaac',
    name: 'Administrative appeals chamber: decisions on appeals to the Upper Tribunal')
  }
  let(:user) { create(:user, tribunals: [tribunal]) }

  context 'as standard user' do
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'have access to utacc index page' do
      visit '/admin/utaac'
      expect(page).to have_content('Administrative appeals chamber: decisions on appeals to the Upper Tribunal')
    end
  end
end
