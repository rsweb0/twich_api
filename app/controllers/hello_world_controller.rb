class HelloWorldController < ApplicationController
  def index
    if user_signed_in?

      response = Twitch::Request.new.call

      @top_streams = response.data["data"] if response.success?
    end
  end
end
