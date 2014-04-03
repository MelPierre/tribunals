require 'spec_helper'

describe GenericHelper do

  describe "#display_categories" do
    pending('WIP')
    before(:all) do
      @decision = EatDecision.create!(eat_decision_hash)
      @category = EatCategory.create(name: "Category")
      subcategory = @decision.eat_subcategories.build(eat_category_id: @category.id, name: "Subcategory")
      subcategory.save
    end

    it "should list the category & subcategory" do
      pending('WIP')
      expect(helper.display_categories(@decision)).to eq("Category / Subcategory")
    end

    describe "when the category is missing" do
      before do
        @decision = EatDecision.create!(eat_decision_hash)
        subcategory = EatSubcategory.create(name: "Subcategory")
        @decision.eat_subcategories << subcategory
      end

      it "should display just the subcategory" do
        expect(helper.display_categories(@decision)).to eq("Subcategory")
      end
    end

    describe "when there are multiple subcategories" do
      before do
        @decision = EatDecision.create!(eat_decision_hash)
        category = EatCategory.create(name: "Category")
        subcategory = EatSubcategory.create(eat_category_id: category.id, name: "Subcategory")
        category2 = EatCategory.create(name: "Category 2")
        subcategory2 = EatSubcategory.create(eat_category_id: category2.id, name: "Subcategory 2")
        @decision.eat_subcategories << [subcategory, subcategory2]
      end

      it "should have 2 subcategories" do
        @decision.eat_subcategories.count.should eq 2
      end

      it "should list all categories & their subcategories" do
        pending('WIP')
        result = "Category / Subcategory, Category 2 / Subcategory 2"
        expect(helper.display_categories(@decision)).to eq(result)
      end
    end

    describe "when there is no subcategory" do
      before { @decision = EatDecision.create!(eat_decision_hash) }

      it "should not list anything" do
        expect(helper.display_categories(@decision)).to eq ''
      end
    end

    describe "when there is only a subcategory" do
      before do
        @decision = EatDecision.create!(eat_decision_hash)
        subcategory = EatSubcategory.create!(name: "Subcategory")
        @decision.eat_subcategories << subcategory.reload
      end

      it "should not list anything" do
        expect(helper.display_categories(@decision)).to eq "Subcategory"
      end
    end
  end

  describe "display_parties" do

    before(:all) do
      @decision = EatDecision.create!(eat_decision_hash.merge!(claimant: "Party1", respondent: "Party2"))
    end

    it "should list the parties" do
      expect(helper.display_parties(@decision)).to eq("Party1 v Party2")
    end
  end

end
