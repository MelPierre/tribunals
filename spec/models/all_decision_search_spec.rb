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
                                          subcategory_ids: [adsc.id], country: "Albania")) }

    let!(:decision5) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, neutral_citation_number: '[2013] UKUT 456', text: 'little pete was a green boy', 
                                          subcategory_ids: [adsc.id, adsc2.id])) }

    it "should filter on body text" do
      tribunal.all_decisions.filtered(query: "beautiful").sort.should == [decision2, decision3]
    end


    it "should search metadata as well as body text" do
      tribunal.all_decisions.filtered(query: "gerald").sort.should == [decision2, decision3]
    end

    context "metadata" do
      let!(:decisionClaimant) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant:'Rohan')) }
      let!(:decisionRespondent) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, respondent:'Susana')) }
      let!(:decisionNotes) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, notes:'notesTest1')) }
      let!(:decisionNCN) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, neutral_citation_number:'21EBAI12/yy/yy67')) }
      let!(:decisionFile_number) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, file_number:'123456')) }
      let!(:decisionReported_number) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, reported_number:'654321')) }
      let!(:decisionAppeal_number) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, appeal_number:'987654')) }
      let!(:decisionCountry) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, country:'India')) }
      let!(:decisionCase_name) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, case_name:'BourneCase')) }
      let!(:decisionOther_metadata) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, 
                                                                              other_metadata:{"file_no_1"=>"CIS", 
                                                                                              "file_no_2"=>"486", 
                                                                                              "file_no_3"=>"2013", 
                                                                                              "ncn_citation"=>"406", 
                                                                                              "ncn_code1"=>"UKIT", 
                                                                                              "ncn_code2"=>"AAC", 
                                                                                              "ncn_year"=>"2013", 
                                                                                              "keywords"=>"hello world pink dots yellow sun"
                                                                                              } )) }

      it "should search claimant" do
        tribunal.all_decisions.filtered(query: "Rohan").sort.should == [decisionClaimant]
      end

      it "should search respondent" do
        tribunal.all_decisions.filtered(query: "Susana").sort.should == [decisionRespondent]
      end

      it "should search notes" do
        tribunal.all_decisions.filtered(query: "notesTest1").sort.should == [decisionNotes]
      end

      it "should search neutral_citation_number" do
        tribunal.all_decisions.filtered(query: "21EBAI12/yy/yy67").sort.should == [decisionNCN]
      end

      pending "should search neutral_citation_number with a partial match" do
        tribunal.all_decisions.filtered(query: "21EBAI12/yy/yy67").sort.should == [decisionNCN]
      end
      
      it "should search file_number" do
        tribunal.all_decisions.filtered(query: "123456").sort.should == [decisionFile_number]
      end

      it "should search reported_number" do
        tribunal.all_decisions.filtered(query: "654321").sort.should == [decisionReported_number]
      end

      it "should search appeal_number" do
        tribunal.all_decisions.filtered(query: "987654").sort.should == [decisionAppeal_number]
      end

      it "should search country" do
        tribunal.all_decisions.filtered(query: "India").sort.should == [decisionCountry]
      end

      it "should search case_name" do
        tribunal.all_decisions.filtered(query: "BourneCase").sort.should == [decisionCase_name]
      end        

      it "should search other metadata" do
        tribunal.all_decisions.filtered(query: "UKIT").sort.should == [decisionOther_metadata]
      end 
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

    it "should returns no results if filter does not match" do
      results = tribunal.all_decisions.filtered(party: "Espanistang").sort
      results.count.should == 0
    end

    context "country" do
      let!(:decision10) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant: 'Green', 
                                          subcategory_ids: [adsc.id], country_guideline: true)) }
      let!(:decision11) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant: 'Green', 
                                          subcategory_ids: [adsc.id], country_guideline: false)) }

      it "should filter on country" do
        results = tribunal.all_decisions.filtered(country: "Albania").sort
        results.count.should == 1
        results.should == [decision4]     
      end

      it "should filter on country_guideline true" do
        results = tribunal.all_decisions.filtered(country_guideline: "true").sort
        results.count.should == 1
        results.should == [decision10]     
      end

      it "should filter on country_guideline false" do
        results = tribunal.all_decisions.filtered(country_guideline: "false").sort
        results.count.should == 1
        results.should == [decision11]     
      end
    end

    context "reported" do
      let!(:decision8) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant: 'Green', 
                                          subcategory_ids: [adsc.id], reported: true)) }
      let!(:decision9) { create(:all_decision, all_decision_hash(tribunal_id: tribunal.id, claimant: 'Jose', 
                                          subcategory_ids: [adsc.id], reported: false)) }

      it "should filter on reported true" do
        results = tribunal.all_decisions.filtered(reported: "true").sort
        results.count.should == 1
        results.should == [decision8]     
      end

      it "should filter on reported false" do
        results = tribunal.all_decisions.filtered(reported: "false").sort
        results.count.should == 1
        results.should == [decision9]     
      end

      it "should filter on reported all" do
        results = tribunal.all_decisions.filtered(reported: "all").sort
        results.count.should == 2
        results.should == [decision8, decision9]     
      end      
    end
  end
end
