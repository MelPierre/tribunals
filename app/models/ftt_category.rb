class FttCategory < ActiveRecord::Base

  def self.list
    order('name ASC').pluck("name AS category")
  end
end
