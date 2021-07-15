require 'json'
require 'faraday'

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
      city.is_a?(Hash) ? city = city.to_json : city
      city = JSON.parse(city)
      new(id: city['id'], lat: city['coord']['lat'], lon: city['coord']['lon'],
          temp_k: city['main']['temp'], name: city['name'])
    end

    def nearby(count = 5)
      current_weather = (Faraday.get 'https://api.openweathermap.org/data/2.5/find',
                                     { lat: lat,
                                       lon: lon,
                                       cnt: count,
                                       appid: 'd5573e972de12da9e572b97e1cd2ad98' }
                        ).body
      JSON.parse(current_weather)['list'].collect { |city| OpenWeatherMap::City.parse(city) }
    end

    def coldest_nearby(count = 5)
      nearby(count).min
    end
  end
end
