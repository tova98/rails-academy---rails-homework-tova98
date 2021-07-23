RSpec.describe 'Companies', type: :request do
  let(:company) { create(:company) }

  describe 'GET /api/companies/:id' do
    it 'returns a single company, no header' do
      get "/api/companies/#{company.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['company']).to include('name' => company.name)
    end

    it 'returns a single company, with JSON:API header parameter' do
      get "/api/companies/#{company.id}", headers: { 'X_API_SERIALIZER': 'JSON:API' }

      expect(response).to have_http_status(:ok)
      expect(json_body['data']['attributes']).to include('name' => company.name)
    end

    it 'returns a single company, with blueprinter header parameter' do
      get "/api/companies/#{company.id}", headers: { 'X_API_SERIALIZER': 'blueprinter' }

      expect(response).to have_http_status(:ok)
      expect(json_body['company']).to include('name' => company.name)
    end
  end
end
