require "tiddle/version"
require "tiddle/strategy"
require "tiddle/rails"

module Tiddle
  MAXIMUM_TOKENS_PER_USER = 20

  def self.create_and_return_token(resource)
    resource.authentication_tokens.create!(body: Devise.friendly_token, last_used_at: DateTime.current).body
  end

  def self.expire_token(resource, request)
    resource.authentication_tokens.where(body: request.headers["X-#{resource.model_name.to_s.upcase}-TOKEN"]).take!.destroy
  end

  def self.purge_old_tokens(resource)
    resource.authentication_tokens.order(last_used_at: :desc).offset(MAXIMUM_TOKENS_PER_USER).destroy_all
  end
end

Devise::add_module  :token_authenticatable,
                    model: 'tiddle/model',
                    strategy: true,
                    no_input: true
