require "spec_helper"
require "rake"

describe "import:eat:categories" do
  include_context "rake"
  its(:prerequisites) { should include("environment")}
end