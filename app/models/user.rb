class User < ActiveRecord::Base
  validates :username, presence: true
  validates :username, uniqueness: true

  validates :email, presence: true
  validates :email, uniqueness: true

  validates :password, presence: true

  has_many :bits
end
