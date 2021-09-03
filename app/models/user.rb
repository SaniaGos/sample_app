class User < ActiveRecord::Base
  before_save { self.email.downcase! }
  # debugger
  validates(:name, presence: true, length: { minimum: 3, maximum: 50 })
  # debugger
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { minimum: 5, maximum: 250 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })

  has_secure_password()
  validates(:password, length: { minimum: 6 })
end
