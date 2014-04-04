class Category < ActiveRecord::Base
  belongs_to :tribunal
  has_many :subcategories
  has_many :decisions, through: :category_decisions

  def self.list
    order('name ASC').pluck("name AS category")
  end
end
