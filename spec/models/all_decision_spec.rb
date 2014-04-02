require 'spec_helper'

describe AllDecision do
  describe "search" do
    let!(:decision1) { create(:all_decision, all_decision_hash(text: "Some searchable green text is here")) }
    let!(:decision2) { create(:all_decision, all_decision_hash(text: "beautiful searchable text is here gerald")) }
    let!(:judge1) { create(:all_judge, {name: "Blake"}) }
    let!(:decision3) { create(:all_decision, all_decision_hash(claimant: "gerald", text:"Some beautiful decision made long ago",
                                                                all_judge_ids: [judge1.id])) }
    # let(:adc) { AacCategory.create!(name: "Benefits for children") }
    # let(:adsc) { AacSubcategory.create!(name: "Children's Income", aac_category_id: adc.id) }

    let!(:decision4) { create(:all_decision, all_decision_hash(claimant: 'Green')) }
    # decision4.aac_subcategories << adsc
    # decision4.save!

    # let(:decision5) { create(:all_decision, all_decision_hash(ncn: '[2013] UKUT 456', text: 'little pete was a green boy', 
                                          # aac_decision_subcategory_id: adsc.id)) }
    # decision5.aac_subcategories << adsc
    # decision5.save!

    it "should filter on search text" do
      AllDecision.filtered(query: "beautiful").should == [decision2, decision3]
    end

    it "should search metadata as well as body text" do
      AllDecision.filtered(query: "gerald").should == [decision2, decision3]
    end

    it "should filter on search text and judge" do
      AllDecision.filtered(query: "gerald", judge: 'Blake').should == [decision3]
    end


    pending "should filter on category" do
      AllDecision.filtered(:category => "Benefits for children").sort.should == [decision4, decision5]
    end

    pending "should filter on search text and category" do
      AllDecision.filtered(:query => "green", :category => "Benefits for children").sort.should == [decision4, decision5]
    end

    pending "should filter on subcategory" do
      AllDecision.filtered(:subcategory => "Children's Income").sort.should == [decision4, decision5]
    end

    pending "should filter on search text and subcategory" do
      AllDecision.filtered(:query => "[2013] UKUT 456", :subcategory => "Children's Income").should == [decision5]
    end    
  end
end
