require 'spec_helper'

describe Tribunal do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }  
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:code) }
  it { should have_and_belong_to_many(:users) }

  context 'tribunal auto scope' do

    it 'returns a tribunal for code' do
      trib = create(:tribunal, code: 'utaac')
      Tribunal.utaac.should eq(trib)
    end

    it 'returns a tribunal for a code with hyphen' do
      trib = create(:tribunal, code: 'ftt-tax')
      Tribunal.ftt_tax.should eq(trib)
    end

  end
end
