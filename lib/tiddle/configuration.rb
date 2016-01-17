module Tiddle
  class Configuration
    attr_accessor :token_ttl

    def initialize
      self.token_ttl = 2.weeks
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end