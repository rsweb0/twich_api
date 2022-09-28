module Twitch
  class Request < Base

    attr_reader :endpoint

    def initialize(endpoint = 'streams')
      # check if endpoint is nil
      @endpoint = endpoint || 'streams' 
      super()
    end

    private

    def perform
      response = Client.new.call(endpoint).get
      if response.code == 200
        @data = JSON.parse(response.body) #["data"]
      else
        Rails.logger.error response.errors
        # Do not expose backend error to UI
        @errors << 'Something went wrong.'
      end
    rescue RestClient::Exceptions::Timeout
      @errors << 'Connection timed out.'
    rescue RestClient::Exception
      @errors << 'Something went wrong.'
    end
  end
end
