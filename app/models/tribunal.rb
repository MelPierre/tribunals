class Tribunal < ActiveRecord::Base
  validates :name, :code, presence: true, uniqueness: true

  has_and_belongs_to_many :users
  has_many :all_judges
  has_many :all_decisions
  has_many :categories
  has_many :subcategories

  scope :utiac, ->{ where(code: "utiac").first }
  scope :ftt, ->{ where(code: "ftt-tax").first }
  scope :utaac, ->{ where(code: "utaac").first }
  scope :eat, ->{ where(code: "eat").first }
end
