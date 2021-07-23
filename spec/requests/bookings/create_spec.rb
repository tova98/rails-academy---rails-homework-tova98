RSpec.describe 'Bookings', type: :request do
  describe 'POST /api/bookings' do
    context 'when params are valid' do
      it 'creates a booking' do # rubocop:disable RSpec/ExampleLength
        user = create(:user)
        flight = create(:flight)
        booking_attributes = { 'no_of_seats' => 5, 'seat_price' => 300,
                               'user_id' => user.id, 'flight_id' => flight.id }

        expect do
          post '/api/bookings',
               params: booking_attributes.to_json,
               headers: api_headers
        end.to change(Booking, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['booking']).to include(booking_attributes)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { seat_price: '' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['seat_price']).to include("can't be blank")
      end
    end
  end
end
