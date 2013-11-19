require 'spec_helper'

describe FttDecision do
  describe "search" do
    before(:each) do
      @decision1 = FttDecision.create!(ftt_decision_hash(text: "Some searchable text is here"))
      @decision2 = FttDecision.create!(ftt_decision_hash(text: "Some other beautiful searchable text is here gerald"))
      @decision3 = FttDecision.create!(ftt_decision_hash(claimant: "gerald", text:"Some beautiful decision made long ago"))
      @decision3.ftt_judges.create!(name: "Blake")
      adc = FttCategory.create!(name: "Benefits for children")
      adsc = FttSubcategory.create!(name: "Children's Income", ftt_category_id: adc.id)

      @decision4 = FttDecision.create!(ftt_decision_hash(claimant: 'Green'))
      @decision4.ftt_subcategories << adsc
      @decision4.save!

      @decision5 = FttDecision.create!(ftt_decision_hash(text: '[2013] UKUT 456 little pete was a green boy'))
      @decision5.ftt_subcategories << adsc
      @decision5.save!
    end

    it "should filter on search text" do
      FttDecision.filtered(:query => "beautiful").should == [@decision2, @decision3]
    end

    it "should search metadata as well as body text" do
      FttDecision.filtered(:query => "gerald").sort.should == [@decision3, @decision2].sort
    end

    it "should filter on search text and judge" do
      FttDecision.filtered(:query => "gerald", :judge => 'Blake').should == [@decision3]
    end

    it "should filter on category" do
      FttDecision.filtered(:category => "Benefits for children").sort.should == [@decision4, @decision5]
    end

    it "should filter on search text and category" do
      FttDecision.filtered(:query => "green", :category => "Benefits for children").sort.should == [@decision4, @decision5]
    end

    it "should filter on subcategory" do
      FttDecision.filtered(:subcategory => "Children's Income").sort.should == [@decision4, @decision5]
    end

    it "should filter on search text and subcategory" do
      FttDecision.filtered(:query => "[2013] UKUT 456", :subcategory => "Children's Income").should == [@decision5]
    end
  end

  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @decision = FttDecision.create!(ftt_decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
        # Workaround for a bug in carrierwave, when Fog.mock! is used.
        @decision.doc_file.file.instance_variable_set(:@file, nil)
        @decision.process_doc
      end

      after(:all) do
        @decision.destroy
        delete_test_files
      end

      it "should save a tmp html file" do
        @decision.html.should include('Test<br/>')
      end

      it "should save the pdf file" do
        @decision.pdf_file.should be_a(PdfFileUploader)
      end

      it "should save the raw text of the document" do
        @decision.text.should == "Test\n"
      end
    end
  end
end
