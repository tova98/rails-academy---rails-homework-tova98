RSpec.describe 'Bookings', type: :request do
  include TestHelpers::JsonResponse

  it 'returns bookings' do
    FactoryBot.create_list(:booking, 3)

    get '/api/bookings'

    expect(response).to have_http_status(:ok)
    expect(json_body['bookings'].size).to eq(3)
  end
end
