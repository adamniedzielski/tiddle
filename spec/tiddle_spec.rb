describe Tiddle do
  describe "create_and_return_token" do
    before do
      @user = User.create!(email: "test@example.com", password: "12345678")
    end

    it "returns string with token" do
      result = Tiddle.create_and_return_token(@user, FakeRequest.new)
      expect(result).to be_present
      expect(result).to be_kind_of(String)
    end

    it "stores a different string to the database" do
      result = Tiddle.create_and_return_token(@user, FakeRequest.new)
      expect(result).to_not eq @user.authentication_tokens.last.body
    end

    it "creates new token in the database" do
      expect do
        Tiddle.create_and_return_token(@user, FakeRequest.new)
      end.to change { @user.authentication_tokens.count }.by(1)
    end

    it "sets last_used_at field" do
      Tiddle.create_and_return_token(@user, FakeRequest.new)
      expect(@user.authentication_tokens.last.last_used_at.to_time)
        .to be_within(1).of(Time.current)
    end

    it "saves ip address" do
      Tiddle.create_and_return_token @user,
                                     FakeRequest.new(remote_ip: "123.101.54.1")
      expect(@user.authentication_tokens.last.ip_address).to eq "123.101.54.1"
    end

    it "saves user agent" do
      Tiddle.create_and_return_token @user,
                                     FakeRequest.new(user_agent: "Internet Explorer 4.0")
      expect(@user.authentication_tokens.last.user_agent).to eq "Internet Explorer 4.0"
    end
  end

  describe "find_token" do
    before do
      @admin_user = AdminUser.create!(email: "test@example.com", password: "12345678")
      @token = Tiddle.create_and_return_token(@admin_user, FakeRequest.new)
    end

    it "returns a token from the database" do
      result = Tiddle::TokenIssuer.build.find_token(@admin_user, @token)
      expect(result).to eq @admin_user.authentication_tokens.last
    end

    it 'only returns tokens belonging to the resource' do
      other_user = AdminUser.create!(email: "test-other@example.com", password: "12345678")
      result = Tiddle::TokenIssuer.build.find_token(other_user, @token)
      expect(result).to be_nil
    end
  end

  describe "expire_token" do
    before do
      @admin_user = AdminUser.create!(email: "test@example.com", password: "12345678")
      token = Tiddle.create_and_return_token(@admin_user, FakeRequest.new)
      @request = FakeRequest.new(headers: { "X-ADMIN-USER-TOKEN" => token })
    end

    it "deletes token from the database" do
      expect do
        Tiddle.expire_token(@admin_user, @request)
      end.to change { @admin_user.authentication_tokens.count }.by(-1)
    end
  end

  describe "purge_old_tokens" do
    before do
      @user = User.create!(email: "test@example.com", password: "12345678")
      Tiddle.create_and_return_token(@user, FakeRequest.new)
      @old = @user.authentication_tokens.last
      @old.update_attribute(:last_used_at, 2.hours.ago)

      Tiddle.create_and_return_token(@user, FakeRequest.new)
      @new = @user.authentication_tokens.last
      @new.update_attribute(:last_used_at, 10.minutes.ago)
    end

    it "deletes old tokens which are over the limit" do
      expect do
        Tiddle::TokenIssuer.new(1).purge_old_tokens(@user)
      end.to change { @user.authentication_tokens.count }.from(2).to(1)

      expect(@user.authentication_tokens.last).to eq @new
    end
  end
end
