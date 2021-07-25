RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/users/:id' do
    it 'returns a single user, no header' do
      get "/api/users/#{user.id}", headers: { 'Authorization' => user.token }

      expect(response).to have_http_status(:ok)
      expect(json_body['user']).to include('first_name' => user.first_name,
                                           'last_name' => user.last_name,
                                           'email' => user.email)
    end

    it 'returns a single user, with JSON:API header parameter' do
      get "/api/users/#{user.id}", headers: { 'X_API_SERIALIZER': 'JSON:API', 'Authorization' => user.token }

      expect(response).to have_http_status(:ok)
      expect(json_body['data']['attributes']).to include('first_name' => user.first_name,
                                                         'last_name' => user.last_name,
                                                         'email' => user.email)
    end

    it 'returns a single user, with blueprinter header parameter' do
      get "/api/users/#{user.id}", headers: { 'X_API_SERIALIZER': 'blueprinter', 'Authorization' => user.token }

      expect(response).to have_http_status(:ok)
      expect(json_body['user']).to include('first_name' => user.first_name,
                                           'last_name' => user.last_name,
                                           'email' => user.email)
    end
  end
end
