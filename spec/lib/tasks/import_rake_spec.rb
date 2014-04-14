require "spec_helper"
require "rake"

describe "import:aac:all" do
  include_context "rake"
  its(:prerequisites) { should include("subcategories")}
  its(:prerequisites) { should include("decisions_judges")}
  its(:prerequisites) { should include("judges")}
end

describe "import:aac:categories" do
 it_should_behave_like "import rake task", :import_categories, 'data/aac', :utaac
end

describe "import:aac:decisions" do
 it_should_behave_like "import rake task", :import_decisions, 'data/aac', :utaac
end

describe "import:aac:judges" do
 it_should_behave_like "import rake task", :import_judges, 'data/aac', :utaac
end

describe "import:ftt:all" do
  include_context "rake"
  its(:prerequisites) { should include("subcategories")}
  its(:prerequisites) { should include("decisions_judges")}
  its(:prerequisites) { should include("judges")}
end

describe "import:ftt:categories" do
 it_should_behave_like "import rake task", :import_categories, 'data/ftt', :ftt_tax
end

describe "import:ftt:decisions" do
 it_should_behave_like "import rake task", :import_decisions, 'data/ftt', :ftt_tax
end

describe "import:ftt:judges" do
 it_should_behave_like "import rake task", :import_judges, 'data/ftt', :ftt_tax
end

describe "import:eat:all" do
  include_context "rake"
  its(:prerequisites) { should include("categories")}
  its(:prerequisites) { should include("subcategories")}
  its(:prerequisites) { should include("decisions_judges")}
  its(:prerequisites) { should include("map_categories_to_decisions")}
end

describe "import:eat:categories" do
 it_should_behave_like "import rake task", :import_categories, 'data/eat', :eat
end

describe "import:eat:subcategories" do
 it_should_behave_like "import rake task", :import_subcategories, 'data/eat', :eat
end

describe "import:eat:subcategories_level2jury" do
 it_should_behave_like "import rake task", :import_eat_subcategories, 'data/eat', :eat
end

describe "import:eat:decisions_judges" do
 it_should_behave_like "import rake task", :import_decisions, 'data/eat', :eat
end

describe "import:eat:map_categories_to_decisions" do
 it_should_behave_like "import rake task", :map_categories_to_decisions, 'data/eat', :eat
end