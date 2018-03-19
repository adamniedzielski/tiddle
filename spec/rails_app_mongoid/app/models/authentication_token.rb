class AuthenticationToken
  include Mongoid::Document

  belongs_to :user

  field :body, type: String
  field :last_used_at, type: Time
  field :ip_address, type: String
  field :user_agent, type: String
  field :expires_in, type: Integer, default: 0
end
