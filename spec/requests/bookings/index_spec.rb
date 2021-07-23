RSpec.describe 'Bookings', type: :request do
  include TestHelpers::JsonResponse
  before do
    FactoryBot.create_list(:booking, 3)
  end

  it 'returns bookings, no header' do
    get '/api/bookings'

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end

  it 'returns bookings, with root 0 header parameter' do
    get '/api/bookings', headers: { 'X_API_SERIALIZER_ROOT': '0' }

    expect(response).to have_http_status(:ok)
    expect(json_body.size).to eq(3)
  end

  it 'returns bookings, with root 1 header parameter' do
    get '/api/bookings', headers: { 'X_API_SERIALIZER_ROOT': '1' }

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end
end
