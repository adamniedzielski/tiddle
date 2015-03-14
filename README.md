# Tiddle

[![Build Status](https://travis-ci.org/adamniedzielski/tiddle.svg?branch=master)](https://travis-ci.org/adamniedzielski/tiddle)
[![Coverage Status](https://coveralls.io/repos/adamniedzielski/tiddle/badge.svg?branch=master)](https://coveralls.io/r/adamniedzielski/tiddle?branch=master)

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
rails g model AuthenticationToken body:string user:references last_used_at:datetime ip_address:string user_agent:string
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
    [...]
    token = Tiddle.create_and_return_token(resource, request)
    render json: { authentication_token: token }
  end

  def destroy
    Tiddle.expire_token(current_user, request)
    render json: {}
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
