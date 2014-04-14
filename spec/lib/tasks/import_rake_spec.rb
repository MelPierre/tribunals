require "spec_helper"
require "rake"

describe "import:eat:all" do
  include_context "rake"
  its(:prerequisites) { should include("categories")}
  its(:prerequisites) { should include("subcategories")}
  its(:prerequisites) { should include("decisions_judges")}
  its(:prerequisites) { should include("map_categories_to_decisions")}
end

describe "import:eat:categories" do
  include_context "rake"
  let(:import_categories) {double('importing categories to database')}
  let(:init) {double('intializing CSVImporter', import_categories: import_categories)}

  its(:prerequisites) { should include("environment")}
  context 'rake task' do

    before do
      CSVImporter.stub(:new => init)
      Object.stub(:eat)
      subject.invoke
    end

    it "creates CSVImporter with correct eat csv directory and code" do
      CSVImporter.should have_received(:new).with('data/eat', 'eat')
    end

    it "can use import_categories on CSVImporter" do
      CSVImporter.new.should have_received(:import_categories)
    end
  end
end