require 'spec_helper'

describe EatDecision do
  describe "search" do
    before(:each) do
      @decision1 = EatDecision.create!(eat_decision_hash(text: "Some searchable green text is here"))
      @decision2 = EatDecision.create!(eat_decision_hash(text: "beautiful searchable text is here gerald"))
      @decision3 = EatDecision.create!(eat_decision_hash(claimant: "gerald", text:"Some beautiful decision made long ago", judges: "Blake"))
      adc = EatCategory.create!(name: "Benefits for children")
      adsc = EatSubcategory.create!(name: "Children's Income", eat_category_id: adc.id)
      
      @decision4 = EatDecision.create!(eat_decision_hash(claimant: 'Green'))
      @decision4.eat_subcategories << adsc
      @decision4.save!

      @decision5 = EatDecision.create!(eat_decision_hash(text: '[2013] UKUT 456 little pete was a green boy'))
      @decision5.eat_subcategories << adsc
      @decision5.save!
    end

    it "should filter on search text" do
      EatDecision.filtered(:query => "beautiful").should == [@decision2, @decision3]
    end

    it "should search metadata as well as body text" do
      EatDecision.filtered(:query => "gerald").sort.should == [@decision3, @decision2].sort
    end

    it "should filter on search text and judge" do
      EatDecision.filtered(:query => "gerald", :judge => 'Blake').should == [@decision3]
    end

    it "should filter on category" do
      EatDecision.filtered(:category => "Benefits for children").sort.should == [@decision4, @decision5]
    end

    it "should filter on search text and category" do
      EatDecision.filtered(:query => "green", :category => "Benefits for children").sort.should == [@decision4, @decision5]
    end

    it "should filter on subcategory" do
      EatDecision.filtered(:subcategory => "Children's Income").sort.should == [@decision4, @decision5]
    end

    it "should filter on search text and subcategory" do
      EatDecision.filtered(:query => "[2013] UKUT 456", :subcategory => "Children's Income").should == [@decision5]
    end
  end

  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @eat_decision = EatDecision.create!(eat_decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
        # Workaround for a bug in carrierwave, when Fog.mock! is used.
        @eat_decision.doc_file.file.instance_variable_set(:@file, nil)
        @eat_decision.process_doc
      end

      after(:all) do
        @eat_decision.destroy
        delete_test_files
      end

      it "should save a tmp html file" do
        @eat_decision.html.should include('Test<br/>')
      end

      it "should save the pdf file" do
        @eat_decision.pdf_file.should be_a(PdfFileUploader)
      end

      it "should save the raw text of the document" do
        @eat_decision.text.should == "Test\n"
      end
    end
  end
end
