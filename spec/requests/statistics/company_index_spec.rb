RSpec.describe 'Flights statistics', type: :request do
  let(:user) { create(:user, role: 'admin') }

  before do
    company = create(:company)
    flight = create(:flight, no_of_seats: 20, base_price: 100, departs_at: DateTime.current + 16,
                             arrives_at: DateTime.current + 17, company_id: company.id)
    other_flight = create(:flight, no_of_seats: 20, base_price: 100,
                                   departs_at: DateTime.current + 18,
                                   arrives_at: DateTime.current + 19,
                                   company_id: company.id)
    create_list(:booking, 3, no_of_seats: 4, flight_id: flight.id)
    create_list(:booking, 3, no_of_seats: 4, flight_id: other_flight.id)
  end

  it 'returns forbidden if user is not admin' do
    user = create(:user)

    get '/api/statistics/companies', headers: auth_headers(user)

    expect(response).to have_http_status(:forbidden)
  end

  it 'includes company_id' do
    get '/api/statistics/companies', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].first).to include('company_id')
  end

  it 'calculates total revenue' do
    get '/api/statistics/companies', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].first).to include('total_revenue' => 2400)
  end

  it 'calculates total_no_of_booked_seats' do
    get '/api/statistics/companies', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].first).to include('total_no_of_booked_seats' => 24)
  end

  it 'calculates average_price_of_seats' do
    get '/api/statistics/companies', headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(json_body['companies'].first).to include('average_price_of_seats' => 100)
  end
end
