class User
  include Mongoid::Document

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :trackable,
         #:validatable Triggers callback to will_save_change_to_email?, fails with mongoid
         :token_authenticatable

  has_many :authentication_tokens

  field :email, type: String, default: ''
  field :encrypted_password, type: String, default: ''
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :nick_name, type: String
end
