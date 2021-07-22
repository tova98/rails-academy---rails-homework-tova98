RSpec.describe 'Companies', type: :request do
  include TestHelpers::JsonResponse

  it 'returns companies' do
    FactoryBot.create_list(:company, 3)

    get '/api/companies'

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].size).to eq(3)
  end
end
