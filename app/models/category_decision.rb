class CategoryDecision < ActiveRecord::Base

  belongs_to :decision, class_name: 'AllDecision', foreign_key: 'all_decision_id'
  belongs_to :subcategory
  belongs_to :category

  before_save :assign_category

  def assign_category
    self.category ||= subcategory.category if self.subcategory && self.subcategory.category
    self.subcategory = nil unless category.subcategories.include?(subcategory)
  end
  
end



