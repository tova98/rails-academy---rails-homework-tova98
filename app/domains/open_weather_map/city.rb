require 'json'

def distance(lat1, lon1, lat2, lon2)
  x = deg2rad(lon1 - lon2) * Math.cos(deg2rad((lat1 + lat2)) / 2)
  y = deg2rad(lat1 - lat2)
  Math.sqrt(x * x + y * y)
end

def deg2rad(degrees)
  degrees * Math::PI / 180
end

module OpenWeatherMap
  class City
    attr_reader :id, :lat, :lon, :name

    def initialize(id:, lat:, lon:, temp_k:, name:)
      @id = id
      @lat = lat
      @lon = lon
      @temp_k = temp_k
      @name = name
    end

    def temp
      (@temp_k - 273.15).round(2)
    end

    def <=>(other)
      [temp, name] <=> [other.temp, other.name]
    end

    def self.parse(city)
      city = JSON.parse(city)
      new(id: city['id'], lat: city['coord']['lat'], lon: city['coord']['lon'],
          temp_k: city['main']['temp'], name: city['name'])
    end

    def nearby(count = 5)
      file_string = File.read(File.expand_path('city_ids.json', __dir__))
      JSON.parse(file_string).sort_by do |city|
        distance(lat, lon, city['coord']['lat'], city['coord']['lon'])
      end.first(count)
    end

    def coldest_nearby
      nearby.map { |city| OpenWeatherMap.city(city['name'], city['id']) }.min
    end
  end
end
