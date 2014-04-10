require 'spec_helper'

describe Tribunal do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }  
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:code) }
  it { should have_and_belong_to_many(:users) }

  let!(:utaac) { create(:tribunal, code: 'utaac')}

  it 'loads filters from yaml' do
    Tribunal.utaac.filters.should be_present
  end

  it 'loads sort_by from yaml' do
    Tribunal.utaac.sort_by.should be_present
  end

  it 'loads results_columns from yaml' do
    Tribunal.utaac.results_columns.should be_present
  end

  context 'tribunal auto scope' do

    it 'returns a tribunal for code' do
      Tribunal.utaac.should eq(utaac)
    end

    it 'returns a tribunal for a code with hyphen' do
      trib = create(:tribunal, code: 'ftt-tax')
      Tribunal.ftt_tax.should eq(trib)
    end

  end
end
