RSpec.describe 'Users', type: :request do
  before do
    create_list(:user, 3, role: 'admin')
  end

  context 'when authorised and valid' do
    it 'returns users, no headers' do
      get '/api/users', headers: auth_headers(User.first)

      expect(response).to have_http_status(:ok)
      expect(json_body['users'].size).to eq(3)
    end

    it 'returns users, with root 0 header parameter' do
      get '/api/users', headers: auth_headers(User.first).merge({ 'X_API_SERIALIZER_ROOT': '0' })

      expect(response).to have_http_status(:ok)
      expect(json_body.size).to eq(3)
    end

    it 'returns users, with root 1 header parameter' do
      get '/api/users', headers: auth_headers(User.first).merge({ 'X_API_SERIALIZER_ROOT': '1' })

      expect(response).to have_http_status(:ok)
      expect(json_body['users'].size).to eq(3)
    end
  end

  context 'when unauthenticated user' do
    it 'returns error 401 :unauthorized' do
      get '/api/users'

      expect(response).to have_http_status(:unauthorized)
      expect(json_body['errors']['token']).to include('is invalid')
    end
  end

  context 'when authenticated but unauthorized user' do
    it 'returns error 403 :forbidden' do
      user = create(:user)

      get '/api/users', headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
      expect(json_body['errors']['resource']).to include('is forbidden')
    end
  end
end
