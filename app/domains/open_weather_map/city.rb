require 'json'

module OpenWeatherMap
  class City
    attr_reader :id, :lat, :lon, :name

    def initialize(id, lat, lon, temp_k, name)
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
      new(city['id'], city['coord']['lat'], city['coord']['lon'],
          city['main']['temp'], city['name'])
    end
  end
end
