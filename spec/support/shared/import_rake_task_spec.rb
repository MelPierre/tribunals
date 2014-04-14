 shared_examples_for "import rake task" do |task_name, code|
  include_context "rake"
  let(:task) do
    {
      import_categories: double('importing to database'),
      import_subcategories: double('importing to database'),
      decisions_judges: double('importing to database'),
      judges: double('importing to database'),
      import_decisions: double('importing to database'),
      import_eat_subcategories: double('importing to database'),
      process_docs: double('importing to database'),
      map_categories_to_decisions: double('importing to database')
    }
  end

  let(:init) {double('intializing CSVImporter', task)}

  its(:prerequisites) { should include("environment")}
  context 'rake task' do

    before do
      CSVImporter.stub(:new => init)
      Object.stub(code)
      subject.invoke
    end

    it "creates CSVImporter with correct #{code} csv directory and code" do
      CSVImporter.should have_received(:new).with("data/#{code}", "#{code}")
    end

    it "can use #{task_name} on CSVImporter" do
      CSVImporter.new.should have_received(task_name)
    end
  end
end