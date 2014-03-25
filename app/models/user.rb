class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # associations
  has_and_belongs_to_many :tribunals

  def has_tribunal?(code)
    code = code.to_s if code.is_a?(Symbol)
    tribunals.any?{|trib| trib.code == code }
  end

  def display_name
    self.name || self.email rescue ''
  end

end