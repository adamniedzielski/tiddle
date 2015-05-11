describe "Authentication using Tiddle strategy", type: :request do

  context "with valid email and token" do

    before do
      @user = User.create!(email: "test@example.com", password: "12345678")
      @token = Tiddle.create_and_return_token(@user, FakeRequest.new)
    end

    it "allows to access endpoints which require authentication" do
      get secrets_path, {},
          { "X-USER-EMAIL" => "test@example.com", "X-USER-TOKEN" => @token }
      expect(response.status).to eq 200
    end

    describe "touching token" do

      context "when token was last used more than hour ago" do

        before do
          @user.authentication_tokens.last
            .update_attribute(:last_used_at, 2.hours.ago)
        end

        it "updates last_used_at field" do
          expect do
            get secrets_path, {},
                { "X-USER-EMAIL" => "test@example.com", "X-USER-TOKEN" => @token }
          end.to change { @user.authentication_tokens.last.last_used_at }
        end
      end

      context "when token was last used less than hour ago" do

        before do
          @user.authentication_tokens.last.update_attribute(:last_used_at, 30.minutes.ago)
        end

        it "does not update last_used_at field" do
          expect do
            get secrets_path, {},
                { "X-USER-EMAIL" => "test@example.com", "X-USER-TOKEN" => @token }
          end.not_to change { @user.authentication_tokens.last.last_used_at }
        end
      end
    end

    context "when email contains uppercase letters" do

      it "converts email to lower case and authenticates user" do
        get secrets_path, {},
            { "X-USER-EMAIL" => "TEST@example.com", "X-USER-TOKEN" => @token }
        expect(response.status).to eq 200
      end
    end
  end

  context "with invalid email and valid token" do

    before do
      @user = User.create!(email: "test@example.com", password: "12345678")
      @token = Tiddle.create_and_return_token(@user, FakeRequest.new)
    end

    it "does not allow to access endpoints which require authentication" do
      get secrets_path, {},
          { "X-USER-EMAIL" => "wrong@example.com", "X-USER-TOKEN" => @token }
      expect(response.status).to eq 401
    end
  end

  context "with valid email and invalid token" do

    before do
      @user = User.create!(email: "test@example.com", password: "12345678")
      @token = Tiddle.create_and_return_token(@user, FakeRequest.new)
    end

    it "does not allow to access endpoints which require authentication" do
      get secrets_path, {},
          { "X-USER-EMAIL" => "test@example.com", "X-USER-TOKEN" => "wrong" }
      expect(response.status).to eq 401
    end
  end

  context "when no headers are passed" do

    it "does not allow to access endpoints which require authentication" do
      get secrets_path, {}, {}
      expect(response.status).to eq 401
    end
  end

  context "when model name consists of two words" do

    before do
      @admin_user = AdminUser.create!(email: "test@example.com", password: "12345678")
      @token = Tiddle.create_and_return_token(@admin_user, FakeRequest.new)
    end

    it "allows to access endpoints which require authentication" do
      get long_secrets_path, {},
          { "X-ADMIN-USER-EMAIL" => "test@example.com", "X-ADMIN-USER-TOKEN" => @token }
      expect(response.status).to eq 200
    end
  end
end
