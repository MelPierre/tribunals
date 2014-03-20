class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  # associations
  has_and_belongs_to_many :tribunals

  def has_tribunal?(code)
    code = code.to_s if code.is_a?(Symbol)
    return true if tribunals.any?{|trib| trib.code == code }
    false
  end

end