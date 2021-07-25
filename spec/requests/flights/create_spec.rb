RSpec.describe 'Flights', type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/flights' do
    context 'when params are valid' do
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
               headers: api_headers.merge({ 'Authorization' => user.token })
        end.to change(Flight, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include(flight_attributes)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/flights',
             params: { flight: { name: '' } }.to_json,
             headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end
  end
end
