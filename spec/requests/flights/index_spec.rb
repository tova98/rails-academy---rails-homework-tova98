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
end
