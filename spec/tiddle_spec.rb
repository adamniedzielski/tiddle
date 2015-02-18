describe Tiddle do

  before do
    @user = User.create!(email: "test@example.com", password: "12345678")
  end

  describe "create_and_return_token" do

    it "returns string with token" do
      result = Tiddle.create_and_return_token(@user)
      expect(result).to be_present
    end

    it "creates new token in the database" do
      expect do
        Tiddle.create_and_return_token(@user)
      end.to change { @user.authentication_tokens.count }.by(1)
    end

    it "sets last_used_at field" do
      Tiddle.create_and_return_token(@user)
      expect(@user.authentication_tokens.last.last_used_at).to be_within(1).of(DateTime.current)
    end
  end

  describe "expire_token" do

    before do
      token = Tiddle.create_and_return_token(@user)
      @request = instance_double("request", headers: { "X-USER-TOKEN" => token })
    end

    it "deletes token from the database" do
      expect do
        Tiddle.expire_token(@user, @request)
      end.to change { @user.authentication_tokens.count }.by(-1)
    end
  end

  describe "purge_old_tokens" do

    before do
      Tiddle.create_and_return_token(@user)
      @old = @user.authentication_tokens.last
      @old.update_attribute(:last_used_at, 2.hours.ago)

      Tiddle.create_and_return_token(@user)
      @new = @user.authentication_tokens.last
      @new.update_attribute(:last_used_at, 10.minutes.ago)

      Tiddle::MAXIMUM_TOKENS_PER_USER = 1
    end

    it "deletes old tokens which are over the limit" do
      expect do
        Tiddle.purge_old_tokens(@user)
      end.to change { @user.authentication_tokens.count }.from(2).to(1)

      expect(@user.authentication_tokens.last).to eq @new
    end
  end
end
