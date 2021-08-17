RSpec.describe 'Bookings', type: :request do
  let(:user) { create(:user, role: 'admin') }

  before do
    create_list(:booking, 3)
  end

  it 'returns bookings, no header' do
    get '/api/bookings', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end

  it 'returns bookings, with root 0 header parameter' do
    get '/api/bookings', headers: auth_headers(user).merge({ 'X_API_SERIALIZER_ROOT': '0' })

    expect(response).to have_http_status(:ok)
    expect(json_body.size).to eq(3)
  end

  it 'returns bookings, with root 1 header parameter' do
    get '/api/bookings', headers: auth_headers(user).merge({ 'X_API_SERIALIZER_ROOT': '1' })

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end

  context 'when unauthenticated user' do
    it 'returns error 401 :unauthorized' do
      get '/api/bookings'

      expect(response).to have_http_status(:unauthorized)
      expect(json_body['errors']['token']).to include('is invalid')
    end
  end

  it 'returns only bookings with active flights' do
    flight = create(:flight)
    create(:booking, flight_id: flight.id)
    flight.update({ departs_at: DateTime.current - 1 })

    get '/api/bookings?filter=active', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end

  it 'shows total_price' do
    get '/api/bookings', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].first).to include('total_price')
  end
end
