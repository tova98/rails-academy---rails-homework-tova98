RSpec.describe 'Bookings', type: :request do
  let(:booking) { create(:booking) }

  describe 'PATCH /api/bookings/:id' do
    context 'when authorized and valid' do
      it 'updates booking' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: 1 } }.to_json,
              headers: auth_headers(booking.user)

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('no_of_seats' => 1)
        expect(Booking.find(booking.id)).to be_persisted
      end
    end

    context 'when authorized and invalid' do
      it 'returns 400 Bad Request' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: '' } }.to_json,
              headers: auth_headers(booking.user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['no_of_seats']).to include("can't be blank")
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        patch '/api/bookings/1'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end

    context 'when authenticated but unauthorized user' do
      it 'returns error 403 :forbidden' do
        other_user = create(:user)

        patch "/api/bookings/#{booking.id}", headers: auth_headers(other_user)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']['resource']).to include('is forbidden')
      end
    end
  end
end
