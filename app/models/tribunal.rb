class Tribunal < ActiveRecord::Base
  validates :name, :code, presence: true, uniqueness: true
  has_and_belongs_to_many :users
end