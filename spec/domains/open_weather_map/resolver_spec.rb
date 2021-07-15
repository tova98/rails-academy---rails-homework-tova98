# rubocop:disable Style/NumericLiterals
RSpec.describe OpenWeatherMap::Resolver do
  it 'returns correct city id' do
    expect(described_class.city_id('Zabok')).to eq(3186984)
  end

  it 'returns nil if city is missing' do
    expect(described_class.city_id('')).to eq(nil)
  end
end
# rubocop:enable Style/NumericLiterals
