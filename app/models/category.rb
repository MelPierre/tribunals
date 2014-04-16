class Category < ActiveRecord::Base
  belongs_to :tribunal
  has_many :subcategories
  has_many :category_decisions
  has_many :decisions, through: :category_decisions

  default_scope -> { order('categories.name ASC') }

  def self.list
    order('categories.name ASC').pluck("name AS category")
  end

  def deletable?
    (subcategories.count == 0 && decisions.count == 0)
  end
end
