require 'spec_helper'

describe Judge do
  describe "#name" do
    let(:judge) { create(:all_judge) }

    it "should return a name" do
      expect(judge.name).to eq "#{judge.prefix} #{judge.surname} #{judge.suffix}"
    end

    it "should return a name when the surname is missing" do
      judge.surname = ''
      expect(judge.name).to eq "#{judge.prefix} #{judge.suffix}"
    end
  end
end
