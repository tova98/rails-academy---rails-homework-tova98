RSpec.describe 'Flights', type: :request do
  let(:user) { create(:user, role: 'admin') }

  describe 'POST /api/flights' do
    context 'when authorised and valid' do
      it 'creates a flight' do # rubocop:disable RSpec/ExampleLength
        company = create(:company)
        flight_attributes = { 'name' => 'AirRandom',
                              'no_of_seats' => 50,
                              'base_price' => 2000,
                              'departs_at' => '2022-04-02 20:19:40 UTC',
                              'arrives_at' => '2022-04-02 22:19:40 UTC',
                              'company_id' => company.id }

        expect do
          post '/api/flights',
               params: flight_attributes.to_json,
               headers: auth_headers(user)
        end.to change(Flight, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include(flight_attributes)
      end
    end

    context 'when authorised and invalid' do
      it 'returns 400 Bad Request' do
        post '/api/flights',
             params: { flight: { name: '' } }.to_json,
             headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        post '/api/flights'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end

    context 'when authenticated but unauthorized user' do
      it 'returns error 403 :forbidden' do
        user = create(:user)
        flight_attributes = create(:flight).attributes

        post '/api/flights/', params: flight_attributes.to_json, headers: auth_headers(user)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']['resource']).to include('is forbidden')
      end
    end
  end
end
