require "tiddle/version"
require "tiddle/model"
require "tiddle/strategy"
require "tiddle/rails"
require "tiddle/token_issuer"

module Tiddle
  def self.create_and_return_token(resource, request, options = {})
    TokenIssuer.build.create_and_return_token(resource, request, options)
  end

  def self.expire_token(resource, request)
    TokenIssuer.build.expire_token(resource, request)
  end

  def self.purge_old_tokens(resource, maximum_tokens_per_user: TokenIssuer.MAXIMUM_TOKENS_PER_USER)
    TokenIssuer.build.purge_old_tokens(resource, maximum_tokens_per_user: maximum_tokens_per_user)
  end
end

Devise.add_module :token_authenticatable,
                  model: 'tiddle/model',
                  strategy: true,
                  no_input: true
