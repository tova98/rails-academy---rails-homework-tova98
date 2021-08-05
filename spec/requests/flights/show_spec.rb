RSpec.describe 'Flights', type: :request do
  let(:flight) { create(:flight) }

  describe 'GET /api/flights/:id' do
    before do
      travel_to Time.local('2020-1-1 20:00 UTC')
    end

    after do
      travel_back
    end

    it 'returns a single flight, no header' do
      get "/api/flights/#{flight.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['flight']).to include('name' => flight.name,
                                             'base_price' => flight.base_price,
                                             'no_of_seats' => flight.no_of_seats,
                                             'departs_at' => flight.departs_at,
                                             'arrives_at' => flight.arrives_at,
                                             'company_id' => flight.company_id)
    end

    it 'returns a single flight, with JSON:API header parameter' do
      get "/api/flights/#{flight.id}", headers: { 'X_API_SERIALIZER': 'JSON:API' }

      expect(response).to have_http_status(:ok)
      expect(json_body['data']['attributes']).to include('name' => flight.name,
                                                         'base_price' => flight.base_price,
                                                         'no_of_seats' => flight.no_of_seats,
                                                         'departs_at' => flight.departs_at,
                                                         'arrives_at' => flight.arrives_at,
                                                         'company_id' => flight.company_id)
    end

    it 'returns a single flight, with blueprinter header parameter' do
      get "/api/flights/#{flight.id}", headers: { 'X_API_SERIALIZER': 'blueprinter' }

      expect(response).to have_http_status(:ok)
      expect(json_body['flight']).to include('name' => flight.name,
                                             'base_price' => flight.base_price,
                                             'no_of_seats' => flight.no_of_seats,
                                             'departs_at' => flight.departs_at,
                                             'arrives_at' => flight.arrives_at,
                                             'company_id' => flight.company_id)
    end

    it 'calculates current_price > 15 days before departure' do
      flight.update(departs_at: DateTime.current + 20, arrives_at: DateTime.current + 21,
                    base_price: 100)

      get "/api/flights/#{flight.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['flight']).to include('current_price' => 100)
    end

    it 'calculates current_price 9 days before departure' do
      flight.update(departs_at: DateTime.current + 9, arrives_at: DateTime.current + 10,
                    base_price: 100)

      get "/api/flights/#{flight.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['flight']).to include('current_price' => 140)
    end

    it 'calculates current_price after departure' do
      flight.update(departs_at: DateTime.current - 1, arrives_at: DateTime.current + 1,
                    base_price: 100)

      get "/api/flights/#{flight.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['flight']).to include('current_price' => 200)
    end
  end
end
