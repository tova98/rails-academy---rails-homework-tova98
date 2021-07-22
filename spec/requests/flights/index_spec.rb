RSpec.describe 'Flights', type: :request do
  include TestHelpers::JsonResponse

  it 'returns flights' do
    FactoryBot.create_list(:flight, 3)

    get '/api/flights'

    expect(response).to have_http_status(:ok)
    expect(json_body['flights'].size).to eq(3)
  end
end
