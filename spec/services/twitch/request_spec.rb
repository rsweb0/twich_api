# frozen_string_literal: true

require 'rails_helper'

describe Twitch::Request do
  describe 'perform' do
    let(:client) { Twitch::Client.new }
    subject { described_class.new.send(:perform) }
    let(:client_response) { double(get: response) }

    before do
      expect_any_instance_of(Twitch::Client).to receive(:call).once.and_return(client_response)
    end

    context 'when response code is 200' do
      let(:body) do
        data = File.read(File.join(Rails.root, 'spec', 'fixtures', 'streams.json'))

        JSON.parse(data)
      end
      let(:response) { double(code: 200, body: body.to_json) }

      context 'streams endpoint' do
        it 'returns correct data in response' do
          expect(subject).to eq body['data']
        end
      end
    end

    context 'when response code is not 200' do
      let(:response) { double(code: 404) }

      it 'returns error message in response' do
        expect(subject).to eq ['Something went wrong.']
      end
    end
  end
end
