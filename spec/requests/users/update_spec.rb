RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }

  describe 'PATCH /api/users/:id' do
    context 'when authorised and valid' do
      it 'updates user' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: 'Ivo', password: 'password' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => 'Ivo')
        expect(User.find(user.id)).to be_persisted
      end
    end

    context 'when authorised and invalid' do
      it 'returns 400 Bad Request' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: '' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['first_name']).to include("can't be blank")
      end
    end

    context 'when password change' do
      it 'successful' do
        patch "/api/users/#{user.id}",
              params: { user: { password: 'newpass' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(user.password_digest != User.first.password_digest).to be_truthy
      end

      it 'unsuccessful (blank)' do
        patch "/api/users/#{user.id}",
              params: { user: { password: '' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(user.password_digest == User.first.password_digest).to be_truthy
      end

      it 'unsuccessful (nil)' do
        patch "/api/users/#{user.id}",
              params: { user: { password: nil } }.to_json,
              headers: auth_headers(user)

        expect(json_body['errors']['password']).to include("can't be blank")
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        patch '/api/users/1'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end

    context 'when authenticated but unauthorized user' do
      it 'returns error 403 :forbidden' do
        other_user = create(:user)

        patch "/api/users/#{User.first.id}", headers: auth_headers(other_user)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']['resource']).to include('is forbidden')
      end
    end
  end
end
