### 1.6.0

Add Rails 6.1 support

Add Ruby 3.0 support

Remove Rails 4.2 support

Remove Ruby 2.4 support


### 1.5.0

Add Rails 6 support

Fix warning on Ruby 2.7 (Andy Klimczak)

Skip CSRF clean up (Marcelo Silveira)

### 1.4.0

Support for Devise 4.6.

Relax dependency on Devise.

### 1.3.0

Support for Devise 4.5

### 1.2.0

Adds support for MongoDB.

### 1.1.0

New feature: optional token expiration after period of inactivity - #37

You have to add `expires_in` field to the database table holding the tokens
to benefit from this feature.

### 1.0.0

No major changes - just a stable version release.

### 0.7.0

Adds support for Rails 5. Requires Devise 4.

### 0.6.0

Adds support for authentication keys other than email.

### 0.5.0

Breaking changes. Token digest is stored in the database, not the actual token. This will invalidate all your existing tokens (logging users out) unless you migrate existing tokens. In order to migrate execute:

```ruby
AuthenticationToken.find_each do |token|
  token.body = Devise.token_generator.digest(AuthenticationToken, :body, token.body)
  token.save!
end
```

assuming that your model which stores tokens is called ```AuthenticationToken```.
