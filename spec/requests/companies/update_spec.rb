RSpec.describe 'Companies', type: :request do
  let(:user) { create(:user, role: 'admin') }

  describe 'PATCH /api/companies/:id' do
    context 'when authorised and valid' do
      it 'updates company' do
        company = create(:company)

        patch "/api/companies/#{company.id}",
              params: { company: { name: 'New Air' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json_body['company']).to include('name' => 'New Air')
        expect(Company.find(company.id)).to be_persisted
      end
    end

    context 'when authorisaed and invalid' do
      it 'returns 400 Bad Request' do
        company = create(:company)

        patch "/api/companies/#{company.id}",
              params: { company: { name: '' } }.to_json,
              headers: auth_headers(user)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end

    context 'when unauthenticated user' do
      it 'returns error 401 :unauthorized' do
        patch '/api/companies/1'

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']['token']).to include('is invalid')
      end
    end

    context 'when authenticated but unauthorized user' do
      it 'returns error 403 :forbidden' do
        user = create(:user)
        company = create(:company)

        patch "/api/companies/#{company.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']['resource']).to include('is forbidden')
      end
    end
  end
end
