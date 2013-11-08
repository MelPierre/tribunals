require 'spec_helper'

describe FttDecisionsHelper do

  describe "#display_categories" do
    before(:all) do
      @decision = FttDecision.create!(ftt_decision_hash)
      @category = FttCategory.create(name: "Category")
      subcategory = @decision.ftt_subcategories.build(ftt_category_id: @category.id, name: "Subcategory")
      subcategory.save
    end

    it "should list the category & subcategory" do
      expect(helper.display_categories(@decision)).to eq("Category/Subcategory")
    end

    describe "when the category is missing" do
      before do
        @decision = FttDecision.create!(ftt_decision_hash)
        subcategory = FttSubcategory.create(name: "Subcategory")
        @decision.ftt_subcategories << subcategory
      end

      it "should display just the subcategory" do
        expect(helper.display_categories(@decision)).to eq("Subcategory")
      end
    end

    describe "when there are multiple subcategories" do
      before do
        @decision = FttDecision.create!(ftt_decision_hash)
        category = FttCategory.create(name: "Category")
        subcategory = FttSubcategory.create(ftt_category_id: category.id, name: "Subcategory")
        category2 = FttCategory.create(name: "Category 2")
        subcategory2 = FttSubcategory.create(ftt_category_id: category2.id, name: "Subcategory 2")
        @decision.ftt_subcategories << [subcategory, subcategory2]
      end

      it "should have 2 subcategories" do
        @decision.ftt_subcategories.count.should eq 2
      end

      it "should list all categories & their subcategories" do
        result = "Category/Subcategory, Category 2/Subcategory 2"
        expect(helper.display_categories(@decision)).to eq(result)
      end

    end

  end

end
