require "tiddle/version"
require "tiddle/strategy"
require "tiddle/rails"

module Tiddle

  def self.create_and_return_token(resource)
    resource.authentication_tokens.create!(body: Devise.friendly_token).body
  end

  def self.expire_token(resource, request)
    resource.authentication_tokens.where(body: request.headers["X-#{resource.model_name.to_s.upcase}-TOKEN"]).take!.destroy
  end
end

Devise::add_module  :token_authenticatable,
                    model: 'tiddle/model',
                    strategy: true,
                    no_input: true
