RSpec.describe 'Bookings', type: :request do
  before do
    create_list(:booking, 3)
  end

  it 'returns bookings, no header' do
    get '/api/bookings', headers: { 'Authorization' => Booking.first.user.token }

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end

  it 'returns bookings, with root 0 header parameter' do
    get '/api/bookings', headers: { 'X_API_SERIALIZER_ROOT': '0',
                                    'Authorization' => Booking.first.user.token }

    expect(response).to have_http_status(:ok)
    expect(json_body.size).to eq(3)
  end

  it 'returns bookings, with root 1 header parameter' do
    get '/api/bookings', headers: { 'X_API_SERIALIZER_ROOT': '1',
                                    'Authorization' => Booking.first.user.token }

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end
end
