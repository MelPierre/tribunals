require 'spec_helper'

describe Category do
  let!(:tribunal) { create(:tribunal, code: 'ftt-tax', name: 'ftt-tax')}

  it 'sorts alpha by default' do
    create(:category, tribunal: tribunal, name: 'Zulu')
    create(:category, tribunal: tribunal, name: 'Alpha')
    create(:category, tribunal: tribunal, name: 'Bravo')

    tribunal.categories.pluck(:name).should eq(['Alpha', 'Bravo', 'Zulu'])
  end

  describe '#deletable?' do
    let(:category) { create(:category, tribunal: tribunal)}

    it 'returns true' do
      category.deletable?.should be_true
    end

    it 'returns false with subcategories' do
      create(:subcategory, category: category)

      category.deletable?.should be_false
    end

    it 'returns false with decisions' do
      decision = create(:all_decision, tribunal: tribunal)
      decision.category_decisions.create!(category: category)

      category.deletable?.should be_false
    end

  end

end