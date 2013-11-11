class AacCategory < ActiveRecord::Base
  has_many :aac_subcategories

  def self.list
    order('name ASC').pluck("name AS category")
  end
end
