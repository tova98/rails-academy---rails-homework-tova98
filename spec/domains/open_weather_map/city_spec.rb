RSpec.describe OpenWeatherMap::City do
  it 'calculates correct temperature in Celsius' do
    city = described_class.new(3186984, 46.029442, 15.915, 300, 'Zabok')
    expect(city.temp).to eq(26.85)
  end

  it 'compares correctly' do
    city = described_class.new(3186984, 46.029442, 15.915, 290, 'Zabok')
    other_city = described_class.new(3816961, 43.7925, 16.942221, 300, 'Zabrišće')
    expect(city <=> other_city).to eq(-1)

    city = described_class.new(3186984, 46.029442, 15.915, 300, 'Zabok')
    expect(city <=> other_city).to eq(-1)
    expect(other_city <=> city).to eq(1)

    other_city = described_class.new(3186984, 46.029442, 15.915, 300, 'Zabok')
    expect(city <=> other_city).to eq(0)

    other_city = described_class.new(3816961, 43.7925, 16.942221, 290, 'Zabrišće')
    expect(city <=> other_city).to eq(1)
  end

  it 'parses correctly' do
    city = { 'coord' => { 'lat' => 145.77, 'lon' => -16.92 },
             'main' => { 'temp' => 300.15 }, 'id' => 2172797, 'name' => 'Cairns' }
    expect(described_class.parse(city.to_json).id).to eq(2172797)
    expect(described_class.parse(city.to_json).lat).to eq(145.77)
    expect(described_class.parse(city.to_json).lon).to eq(-16.92)
    expect(described_class.parse(city.to_json).temp).to eq(27.0)
    expect(described_class.parse(city.to_json).name).to eq('Cairns')
  end
end
