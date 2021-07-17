RSpec.describe OpenWeatherMap::City do
  let(:city1) do
    described_class.new(id: 3_186_984, lat: 46.029, lon: 15.915, temp_k: 270, name: 'Zabok')
  end
  let(:city2) do
    described_class.new(id: 3_186_886, lat: 45.814, lon: 15.978, temp_k: 280, name: 'Zagreb')
  end
  let(:city3) do
    described_class.new(id: 3_193_935, lat: 45.551, lon: 18.694, temp_k: 290, name: 'Osijek')
  end
  let(:city4) do
    described_class.new(id: 3_190_261, lat: 43.509, lon: 16.439, temp_k: 290, name: 'Split')
  end

  it 'calculates correct temperature in Celsius' do
    expect(city3.temp).to eq(16.85)
  end

  it 'compares correctly' do
    expect(city1 <=> city2).to eq(-1)
    expect(city3 <=> city4).to eq(-1)
    expect(city4 <=> city3).to eq(1)
    city = described_class.new(id: 3_186_984, lat: 46.029, lon: 15.915,
                               temp_k: 270, name: 'Zabok')
    expect(city <=> city1).to eq(0)
    expect(city2 <=> city1).to eq(1)
  end

  it 'sorts correctly' do
    expect([city2, city3, city1, city4].sort).to eq [city1, city2, city3, city4]
  end

  it 'parses correctly' do
    city_data = { 'coord' => { 'lat' => 145.77, 'lon' => -16.92 },
                  'main' => { 'temp' => 300.15 }, 'id' => 2_172_797, 'name' => 'Cairns' }
    city = described_class.parse(city_data)
    expect(city).to have_attributes(
      id: 2_172_797,
      lat: 145.77,
      lon: -16.92,
      temp: 27.0,
      name: 'Cairns'
    )
  end
end
