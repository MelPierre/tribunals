class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  # associations
  has_and_belongs_to_many :tribunals
  belongs_to :primary_tribunal
  # callbacks
  before_save :assign_primary_tribunal


  protected

  def assign_primary_tribunal
    self.primary_tribunal ||= tribunals.first if tribunals.count > 0
  end
end
