module Features
  module SessionHelpers

    def sign_in(user = nil, password = nil)

      expect(page).to have_content('Sign in')

      password ||= password || 'password123'
      user ||= create(:user, password: password)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end

    def sign_out
      visit '/admin'
      click_link 'Log out'
      expect(page).to have_content('Signed out successfully')
    end

    def add_decision
      create_seed
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

    end

    def create_seed
      create(:all_judge, name: 'Iker Casillas', tribunal_id: tribunal.id)
      create(:all_judge, name: 'Rafael Nadal', tribunal_id: tribunal.id)
      create(:all_judge, name: 'Jose Mourinho', tribunal_id: tribunal.id)

      create(:category, name: 'VAT - Taxes' , tribunal_id: tribunal.id)
      cat = create(:category, name: 'Value Added Tax - Taxes' , tribunal_id: tribunal.id)

      create(:subcategory, name:  'VAT - Taxes - Monthly', category: cat)
      create(:subcategory, name:  'VAT - Taxes - Yearly', category: cat)
      # create(:subcategory, name:  'VAT - Taxes - Monthly', category_id: cat.id)
      # create(:subcategory, name:  'VAT - Taxes - Yearly', category_id: cat.id)
    end

  end
end