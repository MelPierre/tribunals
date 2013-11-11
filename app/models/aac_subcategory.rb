class AacSubcategory < ActiveRecord::Base
  belongs_to :aac_category
  has_many :aac_subcategories_decisions
  has_many :aac_decisions, through: :aac_subcategories_decisions

  def self.list
    order('name ASC').pluck("name AS subcategory")
  end
end
