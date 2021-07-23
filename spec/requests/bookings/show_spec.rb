RSpec.describe 'Bookings', type: :request do
  include TestHelpers::JsonResponse
  let(:booking) { FactoryBot.create(:booking) }

  describe 'GET /api/bookings/:id' do
    it 'returns a single booking, no header parameter' do
      get "/api/bookings/#{booking.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['booking']).to include('no_of_seats' => booking.no_of_seats,
                                              'seat_price' => booking.seat_price,
                                              'user_id' => booking.user_id,
                                              'flight_id' => booking.flight_id)
    end

    it 'returns a single booking, with JSON:API header parameter' do
      get "/api/bookings/#{booking.id}", headers: { 'X_API_SERIALIZER': 'JSON:API' }

      expect(response).to have_http_status(:ok)
      expect(json_body['booking']).to include('no_of_seats' => booking.no_of_seats,
                                              'seat_price' => booking.seat_price,
                                              'user_id' => booking.user_id,
                                              'flight_id' => booking.flight_id)
    end

    it 'returns a single booking, with blueprinter header parameter' do
      get "/api/bookings/#{booking.id}", headers: { 'X_API_SERIALIZER': 'blueprinter' }

      expect(response).to have_http_status(:ok)
      expect(json_body['booking']).to include('no_of_seats' => booking.no_of_seats,
                                              'seat_price' => booking.seat_price,
                                              'user_id' => booking.user_id,
                                              'flight_id' => booking.flight_id)
    end
  end
end
