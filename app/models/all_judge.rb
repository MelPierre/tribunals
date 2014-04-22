class AllJudge < ActiveRecord::Base
  # associations
  has_and_belongs_to_many :all_decisions, join_table: :decisions_judges
  belongs_to :tribunal

  scope :search, -> (query){ where('LOWER(name) like ?', "%#{query.downcase}%") }
  #validations
  validates :name, presence: true
  
  default_scope -> { order('name ASC') }

  def self.list
    order('name ASC').pluck("name AS judge")
  end
end
