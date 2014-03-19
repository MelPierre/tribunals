class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  # associations
  has_and_belongs_to_many :tribunals
  belongs_to :primary_tribunal, class_name: 'Tribunal'
  # callbacks
  before_save :assign_primary_tribunal

  def has_tribunal?(code)
    code = code.to_s if code.is_a?(Symbol)
    return true if primary_tribunal && primary_tribunal.code == code
    return true if tribunals.any?{|trib| trib.code == code }
    false
  end

  protected

  def assign_primary_tribunal
    self.primary_tribunal ||= tribunals.first if tribunals.count > 0
  end
end
