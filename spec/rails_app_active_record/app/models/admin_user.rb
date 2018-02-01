class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable,
         :token_authenticatable

  has_many :authentication_tokens, as: :authenticatable
end
