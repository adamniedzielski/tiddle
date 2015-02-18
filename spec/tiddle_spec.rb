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
end
