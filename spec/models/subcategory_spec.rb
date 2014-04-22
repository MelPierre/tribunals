require 'spec_helper'

describe Subcategory do
  let!(:tribunal) { create(:tribunal, code: 'ftt-tax', name: 'ftt-tax')}

  it 'sorts alpha by default' do
    category = create(:category, tribunal: tribunal, name: 'Parent')
    create(:subcategory, category: category, name: 'Zulu')
    create(:subcategory, category: category, name: 'Alpha')
    create(:subcategory, category: category, name: 'Bravo')

    category.subcategories.pluck(:name).should eq(['Alpha', 'Bravo', 'Zulu'])
  end

  describe '#deletable?' do
    let(:category) { create(:category, tribunal: tribunal)}
    let(:subcategory) { create(:subcategory, category: category)}

    it 'returns true' do
      subcategory.deletable?.should be_true
    end

    it 'returns false with decisions' do
      decision = create(:all_decision, tribunal: tribunal)
      decision.category_decisions.create!(category: category, subcategory: subcategory)

      subcategory.deletable?.should be_false
    end

  end

end