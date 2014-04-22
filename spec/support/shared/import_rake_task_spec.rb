 shared_examples_for "import rake task" do |task_name, directory, code, depends='environment'|
  include_context "rake"
  let(:_mock) { double('importing to database') }
  let(:task) do
    {
      import_categories: _mock,
      import_subcategories: _mock,
      decisions_judges: _mock,
      judges: _mock,
      import_decisions: _mock,
      import_judges: _mock,
      import_eat_subcategories: _mock,
      process_docs: _mock,
      update_decisions_judges: _mock,
      map_categories_to_decisions: _mock
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