class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :decisions, through: :category_decisions

  def self.list
    order('name ASC').pluck("name AS subcategory")
  end
end
