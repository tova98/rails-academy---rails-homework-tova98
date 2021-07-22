RSpec.describe 'Users', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST /api/users' do
    context 'when params are valid' do
      it 'creates a user' do
        user_count = User.count

        post '/api/users',
             params: { user: { first_name: 'Ivo', last_name: 'Net', email: 'ivo@net.hr' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['user']).to include('first_name' => 'Ivo', 'last_name' => 'Net',
                                             'email' => 'ivo@net.hr')
        expect(User.count).to eq(user_count + 1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/users',
             params: { user: { first_name: '' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include("First name can't be blank")
      end
    end
  end
end
