class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :decisions, through: :category_decisions

  def self.list
    order('subcategories.name ASC').pluck("subcategories.name AS subcategory")
  end
end
