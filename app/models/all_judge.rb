class AllJudge < ActiveRecord::Base
  # associations
  has_and_belongs_to_many :all_decisions, join_table: :decisions_judges
  belongs_to :tribunal

  # TODO: add a validation that checks for the presence of the
  #       original_name or surname

  default_scope -> { order('surname ASC') }

  def self.list
    order('surname ASC').map(&:name)
  end

  def name
    value = [prefix, surname, suffix].compact.reject(&:blank?).join(' ')
    value.blank? ? original_name : value
  end
end
