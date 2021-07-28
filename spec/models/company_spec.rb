RSpec.describe Company do
  let(:company) { create(:company) }

  it 'is invalid without a name' do
    company.name = nil
    company.valid?
    expect(company.errors[:name]).to include("can't be blank")
  end

  it 'is invalid when name is already taken (case insensitive)' do
    create(:company, name: 'Air')
    company.name = 'air'
    company.valid?
    expect(company.errors[:name]).to include('has already been taken')
  end
end
