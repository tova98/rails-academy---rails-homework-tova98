RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/users/:id' do
    context 'when authorised and valid' do
      it 'returns a single user, no header' do
        get "/api/users/#{user.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => user.first_name,
                                             'last_name' => user.last_name,
                                             'email' => user.email)
      end

      it 'returns a single user, with JSON:API header parameter' do
        get "/api/users/#{user.id}",
            headers: auth_headers(user).merge({ 'X_API_SERIALIZER': 'JSON:API' })

        expect(response).to have_http_status(:ok)
        expect(json_body['data']['attributes']).to include('first_name' => user.first_name,
                                                           'last_name' => user.last_name,
                                                           'email' => user.email)
      end

      it 'returns a single user, with blueprinter header parameter' do
        get "/api/users/#{user.id}",
            headers: auth_headers(user).merge({ 'X_API_SERIALIZER': 'blueprinter' })

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => user.first_name,
                                             'last_name' => user.last_name,
                                             'email' => user.email)
      end
    end

    context 'when authorised and invalid' do
      it 'returns error, user not found' do
        get '/api/users/-1', headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to be_present
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        get '/api/users/1'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end

    context 'when authenticated but unauthorized user' do
      it 'returns error 403 :forbidden' do
        other_user = create(:user)

        get "/api/users/#{user.id}", headers: auth_headers(other_user)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']['resource']).to include('is forbidden')
      end
    end
  end
end
