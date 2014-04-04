class Tribunal < ActiveRecord::Base
  validates :name, :code, presence: true, uniqueness: true

  has_and_belongs_to_many :users
  has_many :all_judges
  has_many :all_decisions
  
  has_many :categories
  has_many :subcategories, through: :categories

  class << self

    def method_missing(m, *args, &block)
      if tribunal = where(code: m.to_s.gsub('_','-')).first
        tribunal
      else
        super
      end
    end
  
  end



end
