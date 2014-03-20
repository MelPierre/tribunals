require 'spec_helper'

describe User do
  it{ should have_and_belong_to_many(:tribunals) }
  it{ should belong_to(:primary_tribunal) }
  it{ should validate_presence_of(:email) }

  describe '#save' do

    it 'should call assign_primary_tribunal' do
      user = build(:user)
      expect(user).to receive(:assign_primary_tribunal)
      user.save
    end

  end

  describe '#assign_primary_tribunal' do
    let(:user) { create(:user) }

    it 'assigns nothing without a tribunal' do
      user.send(:assign_primary_tribunal)
      user.primary_tribunal.should be_nil
    end

    it 'assigns the first tribunal if one is not assigned' do
      tribunal = create(:tribunal)
      user.tribunals << tribunal

      user.send(:assign_primary_tribunal)
      user.primary_tribunal.should eq(tribunal)
    end

    it 'it retains the existing tribunal if one is assigned' do
      primary_tribunal = build(:tribunal)
      
      user.tribunals << build(:tribunal)
      user.primary_tribunal = primary_tribunal

      user.send(:assign_primary_tribunal)
      user.primary_tribunal.should eq(primary_tribunal)
    end
  end

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

    end

    context 'with aac as primary tribunal' do
      before do
        user.primary_tribunal = build(:tribunal, code: 'aac')
      end

      it 'returns true when passed aac as string or symbol' do
        user.has_tribunal?('aac').should be_true
        user.has_tribunal?(:aac).should be_true
      end

      it 'returns false when passed ftt as string or symbol' do
        user.has_tribunal?('ftt').should be_false
        user.has_tribunal?(:ftt).should be_false
      end

    end
  end
end
