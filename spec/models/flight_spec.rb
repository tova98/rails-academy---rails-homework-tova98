RSpec.describe Flight do
  let(:flight) { create(:flight) }

  it 'is invalid without a first name' do
    flight.name = nil
    flight.valid?
    expect(flight.errors[:name]).to include("can't be blank")
  end

  it 'is invalid when name is already taken (case insensitive) within scope of a company' do
    company = create(:company)
    other_company = create(:company)
    create(:flight, name: 'flight', company_id: company.id)
    flight.name = 'FLIGHT'
    flight.company_id = other_company.id

    flight.valid?
    expect(flight.errors[:name]).not_to include('has already been taken')
  end

  it 'is invalid without a no_of_seats' do
    flight.no_of_seats = nil
    flight.valid?
    expect(flight.errors[:no_of_seats]).to include("can't be blank")
  end

  it 'is invalid when no_of_seats is less than 0' do
    flight.no_of_seats = -2
    flight.valid?
    expect(flight.errors[:no_of_seats]).to include('must be greater than 0')
  end

  it 'is invalid without a departs_at' do
    flight.departs_at = nil
    flight.valid?
    expect(flight.errors[:departs_at]).to include("can't be blank")
  end

  it 'is invalid without a arrives_at' do
    flight.arrives_at = nil
    flight.valid?
    expect(flight.errors[:arrives_at]).to include("can't be blank")
  end

  it 'is invalid when departs_at is after arrives_at' do
    flight.arrives_at = DateTime.current - 100
    flight.valid?
    expect(flight.errors[:departs_at]).to include('must depart before it arrives')
  end
end
