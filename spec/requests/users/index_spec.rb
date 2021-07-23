RSpec.describe 'Users', type: :request do
  before do
    create_list(:user, 3)
  end

  it 'returns users, no headers' do
    get '/api/users'

    expect(response).to have_http_status(:ok)
    expect(json_body['users'].size).to eq(3)
  end

  it 'returns users, with root 0 header parameter' do
    get '/api/users', headers: { 'X_API_SERIALIZER_ROOT': '0' }

    expect(response).to have_http_status(:ok)
    expect(json_body.size).to eq(3)
  end

  it 'returns users, with root 1 header parameter' do
    get '/api/users', headers: { 'X_API_SERIALIZER_ROOT': '1' }

    expect(response).to have_http_status(:ok)
    expect(json_body['users'].size).to eq(3)
  end
end
