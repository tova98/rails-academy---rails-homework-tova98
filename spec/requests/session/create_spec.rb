RSpec.describe 'Session', type: :request do
  it 'returns user and token, logged in' do
    user = create(:user, password: 'password')

    post '/api/session',
         params: { session: { email: user.email, password: 'password' } }

    expect(response).to have_http_status(:created)
    expect(json_body['session']).to have_key('token')
    expect(json_body['session']).to have_key('user')
  end

  it 'returns error, missing parameter' do
    user = create(:user, password: 'password')

    post '/api/session',
         params: { session: { email: user.email } }

    expect(response).to have_http_status(:bad_request)
    expect(json_body['errors']['credentials']).to include('are invalid')
  end

  it 'returns error, invalid credentials' do
    user = create(:user, password: 'password')

    post '/api/session',
         params: { session: { email: user.email, password: 'invalid' } }

    expect(response).to have_http_status(:bad_request)
    expect(json_body['errors']['credentials']).to include('are invalid')
  end
end
