RSpec.describe 'Flights', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST /api/flights' do
    context 'when params are valid' do
      it 'creates a flight' do # rubocop:disable RSpec/ExampleLength
        flight_count = Flight.count
        company = FactoryBot.create(:company)

        post '/api/flights',
             params: { flight: { name: 'AirRandom', no_of_seats: 50, base_price: 2000,
                                 departs_at: '2022-04-02 20:19:40 UTC',
                                 arrives_at: '2022-04-02 22:19:40 UTC',
                                 company_id: company.id } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include('name' => 'AirRandom',
                                               'no_of_seats' => 50,
                                               'base_price' => 2000,
                                               'departs_at' => '2022-04-02 20:19:40 UTC',
                                               'arrives_at' => '2022-04-02 22:19:40 UTC',
                                               'company_id' => company.id)
        expect(Flight.count).to eq(flight_count + 1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/flights',
             params: { flight: { name: '' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end
  end
end
