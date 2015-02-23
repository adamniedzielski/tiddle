require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class TokenAuthenticatable < Authenticatable

      def authenticate!
        env["devise.skip_trackable"] = true

        resource = mapping.to.find_for_authentication(email: email_from_headers)
        return fail(:invalid_token) unless resource

        resource.authentication_tokens.each do |token|
          if Devise.secure_compare(token.body, token_from_headers)
            touch_token(token)
            return success!(resource)
          end
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

        def touch_token(token)
          token.update_attribute(:last_used_at, DateTime.current) if token.last_used_at < 1.hour.ago
        end
    end
  end
end

Warden::Strategies.add(:token_authenticatable, Devise::Strategies::TokenAuthenticatable)
