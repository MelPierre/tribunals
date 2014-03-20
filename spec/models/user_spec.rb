require 'spec_helper'

describe User do
  it{ should have_and_belong_to_many(:tribunals) }
  it{ should validate_presence_of(:email) }

  describe 'default_scope' do
    let(:user) { create(:user) }

    it 'should return active users' do
      User.all.should eq([user])
    end

    it 'should not return deleted users' do
      user.update_attribute(:deleted_at, Time.now)
      User.all.should eq([])
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

  end


end
