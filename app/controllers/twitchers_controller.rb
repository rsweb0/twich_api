class TwitchersController < ApplicationController
  before_action :authenticate_user!

  def search
  end

  def results
    if search_params[:query].blank?
      @channels = []
      return
    end

    query_params = { query: search_params[:query] }    
    endpoint = "search/channels?#{query_params.to_query}"

    @response = Twitch::Request.new(endpoint).call

    if @response.success?
      @channels = @response.data["data"]
      check_for_top_postions
      maintain_search_histories
    end
  end

  private

  def search_params
    params.permit(:query, :button)
  end

  def check_for_top_postions
    response = Twitch::Request.new(feeling_lucky).call
    return unless response.success?    
    @streams = response.data["data"]
    

    @last_pagination = response.data["pagination"].key?("cursor") ? response.data["pagination"]["cursor"] : ""
    broadcaster_login = @channels.map { |s| s['broadcaster_login'] }

    @cached_ids = []
    history_ids = current_user.history_ids
    @streams.map! do |stream|
      next if params[:button] == "feeling_lucky" && history_ids.include?(stream['id'])
      @cached_ids.push(stream)
      stream['in_top_20'] = broadcaster_login.include?(stream['user_login'])
      stream
    end

    @streams.compact!
  end

  # Since the API return the data in a specific order, I have to implement pagination logic for not repeating the results
  # Also the pagination is no more supported for channel search API
  # https://discuss.dev.twitch.tv/t/helix-video-request-not-returning-pagination-cursor-field/18199
  def feeling_lucky
    if params[:button] == "feeling_lucky"
      pagination = current_user.search_histories_by_query(search_params[:query]).try(:last_pagination)
      query = {after: pagination, first: 40}
    else
      query = {first: 20}
    end
    return "streams?#{query.to_query}"    
  end

  # From perfomance perspective this is not the best solution, all these records should be cached/stored into a NoSQL database
  # I prefered redis for this solution howevr for the time constraint, I am using the same DB.
  def maintain_search_histories
    if current_user.search_histories_by_query(params[:query]).nil?
      current_user.search_histories.create(query: params[:query], results: @cached_ids.uniq, last_pagination: @last_pagination) unless @cached_ids.blank?
    else
      existing_history = current_user.search_histories_by_query(params[:query])
      existing_results = existing_history.try(:results) || []
      existing_history.update(results: @cached_ids.concat(existing_results).uniq, last_pagination: @last_pagination)
    end
  end
end
