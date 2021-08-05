RSpec.describe 'Flights statistics', type: :request do
  let(:user) { create(:user, role: 'admin') }

  before do
    flight = create(:flight, no_of_seats: 20, base_price: 100, departs_at: DateTime.current + 20,
                             arrives_at: DateTime.current + 21)
    create_list(:booking, 3, no_of_seats: 4, flight_id: flight.id)
  end

  it 'returns forbidden if user is not admin' do
    user = create(:user)

    get '/api/statistics/flights', headers: auth_headers(user)

    expect(response).to have_http_status(:forbidden)
  end

  it 'includes flight_id' do
    get '/api/statistics/flights', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].first).to include('flight_id')
  end

  it 'calculates revenue' do
    get '/api/statistics/flights', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].first).to include('revenue' => 1200)
  end

  it 'calculates no_of_booked_seats' do
    get '/api/statistics/flights', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].first).to include('no_of_booked_seats' => 12)
  end

  it 'calculates occupancy' do
    get '/api/statistics/flights', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].first).to include('occupancy' => '60.0%')
  end
end
