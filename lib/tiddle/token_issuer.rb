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

    def create_and_return_token(resource, request, expires_in: nil)
      token_class = authentication_token_class(resource)
      token, token_body = Devise.token_generator.generate(token_class, :body)

      resource.authentication_tokens.create!(
        token_attributes(token_body, request, expires_in)
      )

      token
    end

    def expire_token(resource, request)
      find_token(resource, request.headers["X-#{ModelName.new.with_dashes(resource)}-TOKEN"])
        .try(:destroy)
    end

    def find_token(resource, token_from_headers)
      token_class = authentication_token_class(resource)
      token_body = Devise.token_generator.digest(token_class, :body, token_from_headers)
      # 'find_by' behaves differently in AR vs Mongoid, so using 'where' instead
      resource.authentication_tokens.where(body: token_body).first
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
      if resource.respond_to?(:association) # ActiveRecord
        resource.association(:authentication_tokens).klass
      elsif resource.respond_to?(:relations) # Mongoid
        resource.relations['authentication_tokens'].klass
      else
        raise 'Cannot determine authentication token class, unsupported ORM/ODM?'
      end
    end

    def token_attributes(token_body, request, expires_in)
      attributes = {
        body: token_body,
        last_used_at: Time.current,
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      }

      if expires_in
        attributes.merge(expires_in: expires_in)
      else
        attributes
      end
    end
  end
end
