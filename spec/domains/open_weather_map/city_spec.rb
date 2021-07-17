# rubocop:disable Layout/LineLength
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

  it 'sorts correctly' do
    city1 = described_class.new(id: 3186984, lat: 46.029, lon: 15.915, temp_k: 270, name: 'Zabok')
    city2 = described_class.new(id: 3186886, lat: 45.814, lon: 15.978, temp_k: 280, name: 'Zagreb')
    city3 = described_class.new(id: 3193935, lat: 45.551, lon: 18.694, temp_k: 290, name: 'Osijek')
    city4 = described_class.new(id: 3190261, lat: 43.509, lon: 16.439, temp_k: 290, name: 'Split')
    expect([city2, city3, city1, city4].sort).to eq [city1, city2, city3, city4]
  end

  it 'parses correctly' do
    city_data = { 'coord' => { 'lat' => 145.77, 'lon' => -16.92 },
                  'main' => { 'temp' => 300.15 }, 'id' => 2172797, 'name' => 'Cairns' }
    city = described_class.parse(city_data)
    expect(city).to have_attributes(
      id: 2172797,
      lat: 145.77,
      lon: -16.92,
      temp: 27.0,
      name: 'Cairns'
    )
  end
end
# rubocop:enable Layout/LineLength
