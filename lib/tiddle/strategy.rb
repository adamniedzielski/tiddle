require 'devise/strategies/authenticatable'
require 'tiddle/model_name'
require 'tiddle/token_issuer'

module Devise
  module Strategies
    class TokenAuthenticatable < Authenticatable
      def authenticate!
        env["devise.skip_trackable"] = true

        resource = mapping.to.find_for_authentication(authentication_keys_from_headers)
        return fail(:invalid_token) unless resource

        token = Tiddle::TokenIssuer.build.find_token(resource, token_from_headers)
        if token && unexpired?(token)
          touch_token(token)
          return success!(resource)
        end

        fail(:invalid_token)
      end

      def valid?
        authentication_keys_from_headers.present? && token_from_headers.present?
      end

      def store?
        false
      end

      # Avoid CSRF clean up for token authentication as it might trigger session creation in API
      # environments even if CSRF prevention is not being used.
      # Devise provides a `clean_up_csrf_token_on_authentication` option but it's not always viable
      # in applications with multiple user models and authentication strategies.
      def clean_up_csrf?
        false
      end

      private

      def authentication_keys_from_headers
        authentication_keys.map do |key|
          { key => env["HTTP_X_#{model_name}_#{key.upcase}"] }
        end.reduce(:merge)
      end

      def token_from_headers
        env["HTTP_X_#{model_name}_TOKEN"]
      end

      def model_name
        Tiddle::ModelName.new.with_underscores(mapping.to)
      end

      def authentication_keys
        mapping.to.authentication_keys
      end

      def touch_token(token)
        token.update_attribute(:last_used_at, Time.current) if token.last_used_at < 1.hour.ago
      end

      def unexpired?(token)
        return true unless token.respond_to?(:expires_in)
        return true if token.expires_in.blank? || token.expires_in.zero?

        Time.current <= token.last_used_at + token.expires_in
      end
    end
  end
end

Warden::Strategies.add(:token_authenticatable, Devise::Strategies::TokenAuthenticatable)
