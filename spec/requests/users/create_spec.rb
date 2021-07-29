RSpec.describe 'Users', type: :request do
  describe 'POST /api/users' do
    context 'when params are valid' do
      it 'creates a user' do
        user_attributes = attributes_for(:user).stringify_keys
        expect do
          post '/api/users',
               params: { user: user_attributes }.to_json,
               headers: api_headers
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['user']).to include(user_attributes.except('password'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/users',
             params: { user: { first_name: '' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['first_name']).to include("can't be blank")
      end
    end
  end
end
