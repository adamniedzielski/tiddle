require 'tiddle/model_name'

module Tiddle
  class TokenIssuer
    MAXIMUM_TOKENS_PER_USER = 20

    def self.build
      new(MAXIMUM_TOKENS_PER_USER)
    end

    def initialize(maximum_tokens_per_user)
      self.maximum_tokens_per_user = maximum_tokens_per_user
    end

    def create_and_return_token(resource, request)
      token_class = authentication_token_class(resource)
      token, token_body = Devise.token_generator.generate(token_class, :body)

      resource.authentication_tokens
              .create! body: token_body,
                       last_used_at: Time.current,
                       ip_address: request.remote_ip,
                       user_agent: request.user_agent

      token
    end

    def expire_token(resource, request)
      find_token(resource, request.headers["X-#{ModelName.new.with_dashes(resource)}-TOKEN"])
        .try(:destroy)
    end

    def find_token(resource, token_from_headers)
      token_class = authentication_token_class(resource)
      token_body = Devise.token_generator.digest(token_class, :body, token_from_headers)
      resource.authentication_tokens.find_by(body: token_body)
    end

    def purge_old_tokens(resource)
      resource.authentication_tokens
              .order(last_used_at: :desc)
              .offset(maximum_tokens_per_user)
              .destroy_all
    end

    private

    attr_accessor :maximum_tokens_per_user

    def authentication_token_class(resource)
      resource.association(:authentication_tokens).klass
    end
  end
end
