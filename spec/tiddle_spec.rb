describe Tiddle do

  before do
    @user = User.create!(email: "test@example.com", password: "12345678")
  end

  describe "create_and_return_token" do

    it "returns string with token" do
      result = Tiddle.create_and_return_token(@user, FakeRequest.new)
      expect(result).to be_present
    end

    it "creates new token in the database" do
      expect do
        Tiddle.create_and_return_token(@user, FakeRequest.new)
      end.to change { @user.authentication_tokens.count }.by(1)
    end

    it "sets last_used_at field" do
      Tiddle.create_and_return_token(@user, FakeRequest.new)
      expect(@user.authentication_tokens.last.last_used_at).to be_within(1).of(DateTime.current)
    end

    it "saves ip address" do
      Tiddle.create_and_return_token(@user, FakeRequest.new(remote_ip: "123.101.54.1"))
      expect(@user.authentication_tokens.last.ip_address).to eq "123.101.54.1"
    end

    it "saves user agent" do
      Tiddle.create_and_return_token(@user, FakeRequest.new(user_agent: "Internet Explorer 4.0"))
      expect(@user.authentication_tokens.last.user_agent).to eq "Internet Explorer 4.0"
    end
  end

  describe "expire_token" do

    before do
      token = Tiddle.create_and_return_token(@user, FakeRequest.new)
      @request = FakeRequest.new(headers: { "X-USER-TOKEN" => token })
    end

    it "deletes token from the database" do
      expect do
        Tiddle.expire_token(@user, @request)
      end.to change { @user.authentication_tokens.count }.by(-1)
    end
  end

  describe "purge_old_tokens" do

    before do
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
