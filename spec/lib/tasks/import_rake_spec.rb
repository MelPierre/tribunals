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
 it_should_behave_like "import rake task", :import_categories, :eat
end

describe "import:eat:subcategories" do
 it_should_behave_like "import rake task", :import_subcategories, :eat
end

describe "import:eat:subcategories_level2jury" do
 it_should_behave_like "import rake task", :import_eat_subcategories, :eat
end

describe "import:eat:decisions_judges" do
 it_should_behave_like "import rake task", :import_decisions, :eat
end

describe "import:eat:map_categories_to_decisions" do
 it_should_behave_like "import rake task", :map_categories_to_decisions, :eat
end