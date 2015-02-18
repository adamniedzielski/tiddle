describe "Authentication using Tiddle strategy", type: :request do

  before do
    @user = User.create!(email: "test@example.com", password: "12345678")
    @token = Tiddle.create_and_return_token(@user)
  end

  context "with valid email and token" do

    it "allows to access endpoints which require authentication" do
      get secrets_path, {}, { "X-USER-EMAIL" => "test@example.com", "X-USER-TOKEN" => @token }
      expect(response.status).to eq 200
    end
  end

  context "with invalid email and valid token" do

    it "does not allow to access endpoints which require authentication" do
      get secrets_path, {}, { "X-USER-EMAIL" => "wrong@example.com", "X-USER-TOKEN" => @token }
      expect(response.status).to eq 401
    end
  end

  context "with valid email and invalid token" do

    it "does not allow to access endpoints which require authentication" do
      get secrets_path, {}, { "X-USER-EMAIL" => "test@example.com", "X-USER-TOKEN" => "wrong" }
      expect(response.status).to eq 401
    end
  end
end
