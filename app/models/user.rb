class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save { self.email.downcase! if self.email } # when was a nil, an error
  before_create :create_activation_digest
  # debugger
  validates(:name, presence: true, length: { minimum: 3, maximum: 50 })
  # debugger
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { minimum: 5, maximum: 250 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })

  has_secure_password()
  validates(:password, length: { minimum: 6 }, allow_blank: true)

  # Возвращает дайджест для указанной строки.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Возвращает случайный токен.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Запоминает пользователя в базе данных для использования в постоянных сеансах.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    # byebug
  end

  # Возвращает true, если указанный токен соответствует дайджесту.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Активирует учетную запись.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now, activation_digest: nil)
  end

  # Посылает письмо со ссылкой на страницу активации.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Устанавливает атрибуты для сброса пароля.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Посылает письмо со ссылкой на форму ввода нового пароля.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Возвращает true, если время для сброса пароля истекло.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def create_activation_digest
    # Создать токен и дайджест.
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
