# Tiddle

Tiddle provides Devise strategy for token authentication in API-only Ruby on Rails applications. Its main feature is **support for multiple tokens per user**.

Tiddle is lightweight and non-configurable. It does what it has to do and leaves some manual implementation to you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tiddle'
```

And then execute:

    $ bundle


## Usage

1) Add ```:token_authenticatable``` inside your Devise-enabled model:

```ruby
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable,
         :token_authenticatable
end
```

2) Generate the model which stores authentication tokens. The model name is not important, but the Devise-enabled model should have association called ```authentication_tokens```.

```
rails g model AuthenticationToken body:string:index user:references last_used_at:datetime expires_in:integer ip_address:string user_agent:string
```

```ruby
class User < ActiveRecord::Base
  has_many :authentication_tokens
end
```

```body```, ```last_used_at```, ```ip_address``` and ```user_agent``` fields are required.

3) Customize ```Devise::SessionsController```. You need to create and return token in ```#create``` and expire the token in ```#destroy```.

```ruby
class Users::SessionsController < Devise::SessionsController

  def create
    user = warden.authenticate!(auth_options)
    token = Tiddle.create_and_return_token(user, request)
    render json: { authentication_token: token }
  end

  def destroy
    Tiddle.expire_token(current_user, request) if current_user
    render json: {}
  end

  private

    # this is invoked before destroy and we have to override it
    def verify_signed_out_user
    end
end
```

4) Require authentication for some controller:

```ruby
class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Post.all
  end
end
```

5) Send ```X-USER-EMAIL``` and ```X-USER-TOKEN``` as headers of every request which requires authentication.

You can read more in a blog post dedicated to Tiddle - https://blog.sundaycoding.com/blog/2015/04/04/token-authentication-with-tiddle/

## Note on Rails session

The safest solution in API-only application is not to rely on Rails session at all and disable it. Put this line in your ```application.rb```:

```ruby
config.middleware.delete ActionDispatch::Session::CookieStore
```

More: https://blog.sundaycoding.com/blog/2015/04/04/token-authentication-with-tiddle/#rails-session

## Using field other than email

Change ```config.authentication_keys``` in Devise intitializer and Tiddle will use this value.


## Security

Usually it makes sense to remove user's tokens after a password change. Depending on the project and on your taste, this can be done using various methods like running `user.authentication_tokens.destroy_all` after the password change or with an `after_save` callback in your model which runs `authentication_tokens.destroy_all if encrypted_password_changed?`.

In case of a security breach, remove all existing tokens.

Tokens are expiring after certain period of inactivity. This behavior is optional. If you want your token to expire, create it passing `expires_in` option:

```ruby
token = Tiddle.create_and_return_token(user, request, expires_in: 1.month)
```
