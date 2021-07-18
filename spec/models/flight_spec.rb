RSpec.describe Flight do
  it 'is invalid without a first name' do
    flight = described_class.new(name: nil)
    flight.valid?
    expect(flight.errors[:name]).to include("can't be blank")
  end

  it 'is invalid when name is already taken (case insensitive) within scope of a company' do
    company = Company.create!(name: 'Air1')
    other_company = Company.create!(name: 'Air2')

    described_class.create!(name: 'flight', no_of_seats: 50,
                            departs_at: DateTime.current + 1,
                            arrives_at: DateTime.current + 2, base_price: 100,
                            company_id: company.id)
    flight = described_class.new(name: 'FLIGHT', company_id: other_company.id)
    flight.valid?
    expect(flight.errors[:name]).not_to include('has already been taken')
  end

  it 'is invalid without a no_of_seats' do
    flight = described_class.new(no_of_seats: nil)
    flight.valid?
    expect(flight.errors[:no_of_seats]).to include("can't be blank")
  end

  it 'is invalid when no_of_seats is less than 0' do
    flight = described_class.new(no_of_seats: -2)
    flight.valid?
    expect(flight.errors[:no_of_seats]).to include('must be greater than 0')
  end

  it 'is invalid without a departs_at' do
    flight = described_class.new(departs_at: nil)
    flight.valid?
    expect(flight.errors[:departs_at]).to include("can't be blank")
  end

  it 'is invalid without a arrives_at' do
    flight = described_class.new(arrives_at: nil)
    flight.valid?
    expect(flight.errors[:arrives_at]).to include("can't be blank")
  end

  it 'is invalid when departs_at is after arrives_at' do
    flight = described_class.new(departs_at: DateTime.current, arrives_at: DateTime.current - 1)
    flight.valid?
    expect(flight.errors[:departs_at]).to include('must depart before it arrives')
  end

  it 'is invalid when departs_at is in past' do
    flight = described_class.new(departs_at: DateTime.current - 1)
    flight.valid?
    expect(flight.errors[:departs_at]).to include('must not be in past')
  end
end
