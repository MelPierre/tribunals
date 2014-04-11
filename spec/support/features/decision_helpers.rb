module Features
  module DecisionHelpers

    def add_ftt_decision
      create_seed
      visit '/admin/ftt-tax/new'
      attach_file('Doc File', "#{File.join(Rails.root, 'spec', 'data', 'test.doc')}")
      fill_in('Decision No', with: '987789')
      fill_in('Appellant name', with: 'Jonh Smith')
      fill_in('Respondent name', with: 'Matt Black')
      select('Rafael Nadal', from: 'New judge')
      fill_in('Decision date', with: '21/01/1980')
      fill_in('Date of Upload', with: '31/01/1978')
      fill_in('Date published', with: '14/02/1967')
      select('VAT - Taxes', from: 'Add category')
      #select('VAT - Taxes - Monthly', from: 'Sub-Category')
      fill_in('Notes', with: 'filling the notes for testing')

      click_button('Add decision')
    end

    def add_eat_decision(file_number)
      create_seed
      visit '/admin/eat/new'
      attach_file('Doc File', "#{File.join(Rails.root, 'spec', 'data', 'test.doc')}")
      fill_in('EAT number', with: file_number)
      fill_in('Appellant name', with: 'Jonh Smith')
      fill_in('Respondent name', with: 'Matt Black')
      select('Rafael Nadal', from: 'New judge')
      fill_in('Date of hearing', with: '21/01/1980')
      fill_in('Date of upload', with: '31/01/1978')
      select('VAT - Taxes', from: 'Add topic')
      fill_in('Notes', with: 'filling the notes for testing')

      click_button('Add decision')
    end

    def add_utaac_decision
      create_seed
      visit '/admin/utaac/new'
      attach_file('Doc File', "#{File.join(Rails.root, 'spec', 'data', 'test.doc')}")
      check('Published')
      select('2013', from: 'ncn-year')
      fill_in('ncn-box-1', with: 'UKUT')
      fill_in('ncn-box-2', with: '000')
      fill_in('ncn-box-3', with: 'AAC')
      check('I have not got an NCN number')

      fill_in('file_number-1', with: '0001')
      fill_in('file_number-2', with: '0002')
      fill_in('file-number-3', with: '0003')

      fill_in('Appellant Name', with: 'Jonh Smith')
      fill_in('Respondent Name', with: 'Matt Black')
      select('Rafael Nadal', from: 'Judge name')

      fill_in('Date of decision', with: '21/01/1980')
      fill_in('Date added', with: '31/01/1978')

      select('VAT - Taxes', from: 'Category')
      select('VAT - Taxes - Monthly', from: 'Sub-category')
      fill_in('Notes', with: 'filling the notes for testing')

      fill_in('Related decision', with: "http://google.com")

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
