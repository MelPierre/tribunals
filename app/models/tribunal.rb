class Tribunal < ActiveRecord::Base
  validates :name, :code, presence: true
  has_and_belongs_to_many :users
end
