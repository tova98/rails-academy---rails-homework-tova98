RSpec.describe 'Bookings', type: :request do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, role: 'admin') }
  let(:flight) { create(:flight) }

  describe 'POST /api/bookings' do
    context 'when authorised and valid' do
      it 'creates a booking' do
        booking_attributes = { 'no_of_seats' => 5, 'flight_id' => flight.id }

        expect do
          post '/api/bookings',
               params: booking_attributes.to_json,
               headers: auth_headers(user)
        end.to change(Booking, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['booking']).to include(booking_attributes)
      end

      it 'creates a booking for other user' do
        booking_attributes = { 'no_of_seats' => 5, 'user_id' => user.id, 'flight_id' => flight.id }

        expect do
          post '/api/bookings',
               params: booking_attributes.to_json,
               headers: auth_headers(admin_user)
        end.to change(Booking, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['booking']).to include(booking_attributes)
      end
    end

    context 'when authorised and invalid' do
      it 'returns 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { seat_price: '' } }.to_json,
             headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['seat_price']).to include("can't be blank")
      end

      it 'throws overbooked error' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 100, flight_id: flight.id } }.to_json,
             headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['flight']).to include("can't be overbooked")
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        post '/api/bookings'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end
  end
end
