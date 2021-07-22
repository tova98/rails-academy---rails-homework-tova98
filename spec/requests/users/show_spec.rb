RSpec.describe 'Users', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET /api/users/:id' do
    it 'returns a single user' do
      user = FactoryBot.create(:user)

      get "/api/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['user']).to include('first_name' => user.first_name,
                                           'last_name' => user.last_name,
                                           'email' => user.email)
    end
  end
end
