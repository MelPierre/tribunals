require 'spec_helper'

describe AllDecision do
  describe "search" do
    let!(:tribunal) { create(:tribunal, code: "mytribunal", title: "My Upper Tribunal of Justice For All") }
    let!(:decision1) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, text: "Some searchable green text is here")) }
    let!(:decision2) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, text: "beautiful searchable text is here gerald")) }
    let!(:judge1) { create(:all_judge, {name: "Blake"}) }
    let!(:decision3) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant: "gerald", text:"Some beautiful decision made long ago",
                                                                all_judge_ids: [judge1.id])) }
    let!(:adc) { create(:category, name: "Benefits for children") }
    let!(:adsc) { create(:subcategory, name: "Children's Income", category_id: adc.id) }
    let!(:adsc2) { create(:subcategory, name: "Free Education", category_id: adc.id) }

    let!(:decision4) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant: 'Green', 
                                          subcategory_ids: [adsc.id])) }

    let!(:decision5) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, neutral_citation_number: '[2013] UKUT 456', text: 'little pete was a green boy', 
                                          subcategory_ids: [adsc.id, adsc2.id])) }

    it "should filter on body text" do
      tribunal.all_decisions.filtered(query: "beautiful").sort.should == [decision2, decision3]
    end

    it "should search metadata as well as body text" do
      tribunal.all_decisions.filtered(query: "gerald").sort.should == [decision2, decision3]
    end

    it "should filter on search text and judge" do
      tribunal.all_decisions.filtered(query: "gerald", judge: 'Blake').should == [decision3]
    end

    it "should filter on category" do
      results = tribunal.all_decisions.filtered(:category => "Benefits for children").sort
      results.count.should == 2
      results.should == [decision4, decision5]
    end

    it "should filter on subcategory" do
      results = tribunal.all_decisions.filtered(:subcategory => "Free Education").sort
      results.count.should == 1
      results.should == [decision5]
    end

    it "should filter on search text and category" do
      tribunal.all_decisions.filtered(:query => "green", :category => "Benefits for children").sort.should == [decision4, decision5]
    end

    it "should filter on search text and subcategory" do
      tribunal.all_decisions.filtered(:query => "green", :subcategory => "Free Education").should == [decision5]
    end   

    context "parties" do
      let!(:decision6) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant: 'Jose', subcategory_ids: [adsc.id])) }

      let!(:decision7) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, respondent: 'Jose', text: "his bag was green",
                                                                   subcategory_ids: [adsc.id])) }

      it "should filter on party" do
        results = tribunal.all_decisions.filtered(party: "Jose").sort
        results.count.should == 2
        results.should == [decision6, decision7]
      end

      it "should filter on party and search text" do
        results = tribunal.all_decisions.filtered(party: "Jose", query: "green").sort
        results.count.should == 1
        results.should == [decision7]
      end
    end  
  end
end
