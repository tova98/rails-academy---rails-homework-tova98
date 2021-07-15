# rubocop:disable Style/NumericLiterals, Layout/LineLength
RSpec.describe OpenWeatherMap::City do
  it 'calculates correct temperature in Celsius' do
    city = described_class.new(id: 3186984, lat: 46.029442, lon: 15.915, temp_k: 300, name: 'Zabok')
    expect(city.temp).to eq(26.85)
  end

  it 'compares correctly' do
    city = described_class.new(id: 3186984, lat: 46.029442, lon: 15.915, temp_k: 290, name: 'Zabok')
    other_city = described_class.new(id: 3816961, lat: 43.7925, lon: 16.942221, temp_k: 300, name: 'Zabrišće')
    expect(city <=> other_city).to eq(-1)

    city = described_class.new(id: 3186984, lat: 46.029442, lon: 15.915, temp_k: 300, name: 'Zabok')
    expect(city <=> other_city).to eq(-1)
    expect(other_city <=> city).to eq(1)

    other_city = described_class.new(id: 3186984, lat: 46.029442, lon: 15.915, temp_k: 300, name: 'Zabok')
    expect(city <=> other_city).to eq(0)

    other_city = described_class.new(id: 3816961, lat: 43.7925, lon: 16.942221, temp_k: 290, name: 'Zabrišće')
    expect(city <=> other_city).to eq(1)
  end

  it 'parses correctly' do
    city = { 'coord' => { 'lat' => 145.77, 'lon' => -16.92 },
             'main' => { 'temp' => 300.15 }, 'id' => 2172797, 'name' => 'Cairns' }
    expect(described_class.parse(city).id).to eq(2172797)
    expect(described_class.parse(city).lat).to eq(145.77)
    expect(described_class.parse(city).lon).to eq(-16.92)
    expect(described_class.parse(city).temp).to eq(27.0)
    expect(described_class.parse(city).name).to eq('Cairns')
  end
end
# rubocop:enable Style/NumericLiterals, Layout/LineLength
