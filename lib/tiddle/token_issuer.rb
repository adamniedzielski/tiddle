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
      token = resource.authentication_tokens
        .create! body: generate_token,
                 last_used_at: DateTime.current,
                 ip_address: request.remote_ip,
                 user_agent: request.user_agent

      token.body
    end

    def expire_token(resource, request)
      find_token(resource, request.headers["X-#{ModelName.new.with_dashes(resource)}-TOKEN"])
        .try(:destroy)
    end

    def find_token(resource, token_from_headers)
      resource.authentication_tokens.detect do |token|
        Devise.secure_compare(token.body, token_from_headers)
      end
    end

    def purge_old_tokens(resource)
      resource.authentication_tokens
        .order(last_used_at: :desc)
        .offset(maximum_tokens_per_user)
        .destroy_all
    end

    private

      attr_accessor :maximum_tokens_per_user

      def generate_token
        Devise.friendly_token
      end
  end
end
