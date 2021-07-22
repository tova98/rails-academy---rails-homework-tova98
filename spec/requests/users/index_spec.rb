RSpec.describe 'Users', type: :request do
  include TestHelpers::JsonResponse

  it 'returns users' do
    FactoryBot.create_list(:user, 3)

    get '/api/users'

    expect(response).to have_http_status(:ok)
    expect(json_body['users'].size).to eq(3)
  end
end
