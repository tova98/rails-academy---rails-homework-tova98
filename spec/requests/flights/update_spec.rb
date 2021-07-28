RSpec.describe 'Flights', type: :request do
  let(:user) { create(:user, role: 'admin') }

  describe 'PATCH /api/flights/:id' do
    context 'when authorised and valid' do
      it 'updates flight' do
        flight = create(:flight)

        patch "/api/flights/#{flight.id}",
              params: { flight: { name: 'AirUpdated' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_body['flight']).to include('name' => 'AirUpdated')
        expect(Flight.find(flight.id)).to be_persisted
      end
    end

    context 'when authorised and invalid' do
      it 'returns 400 Bad Request' do
        flight = create(:flight)

        patch "/api/flights/#{flight.id}",
              params: { flight: { name: '' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        patch '/api/flights/1'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end

    context 'when authenticated but unauthorized user' do
      it 'returns error 403 :forbidden' do
        user = create(:user)
        flight = create(:flight)

        patch "/api/flights/#{flight.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']['resource']).to include('is forbidden')
      end
    end
  end
end
