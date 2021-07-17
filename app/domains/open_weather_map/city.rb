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
      new(id: city['id'], lat: city['coord']['lat'], lon: city['coord']['lon'],
          temp_k: city['main']['temp'], name: city['name'])
    end

    def nearby(count = 5)
      current_weather = (Faraday.get "#{BASE_URL}/find",
                                     { lat: lat,
                                       lon: lon,
                                       cnt: count,
                                       appid: Rails.application.credentials.open_weather_map_api_key } # rubocop:disable Layout/LineLength
                        ).body
      JSON.parse(current_weather)['list'].map { |city| OpenWeatherMap::City.parse(city) }
    end

    def coldest_nearby(count = 5)
      args = [count]
      nearby(*args).min
    end
  end
end
