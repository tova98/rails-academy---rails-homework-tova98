RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'PATCH /api/users/:id' do
    context 'when params are valid' do
      it 'updates user' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: 'Ivo', password: 'password' } }.to_json,
              headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => 'Ivo')
        expect(User.find(user.id)).to be_persisted
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: '' } }.to_json,
              headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['first_name']).to include("can't be blank")
      end
    end

    context 'when password change' do
      it 'successful' do
        patch "/api/users/#{user.id}",
              params: { user: { password: 'newpass' } }.to_json,
              headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:ok)
      end

      # it 'unsuccessful (blank)' do
      #   patch "/api/users/#{user.id}",
      #         params: { user: { password: '' } }.to_json,
      #         headers: api_headers.merge({ 'Authorization' => user.token })

      #   expect(json_body['errors']['password']).to include("can't be blank")
      # end

      # it 'unsuccessful (nil)' do
      #   patch "/api/users/#{user.id}",
      #         params: { user: { first_name: 'Ivo' } }.to_json,
      #         headers: api_headers.merge({ 'Authorization' => user.token })

      #   expect(json_body['errors']['password']).to include("can't be blank")
      # end
    end
  end
end
