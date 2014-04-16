class Subcategory < ActiveRecord::Base
  belongs_to :category
  
  has_many :category_decisions
  has_many :decisions, through: :category_decisions

  default_scope -> { order('subcategories.name ASC') }

  def self.list
    order('subcategories.name ASC').pluck("subcategories.name AS subcategory")
  end

  def deletable?
    decisions.count == 0
  end

end
