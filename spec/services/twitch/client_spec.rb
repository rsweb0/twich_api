# frozen_string_literal: true

require 'rails_helper'

describe Twitch::Client do
  let(:token_response_body) do
    {
      access_token: 'lpc05w8hp7lj094hcn3uj0ci470dir',
      expires_in: 5529554,
      token_type: 'bearer'
    }
  end
  let(:token_response) { double(code: 200, body: token_response_body.to_json) }

  before do
    expect(RestClient).to receive(:post).once.and_return(token_response)
  end

  describe 'call' do
    subject { described_class.new.call('streams') }
    let(:url) { 'https://api.twitch.tv/helix/streams' }

    it 'returns correct RestClient::Resource object url' do
      expect(subject.url).to eq url
    end
  end

  describe 'headers' do
    subject { described_class.new.send(:headers) }

    let(:headers) do
      {
        'Authorization' => "Bearer #{token_response_body[:access_token]}",
        'Client-Id' => Rails.application.credentials.twitch[:client_id]
      }
    end

    it 'returns the required headers hash' do
      expect(subject).to eq(headers)
    end
  end
end
