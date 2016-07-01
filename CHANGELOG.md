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
