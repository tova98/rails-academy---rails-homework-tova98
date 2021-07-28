RSpec.describe 'Session', type: :request do
  it ', deletes session' do
    user = create(:user)

    delete '/api/session', headers: auth_headers(user)
    expect(response).to have_http_status(:no_content)
  end
end
