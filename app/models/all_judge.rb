class AllJudge < ActiveRecord::Base
  has_and_belongs_to_many :all_decisions, join_table: :decisions_judges
  belongs_to :tribunal

  def self.list
    order('name ASC').pluck("name AS judge")
  end
end
