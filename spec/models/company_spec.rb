RSpec.describe Company do
  it 'is invalid without a name' do
    company = described_class.new(name: nil)
    company.valid?
    expect(company.errors[:name]).to include("can't be blank")
  end

  it 'is invalid when name is already taken (case insensitive)' do
    described_class.create!(name: 'Air')
    company = described_class.new(name: 'air')
    company.valid?
    expect(company.errors[:name]).to include('has already been taken')
  end
end
