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
  its(:prerequisites) { should include("environment")}
end