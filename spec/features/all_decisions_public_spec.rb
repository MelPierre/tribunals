require 'spec_helper'

  feature 'Visit public pages of a tribunal' do
    let!(:ftt){ create(:tribunal, code: 'ftt-tax', name: 'My Holy Tribunal of Very Fine Tax Justice For All')}
    let!(:eat){ create(:tribunal, code: 'eat', name: 'My Holy Tribunal of Very Fine EAT Justice For All')}

    context 'FTT' do
      scenario "can view the index page of FTT tribunal" do
        create(:all_decision, all_decision_hash(tribunal_id: ftt.id, file_number: 'FTT24267', text: "Some searchable green text is here"))
        visit '/ftt-tax'
        expect(page).to have_content('My Holy Tribunal of Very Fine Tax Justice For All')
        expect(page).to have_content('FTT24267')
      end

       scenario 'can view a FTT decision' do
        create(:all_decision, all_decision_hash(tribunal_id: ftt.id, file_number: 'T123456', text: "Some searchable green text is here"))
        visit '/ftt-tax/T123456'
        expect(page).to have_content('Decision Number: T123456')      
      end
    end

    context 'EAT' do
      scenario "can view the index page of EAT tribunal" do
        create(:all_decision, all_decision_hash(tribunal_id: eat.id, file_number: 'EAT24267', text: "Some searchable green text is here"))
        visit '/eat'
        expect(page).to have_content('My Holy Tribunal of Very Fine EAT Justice For All')
        expect(page).to have_content('EAT24267')
      end

       scenario 'can view a EAT decision' do
        create(:all_decision, all_decision_hash(tribunal_id: eat.id, file_number: 'EAT24267', text: "Some searchable green text is here"))
        visit '/eat/EAT24267'
        expect(page).to have_content('Decision Number: EAT24267')      
      end
    end
  end
