RSpec.describe 'Companies', type: :request do
  let(:user) { create(:user) }

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

  it 'returns only companies with active flights' do
    create(:flight, company_id: Company.first.id, departs_at: DateTime.current - 1)
    create(:flight, company_id: Company.second.id, departs_at: DateTime.current + 1)

    get '/api/companies?filter=active'

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].size).to eq(1)
  end

  it 'shows correct number of active flights' do
    create(:flight, company_id: Company.first.id, departs_at: DateTime.current + 1)

    get '/api/companies'

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].first).to include('no_of_active_flights' => 1)
  end
end
