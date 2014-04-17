require 'spec_helper'

describe AllDecision do
    let!(:tribunal) { create(:tribunal, code: "mytribunal", title: "My Upper Tribunal of Justice For All") }
    let!(:decision) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, file_number: "EAT/23434/223")) }
    let!(:decision2) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, file_number: "eat/5162/223")) }
    let!(:decisionDup) { create(:all_decision, all_decision_hash(id: 333, tribunal_id: tribunal.id, file_number: "EAT/23434/223")) }


  it "should set the slug to file number" do
    decision.slug.should == "eat-23434-223"
    decision2.slug.should == "eat-5162-223"
  end

  it "should set the slug for an existing decision to file number if the slug is not in use" do
    decision.update_attributes!(claimant: "Mr Clark")
    decision.slug.should == "eat-23434-223"
  end

  it "should check for uniqueness of slug" do
    decisionSlugUnique = AllDecision.new(all_decision_hash(tribunal_id: tribunal.id, claimant: 'test', decision_date: "2014-04-21" ,file_number: "EAT/5162/223"))
    decisionSlugUnique.save
    decisionSlugUnique.slug.should ==  '2014-04-21-eat-5162-223'
  end

  it "should set the slug to the id if the file number is empty" do
    decisionNoFileNumber = AllDecision.new(all_decision_hash(tribunal_id: tribunal.id))
    decisionNoFileNumber.save
    decisionNoFileNumber.slug.should_not be_nil


  end

end
