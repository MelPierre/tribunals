require 'spec_helper'

describe EatDecisionsController do
  render_views

  describe "GET 'index'" do
    before { @decision = EatDecision.create!(eat_decision_hash).reload }

    it "should have varnish enabled" do
      controller.should_receive(:enable_varnish).once
      get :index
    end

    it "caches the page conditionally" do
      controller.should_receive(:set_cache_control).with(@decision.updated_at)
      get :index
    end

    context "parties information" do
      before { EatDecision.create!(claimant: "One", respondent: "Two") }

      it "should have parties info" do
        get :index
        expect(response.body).to match /Parties:\n<strong>One v Two<\/strong>/
      end
    end

    context "topics information" do
      before do
        @decision = EatDecision.create!(eat_decision_hash)
        category = EatCategory.create(name: "Category")
        subcategory = EatSubcategory.create(eat_category_id: category.id, name: "Subcategory")
        category2 = EatCategory.create(name: "Category 2")
        subcategory2 = EatSubcategory.create(eat_category_id: category2.id, name: "Subcategory 2")
        @decision.eat_subcategories << [subcategory, subcategory2]
      end

      it "should have topic info" do
        get :index
        topic_info = "Topics: \n<strong>Category / Subcategory, Category 2 / Subcategory 2</strong>"
        expect(response.body).to match /#{topic_info}/
      end
    end
  end

  describe "GET 'show'" do
    context "a decision exists as html, doc and pdf" do
      let(:decision) do
        EatDecision.create!(eat_decision_hash(pdf_file: sample_pdf_file, doc_file: sample_doc_file)).reload
      end

      context "rendering" do
        before { get :show, id: decision.id }

        it "should render correctly" do
          response.should be_success
        end

        it "should respond with a html representation" do
          response.content_type.should == 'text/html'
        end
      end

      context "caching" do
        after { get :show, id: decision.id }

        it "should have varnish enabled" do
          controller.should_receive(:enable_varnish).once
        end

        it "caches the page conditionally" do
          controller.should_receive(:set_cache_control).with(decision.updated_at)
        end
      end
    end

    context "decision exists with only a pdf" do
      let(:decision) do
          EatDecision.create!(eat_decision_hash(pdf_file: sample_pdf_file, doc_file: nil)).reload
      end

      context "rendering" do
        before { get :show, id: decision.id }

        it "should show pdf link" do
          link_text = "Download a PDF version of the decision"
          expect(response.body).to include link_text
        end

        it "should not show doc link" do
          link_text = "Download a Word document (.doc) version of the decision"
          expect(response.body).to_not include link_text
        end
      end
    end

    context "decision exists with only a doc" do
      let(:decision) do
          EatDecision.create!(eat_decision_hash(doc_file: sample_doc_file, pdf_file: nil)).reload
      end

      context "rendering" do
        before { get :show, id: decision.id }

        it "should show doc link" do
          link_text = "Download a Word document (.doc) version of the decision"
          expect(response.body).to include link_text
        end

        it "should not show pdf link" do
          link_text = "Download a PDF version of the decision"
          expect(response.body).to_not include link_text
        end
      end
    end

    context "decision exists with a pdf and doc" do
      let(:decision) do
          EatDecision.create!(eat_decision_hash(pdf_file: sample_pdf_file, doc_file: sample_doc_file)).reload
      end

      context "rendering" do
        before { get :show, id: decision.id }

        it "should show doc link" do
          link_text = "Download a Word document (.doc) version of the decision"
          expect(response.body).to include link_text
        end

        it "should show pdf link" do
          link_text = "Download a PDF version of the decision"
          expect(response.body).to include link_text
        end
      end
    end
  end
end
