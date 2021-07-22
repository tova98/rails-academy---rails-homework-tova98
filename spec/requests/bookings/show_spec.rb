RSpec.describe 'Bookings', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET /api/bookings/:id' do
    it 'returns a single booking' do
      booking = FactoryBot.create(:booking)

      get "/api/bookings/#{booking.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['booking']).to include('no_of_seats' => booking.no_of_seats,
                                              'seat_price' => booking.seat_price,
                                              'user_id' => booking.user_id,
                                              'flight_id' => booking.flight_id)
    end
  end
end
