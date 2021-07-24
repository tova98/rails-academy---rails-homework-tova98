RSpec.describe 'Companies', type: :request do
  before do
    create_list(:company, 3)
  end

  it 'returns companies' do
    get '/api/companies'

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].size).to eq(3)
  end

  it 'returns companies, with root 0 header parameter' do
    get '/api/companies', headers: { 'X_API_SERIALIZER_ROOT': '0' }

    expect(response).to have_http_status(:ok)
    expect(json_body.size).to eq(3)
  end

  it 'returns companies, with root 1 header parameter' do
    get '/api/companies', headers: { 'X_API_SERIALIZER_ROOT': '1' }

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].size).to eq(3)
  end
end
