# frozen_string_literal: true

require 'rails_helper'

describe TwitchersController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'search' do
    let(:query_params) { { query: 'ar' } }

    let(:channels_data) do
      data = File.read(File.join(Rails.root, 'spec', 'fixtures', 'channels.json'))
      JSON.parse(data)['data']
    end

    let(:streams_data) do
      data = File.read(File.join(Rails.root, 'spec', 'fixtures', 'streams.json'))
      JSON.parse(data)['data']
    end

    let(:channels_response) { Result.new(data: channels_data, errors: []) }
    let(:streams_response) { Result.new(data: streams_data, errors: []) }

    before do
      search_endpoint = "search/channels?#{query_params.to_query}"
      channels_object = Twitch::Request.new(search_endpoint)
      streams_object = Twitch::Request.new

      expect(Twitch::Request).to receive(:new).with(no_args).and_return(streams_object)
      expect(Twitch::Request).to receive(:new).with(search_endpoint).and_return(channels_object)

      allow(channels_object).to receive(:call).and_return(channels_response)
      allow(streams_object).to receive(:call).and_return(streams_response)
    end

    it 'returns 200 status code' do
      post 'search', params: query_params, xhr: true

      expect(response).to be_successful
      expect(response).to render_template(:search)
    end

    it 'sets channels' do
      post 'search', params: query_params, xhr: true

      expect(assigns[:channels]).to eq(channels_data)
      expect(assigns[:channels].first).to have_key('in_top_20')
    end
  end
end
