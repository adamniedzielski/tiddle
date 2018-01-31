class AuthenticationToken
  include Mongoid::Document

  belongs_to :user

  field :body, type: String
  field :last_used_at, type: DateTime
  field :ip_address, type: String
  field :user_agent, type: String
end
