class FakeRequest
  def initialize(
    remote_ip: "23.12.54.111",
    user_agent: "I am not a bot",
    headers: {}
  )
    self.remote_ip = remote_ip
    self.user_agent = user_agent
    self.headers = headers
  end

  attr_accessor :remote_ip, :user_agent, :headers
end
