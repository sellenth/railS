class User < ApplicationRecord
  before_save { self.email.downcase! }
  has_many :microposts
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, uniqueness: true, presence: true,
                    length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
