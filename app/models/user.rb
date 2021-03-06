class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :payments

  ## Token Authenticatable
  acts_as_token_authenticatable

  def self.valid_login?(email, password)
    user = where(email: email).first
    [user&.valid_password?(password), user]
  end

  def reset_authentication_token!
    update_column(:authentication_token, Devise.friendly_token)
  end

  def self.custom_confirmation_url(token)
    Rails.application.config.PAYMENTSPRING_GATEWAY_PORTAL_URL + '/confirmation?confirmation_token=' + token
  end
end
