module Twitch
  class Client
    BASE_URL = "https://api.twitch.tv/helix".freeze
    TIMEOUT_SECONDS = 30
    OPEN_TIMEOUT_SECONDS = 5

    def initialize(base_url: BASE_URL, timeout: TIMEOUT_SECONDS, open_timeout: OPEN_TIMEOUT_SECONDS)
      @base_url = base_url
      @timeout = timeout
      @open_timeout = open_timeout
    end

    def call(suffix)
      url = "#{@base_url}/#{suffix}"
      RestClient::Resource.new(url, timeout: @timeout, open_timeout: @open_timeout, headers: headers)
    end

    private

    def headers
      {
        "Authorization" => "Bearer #{app_access_token}",
        "Client-Id" => Rails.application.credentials.twitch[:client_id]
      }
    end

    def app_access_token
      Rails.cache.fetch("twitch/app_access_token", expires_in: 60.days) do
        endpoint = "https://id.twitch.tv/oauth2/token"

        query_params = {
          client_id: Rails.application.credentials.twitch[:client_id],
          client_secret: Rails.application.credentials.twitch[:client_secret],
          grant_type: "client_credentials"
        }

        url = "#{endpoint}?#{query_params.to_query}"

        response = RestClient.post(url, timeout: TIMEOUT_SECONDS, open_timeout: OPEN_TIMEOUT_SECONDS)

        JSON.parse(response.body)["access_token"] if response.code == 200
      end
    end
  end
end
