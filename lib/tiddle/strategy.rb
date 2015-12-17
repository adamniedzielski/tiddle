require 'devise/strategies/authenticatable'
require 'tiddle/model_name'
require 'tiddle/token_issuer'

module Devise
  module Strategies
    class TokenAuthenticatable < Authenticatable

      def authenticate!
        env["devise.skip_trackable"] = true

        Rails.logger.debug authentication_keys_from_headers
        resource = mapping.to.find_for_authentication(*authentication_keys_from_headers)
        return fail(:invalid_token) unless resource

        token = Tiddle::TokenIssuer.build.find_token(resource, token_from_headers)
        if token
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

      private

        def authentication_keys_from_headers
          authentication_keys.map{|key| {key => env["HTTP_X_#{model_name}_#{key.upcase}"]}}.reduce(:merge)
        end

        def token_from_headers
          env["HTTP_X_#{model_name}_TOKEN"]
        end

        def model_name
          Tiddle::ModelName.new.with_underscores(mapping.to)
        end

        def authentication_keys
          Devise.authentication_keys
        end

        def touch_token(token)
          token.update_attribute(:last_used_at, DateTime.current) if token.last_used_at < 1.hour.ago
        end
    end
  end
end

Warden::Strategies.add(:token_authenticatable, Devise::Strategies::TokenAuthenticatable)
