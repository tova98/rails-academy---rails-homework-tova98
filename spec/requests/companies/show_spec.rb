RSpec.describe 'Companies', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET /api/companies/:id' do
    it 'returns a single company' do
      company = FactoryBot.create(:company)

      get "/api/companies/#{company.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['company']).to include('name' => company.name)
    end
  end
end
