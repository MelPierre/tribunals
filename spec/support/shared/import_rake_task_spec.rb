 shared_examples_for "import rake task" do |task_name, directory, code, depends='environment'|
  include_context "rake"
  let(:mock) { double('importing to database') }
  let(:task) do
    {
      import_categories: mock,
      import_subcategories: mock,
      decisions_judges: mock,
      judges: mock,
      import_decisions: mock,
      import_judges: mock,
      import_eat_subcategories: mock,
      process_docs: mock,
      update_decisions_judges: mock,
      map_categories_to_decisions: mock
    }
  end

  let(:init) {double('intializing CSVImporter', task)}

  its(:prerequisites) { should include("#{depends}")}
  context 'rake task' do

    before do
      CSVImporter.stub(:new => init)
      Object.stub(code)
      subject.invoke
    end

    if depends == 'environment'
      it "has intialized CSVImporter once, with correct #{code} csv directory and code" do
        CSVImporter.should have_received(:new).with("#{directory}", "#{code}").once
      end
    else
      it "has intialized CSVImporter twice, with correct #{code} csv directory and code" do
        CSVImporter.should have_received(:new).with("#{directory}", "#{code}").twice
      end
    end

    it "can use #{task_name} on CSVImporter" do
      CSVImporter.new.should have_received(task_name)
    end
  end
end