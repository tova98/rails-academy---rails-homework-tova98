RSpec.describe 'Flights', type: :request do
  let(:user) { create(:user) }

  describe 'PATCH /api/flights/:id' do
    context 'when params are valid' do
      it 'updates flight' do
        flight = create(:flight)

        patch "/api/flights/#{flight.id}",
              params: { flight: { name: 'AirUpdated' } }.to_json,
              headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:ok)
        expect(json_body['flight']).to include('name' => 'AirUpdated')
        expect(Flight.find(flight.id)).to be_persisted
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        flight = create(:flight)

        patch "/api/flights/#{flight.id}",
              params: { flight: { name: '' } }.to_json,
              headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end
  end
end
