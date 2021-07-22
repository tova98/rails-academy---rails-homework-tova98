RSpec.describe 'Bookings', type: :request do
  include TestHelpers::JsonResponse

  describe 'PATCH /api/bookings/:id' do
    context 'when params are valid' do
      it 'updates booking' do
        booking = FactoryBot.create(:booking)

        patch "/api/bookings/#{booking.id}",
              params: { booking: { seat_price: 450 } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('seat_price' => 450)
        expect(Booking.find(booking.id)).to be_persisted
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        booking = FactoryBot.create(:booking)

        patch "/api/bookings/#{booking.id}",
              params: { booking: { seat_price: '' } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['seat_price']).to include("can't be blank")
      end
    end
  end
end
