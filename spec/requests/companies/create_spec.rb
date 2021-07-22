RSpec.describe 'Companies', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST /api/companies' do
    context 'when params are valid' do
      it 'creates company' do
        company_count = Company.count

        post '/api/companies',
             params: { company: { name: 'Air Net' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['company']).to include('name' => 'Air Net')
        expect(Company.count).to eq(company_count + 1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/companies',
             params: { company: { name: '' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name']).to include("can't be blank")
      end
    end
  end
end
