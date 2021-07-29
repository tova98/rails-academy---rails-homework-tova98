RSpec.describe 'Companies', type: :request do
  describe 'POST /api/companies' do
    context 'when authorised and valid' do
      it 'creates company' do
        company_count = Company.count
        user = create(:user, role: 'admin')
        company_attributes = attributes_for(:company).stringify_keys

        post '/api/companies',
             params: company_attributes.to_json,
             headers: auth_headers(user)

        expect(response).to have_http_status(:created)
        expect(json_body['company']).to include(company_attributes)
        expect(Company.count).to eq(company_count + 1)
      end
    end

    context 'when authorised and invalid' do
      it 'returns 400 Bad Request' do
        user = create(:user, role: 'admin')
        post '/api/companies',
             params: { company: { name: '' } }.to_json,
             headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        post '/api/companies'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end

    context 'when authenticated but unauthorized user' do
      it 'returns error 403 :forbidden' do
        user = create(:user)
        company_attributes = attributes_for(:company)

        post '/api/companies/', params: company_attributes.to_json, headers: auth_headers(user)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']['resource']).to include('is forbidden')
      end
    end
  end
end
