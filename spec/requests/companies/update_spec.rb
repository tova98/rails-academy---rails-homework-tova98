RSpec.describe 'Companies', type: :request do
  let(:user) { create(:user) }

  describe 'PATCH /api/companies/:id' do
    context 'when params are valid' do
      it 'updates company' do
        company = create(:company)

        patch "/api/companies/#{company.id}",
              params: { company: { name: 'New Air' } }.to_json,
              headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:ok)
        expect(json_body['company']).to include('name' => 'New Air')
        expect(Company.find(company.id)).to be_persisted
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        company = create(:company)

        patch "/api/companies/#{company.id}",
              params: { company: { name: '' } }.to_json,
              headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end
  end
end
