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
      resource.authentication_tokens
        .where(body: request.headers["X-#{resource.model_name.to_s.upcase}-TOKEN"])
        .take!
        .destroy
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
