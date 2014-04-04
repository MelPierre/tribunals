# require 'spec_helper'

# describe AacDecision do 
#   describe "search" do
#     before(:each) do
#       @aac_decision1 = AacDecision.create!(aac_decision_hash(text: "Some searchable green text is here"))
#       @aac_decision2 = AacDecision.create!(aac_decision_hash(text: "beautiful searchable text is here gerald"))
#       @aac_decision3 = AacDecision.create!(aac_decision_hash(claimant: "gerald", text:"Some beautiful decision made long ago"))
#       @aac_decision3.judges.create!(name: "Blake")
#       adc = AacCategory.create!(name: "Benefits for children")
#       adsc = AacSubcategory.create!(name: "Children's Income", aac_category_id: adc.id)

#       @aac_decision4 = AacDecision.create!(aac_decision_hash(claimant: 'Green'))
#       @aac_decision4.aac_subcategories << adsc
#       @aac_decision4.save!

#       @aac_decision5 = AacDecision.create!(aac_decision_hash(ncn: '[2013] UKUT 456', text: 'little pete was a green boy', aac_decision_subcategory_id: adsc.id))
#       @aac_decision5.aac_subcategories << adsc
#       @aac_decision5.save!
#     end

#     it "should filter on search text" do
#       AacDecision.filtered(:query => "beautiful").should == [@aac_decision2, @aac_decision3]
#     end

#     it "should search metadata as well as body text" do
#       AacDecision.filtered(:query => "gerald").sort.should == [@aac_decision3, @aac_decision2].sort
#     end

#     it "should filter on search text and judge" do
#       AacDecision.filtered(:query => "gerald", :judge => 'Blake').should == [@aac_decision3]
#     end

#     it "should filter on category" do
#       AacDecision.filtered(:category => "Benefits for children").sort.should == [@aac_decision4, @aac_decision5]
#     end

#     it "should filter on search text and category" do
#       AacDecision.filtered(:query => "green", :category => "Benefits for children").sort.should == [@aac_decision4, @aac_decision5]
#     end

#     it "should filter on subcategory" do
#       AacDecision.filtered(:subcategory => "Children's Income").sort.should == [@aac_decision4, @aac_decision5]
#     end

#     it "should filter on search text and subcategory" do
#       AacDecision.filtered(:query => "[2013] UKUT 456", :subcategory => "Children's Income").should == [@aac_decision5]
#     end
#   end

#   describe "with a .doc" do
#     describe "process_doc" do
#       before(:all) do
#         @aac_decision = AacDecision.create!(aac_decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
#         # Workaround for a bug in carrierwave, when Fog.mock! is used.
#         @aac_decision.doc_file.file.instance_variable_set(:@file, nil)
#         @aac_decision.process_doc
#       end

#       after(:all) do
#         @aac_decision.destroy
#         delete_test_files
#       end

#       it "should save a tmp html file" do
#         @aac_decision.html.should include('Test<br/>')
#       end

#       it "should save the pdf file" do
#         @aac_decision.pdf_file.should be_a(PdfFileUploader)
#       end

#       it "should save the raw text of the document" do
#         @aac_decision.text.should == "Test\n"
#       end
#     end

#     it "should still save if the doc processing fails" do
#       @aac_decision = AacDecision.create!(aac_decision_hash(doc_file: File.open(__FILE__)))
#       File.should_receive(:open).and_raise(StandardError)
#       expect {
#         @aac_decision.process_doc
#       }.to change { @aac_decision.aac_import_errors.count }.by 1
#     end
#   end

#   describe "friendly ID" do
#     before(:each) { AacDecision.destroy_all }
#     files = { file_no_1: "AAC", file_no_2: "333", file_no_3: "2013" }
#     let(:decision) { AacDecision.create!(aac_decision_hash(files)) }

#     it "should respond to #friendly_id" do
#       decision.should respond_to(:friendly_id)
#     end

#     describe "finders" do
#       it "finds a decision by slug" do
#         files = { file_no_1: "ABC", file_no_2: "444", file_no_3: "2013" }
#         decision = AacDecision.create!(aac_decision_hash(files))
#         AacDecision.find('abc-444-2013').should eq decision
#       end

#       context "when the first file is missing" do
#         it "has an id without a leading hyphen" do
#           files = { file_no_1: "", file_no_2: "444", file_no_3: "2013" }
#           decision = AacDecision.create!(aac_decision_hash(files))
#           decision.id.to_s.should_not match(/^\-/)
#         end
#       end

#       context "when the second file is missing" do
#         it "should have an id without the double hyphen" do
#           files = { file_no_1: "ABC", file_no_2: "", file_no_3: "2013" }
#           decision = AacDecision.create!(aac_decision_hash(files))
#           decision.id.to_s.should_not match(/\-\-/)
#         end
#       end

#       context "when second the third file is missing" do
#         it "should have an id without the trailing hyphen" do
#           files = { file_no_1: "ABC", file_no_2: "", file_no_3: "2013" }
#           decision = AacDecision.create!(aac_decision_hash(files))
#           decision.id.to_s.should_not match(/-$/)
#         end
#       end

#       context "when all the files are missing" do
#         it "should still have an id" do
#           decision = AacDecision.create!(aac_decision_hash)
#           decision.id.should_not be_blank
#         end
#       end

#     end
#   end
# end
