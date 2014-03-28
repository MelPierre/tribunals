require 'spec_helper'

describe Tribunal do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }  
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:code) }
  it { should have_and_belong_to_many(:users) }
end
