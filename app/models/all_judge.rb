class AllJudge < ActiveRecord::Base
  # associations
  has_and_belongs_to_many :all_decisions, join_table: :decisions_judges
  belongs_to :tribunal

  #validations
  validates :name, presence: true

  default_scope -> { order('surname ASC') }

  def self.list
    order('surname ASC').map(&:name)
  end

  def name
    [prefix, surname, suffix].compact.reject(&:blank?).join(' ')
  end
end
