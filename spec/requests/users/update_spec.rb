RSpec.describe 'Users', type: :request do
  include TestHelpers::JsonResponse

  describe 'PATCH /api/users/:id' do
    context 'when params are valid' do
      it 'updates user' do
        user = FactoryBot.create(:user)

        patch "/api/users/#{user.id}",
              params: { user: { first_name: 'Ivo' } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => 'Ivo')
        expect(User.find(user.id)).to be_persisted
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        user = FactoryBot.create(:user)

        patch "/api/users/#{user.id}",
              params: { user: { first_name: '' } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['first_name']).to include("can't be blank")
      end
    end
  end
end
