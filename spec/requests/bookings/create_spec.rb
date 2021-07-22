RSpec.describe 'Bookings', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST /api/bookings' do
    context 'when params are valid' do
      it 'creates a booking' do # rubocop:disable RSpec/ExampleLength
        booking_count = Booking.count
        user = FactoryBot.create(:user)
        flight = FactoryBot.create(:flight)

        post '/api/bookings',
             params: { booking: { no_of_seats: 5, seat_price: 300,
                                  user_id: user.id, flight_id: flight.id } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['booking']).to include('no_of_seats' => 5, 'seat_price' => 300,
                                                'user_id' => user.id, 'flight_id' => flight.id)
        expect(Booking.count).to eq(booking_count + 1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { seat_price: '' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include("Seat price can't be blank")
      end
    end
  end
end
