require 'spec_helper'

describe AllDecision do
  describe "search" do
    let!(:utaac) { create(:tribunal, code: "utaac", title: "Upper Tribunal Administrative Appeals Chamber") }
    let!(:decision1) { create(:all_decision, all_decision_hash(tribunal_id: utaac.id, text: "Some searchable green text is here")) }
    let!(:decision2) { create(:all_decision, all_decision_hash(tribunal_id: utaac.id, text: "beautiful searchable text is here gerald")) }
    let!(:judge1) { create(:all_judge, {name: "Blake"}) }
    let!(:decision3) { create(:all_decision, all_decision_hash(tribunal_id: utaac.id, claimant: "gerald", text:"Some beautiful decision made long ago",
                                                                all_judge_ids: [judge1.id])) }
    let!(:adc) { create(:category, name: "Benefits for children") }
    let!(:adsc) { create(:subcategory, name: "Children's Income", category_id: adc.id) }
    let!(:adsc2) { create(:subcategory, name: "Free Education", category_id: adc.id) }

    let!(:decision4) { create(:all_decision, all_decision_hash(tribunal_id: utaac.id, claimant: 'Green', 
                                          subcategory_ids: [adsc.id])) }

    let!(:decision5) { create(:all_decision, all_decision_hash(tribunal_id: utaac.id, neutral_citation_number: '[2013] UKUT 456', text: 'little pete was a green boy', 
                                          subcategory_ids: [adsc2.id])) }

    it "should filter on search text" do
      AllDecision.filtered(query: "beautiful").should == [decision2, decision3]
    end

    it "should search metadata as well as body text" do
      AllDecision.filtered(query: "gerald").should == [decision2, decision3]
    end

    it "should filter on search text and judge" do
      AllDecision.filtered(query: "gerald", judge: 'Blake').should == [decision3]
    end

    it "should filter on category" do
      results = AllDecision.filtered(:category => "Benefits for children").sort
      results.count.should == 2
      results.should == [decision4, decision5]
    end

    it "should filter on subcategory" do
      results = AllDecision.filtered(:subcategory => "Free Education").sort
      results.count.should == 1
      results.should == [decision5]
    end

    ##############################################
    pending "should filter on search text and category" do
      AllDecision.filtered(:query => "green", :category => "Benefits for children").sort.should == [decision4, decision5]
    end


    pending "should filter on search text and subcategory" do
      AllDecision.filtered(:query => "[2013] UKUT 456", :subcategory => "Children's Income").should == [decision5]
    end    
  end
end
