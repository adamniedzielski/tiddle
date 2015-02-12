require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class TokenAuthenticatable < Authenticatable

      def authenticate!
        env["devise.skip_trackable"] = true

        resource = mapping.to.where(email: email_from_headers).first
        return fail(:invalid_token) unless resource

        resource.authentication_tokens.each do |token|
          return success!(resource) if Devise.secure_compare(token.body, token_from_headers)
        end

        fail(:invalid_token)
      end

      def valid?
        email_from_headers.present? && token_from_headers.present?        
      end

      def store?
        false
      end

      private

        def email_from_headers
          env["HTTP_X_#{model_name}_EMAIL"]
        end

        def token_from_headers
          env["HTTP_X_#{model_name}_TOKEN"]
        end

        def model_name
          mapping.to.model_name.to_s.underscore.upcase
        end
    end
  end
end

Warden::Strategies.add(:token_authenticatable, Devise::Strategies::TokenAuthenticatable)
