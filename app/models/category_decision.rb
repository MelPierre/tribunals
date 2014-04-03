class CategoryDecision < ActiveRecord::Base
  belongs_to :all_decision
  belongs_to :subcategory
  belongs_to :category

  before_save :assign_category

  def assign_category
    self.category_id ||= Subcategory.find_by_id(self.subcategory_id).try(:category).try(:id)
  end
end
