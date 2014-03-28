require 'spec_helper'

describe User do
  it{ should have_and_belong_to_many(:tribunals) }
  it{ should validate_presence_of(:email) }

  describe '#has_tribunal?' do
    let(:user) { build(:user) }

    context 'with aac in tribunals' do
      before do
        user.tribunals << build(:tribunal, code: 'aac')
      end

      it 'returns true when passed aac' do
        user.has_tribunal?('aac').should be_true
      end

      it 'returns true when passed :aac' do
        user.has_tribunal?(:aac).should be_true
      end

      it 'returns false when passed ftt' do
        user.has_tribunal?('ftt').should be_false
      end

      it 'returns false when passed :ftt' do
        user.has_tribunal?(:ftt).should be_false
      end

    end # with aac in tribunals

  end #has_tribunal

  describe '#display_name' do
    let(:user){ build(:user,)}
    
    it 'returns name when name is set' do
      user.name = 'Danny Hawkins'
      expect(user.display_name).to eq('Danny Hawkins')
    end

    it 'returns email without name set' do
      expect(user.display_name).to eq(user.email)
    end

  end #display_name
  
end
