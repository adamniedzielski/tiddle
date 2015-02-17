describe Tiddle do

  describe "create_and_return_token" do

    before do
      @user = User.create!(email: "test@example.com", password: "12345678")
    end

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
end
