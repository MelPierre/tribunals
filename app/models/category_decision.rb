class CategoryDecision < ActiveRecord::Base
  belongs_to :all_decision
  belongs_to :subcategory
  belongs_to :category
end
