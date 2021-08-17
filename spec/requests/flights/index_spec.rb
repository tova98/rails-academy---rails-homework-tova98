RSpec.describe 'Flights', type: :request do
  before do
    create_list(:flight, 3)
  end

  it 'returns flights, no headers' do
    get '/api/flights'

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].size).to eq(3)
  end

  it 'returns flights, with root 0 header parameter' do
    get '/api/flights', headers: { 'X_API_SERIALIZER_ROOT': '0' }

    expect(response).to have_http_status(:ok)
    expect(json_body.size).to eq(3)
  end

  it 'returns flights, with root 1 header parameter' do
    get '/api/flights', headers: { 'X_API_SERIALIZER_ROOT': '1' }

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].size).to eq(3)
  end

  it 'returns only active flights' do
    create(:flight, departs_at: DateTime.current - 1)

    get '/api/flights'

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].size).to eq(3)
  end

  it 'filters by name' do
    create(:flight, name: 'aaaaa')

    get '/api/flights?name_cont=aaa'

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].size).to eq(1)
  end

  it 'filters by departs_at' do
    departs_at_filter = 2.days.from_now
    create(:flight, departs_at: departs_at_filter)

    get "/api/flights?departs_at_eq=#{departs_at_filter}"

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].size).to eq(1)
  end

  it 'filters by no_of_available_seats' do
    create(:flight, no_of_seats: 100)

    get '/api/flights?no_of_available_seats_gteq=90'

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].size).to eq(1)
  end

  it 'shows number of booked seats' do
    get '/api/flights'

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].first).to include('no_of_booked_seats')
  end

  it 'shows name of company' do
    get '/api/flights'

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].first).to include('company_name')
  end
end
