RSpec.describe 'Companies', type: :request do
  describe 'POST /api/companies' do
    context 'when params are valid' do
      it 'creates company' do
        company_count = Company.count
        user = create(:user, role: 'admin')
        company_attributes = attributes_for(:company).stringify_keys

        post '/api/companies',
             params: company_attributes.to_json,
             headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:created)
        expect(json_body['company']).to include(company_attributes)
        expect(Company.count).to eq(company_count + 1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        user = create(:user, role: 'admin')
        post '/api/companies',
             params: { company: { name: '' } }.to_json,
             headers: api_headers.merge({ 'Authorization' => user.token })

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end
  end
end
