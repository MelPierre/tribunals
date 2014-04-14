 shared_examples_for "import rake task" do |task_name, directory, code, depends='environment'|
  include_context "rake"
  let(:task) do
    {
      import_categories: double('importing to database'),
      import_subcategories: double('importing to database'),
      decisions_judges: double('importing to database'),
      judges: double('importing to database'),
      import_decisions: double('importing to database'),
      import_judges: double('importing to database'),
      import_eat_subcategories: double('importing to database'),
      process_docs: double('importing to database'),
      update_decisions_judges: double('importing to database'),
      map_categories_to_decisions: double('importing to database')
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

    it "creates CSVImporter with correct #{code} csv directory and code" do
      if depends == 'environment'
        CSVImporter.should have_received(:new).with("#{directory}", "#{code}").once
      else
        CSVImporter.should have_received(:new).with("#{directory}", "#{code}").twice
      end
    end

    it "can use #{task_name} on CSVImporter" do
      CSVImporter.new.should have_received(task_name)
    end
  end
end