require "tiddle/version"
require "tiddle/model"
require "tiddle/strategy"
require "tiddle/rails"
require "tiddle/token_issuer"
require "tiddle/configuration"

module Tiddle
  
  def self.create_and_return_token(resource, request)
    TokenIssuer.build.create_and_return_token(resource, request)
  end

  def self.expire_token(resource, request)
    TokenIssuer.build.expire_token(resource, request)
  end

  def self.purge_old_tokens(resource)
    TokenIssuer.build.purge_old_tokens(resource)
  end

  def self.find_token(resource, token)
    TokenIssuer.build.find_token(resource, token)
  end
end

Devise.add_module :token_authenticatable,
                  model: 'tiddle/model',
                  strategy: true,
                  no_input: true
