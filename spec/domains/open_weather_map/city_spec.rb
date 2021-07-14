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
end
