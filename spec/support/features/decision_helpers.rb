module Features
  module DecisionHelpers

    def add_decision
      create_seed
      visit '/admin/ftt-tax/new'
      attach_file('Doc File', "#{File.join(Rails.root, 'spec', 'data', 'test.doc')}")
      fill_in('Decision No', with: '987789')
      fill_in('Appellant Name', with: 'Jonh Smith')
      fill_in('Respondent Name', with: 'Matt Black')
      select('Rafael Nadal', from: 'New judge')
      fill_in('Decision date', with: '21/01/1980')
      fill_in('Date of Upload', with: '31/01/1978')
      fill_in('Date published', with: '14/02/1967')
      select('VAT - Taxes', from: 'Add category')
      #select('VAT - Taxes - Monthly', from: 'Sub-Category')
      fill_in('Notes', with: 'filling the notes for testing')

      click_button('Add decision')
    end

    def create_seed
      create(:all_judge, name: 'Iker Casillas', tribunal_id: tribunal.id)
      create(:all_judge, name: 'Rafael Nadal', tribunal_id: tribunal.id)
      create(:all_judge, name: 'Jose Mourinho', tribunal_id: tribunal.id)
      category_1 = create(:category, name: 'VAT - Taxes' , tribunal_id: tribunal.id)
      category_2 = create(:category, name: 'Value Added Tax - Taxes' , tribunal_id: tribunal.id)
      create(:subcategory, name:  'VAT - Taxes - Monthly', category_id: category_1.id)
      create(:subcategory, name:  'VAT - Taxes - Yearly', category_id: category_2.id)
    end

  end
end