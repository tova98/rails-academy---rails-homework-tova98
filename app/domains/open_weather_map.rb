require 'faraday'
require './open_weather_map/resolver'
require './open_weather_map/city'

module OpenWeatherMap
  include OpenWeatherMap::Resolver
  def self.city(city_name)
    city_id = Resolver.city_id(city_name)
    city_id.nil? ? return : city_id

    current_weather = (Faraday.get 'https://api.openweathermap.org/data/2.5/weather',
                                   { id: city_id,
                                     appid: 'd5573e972de12da9e572b97e1cd2ad98' }
                      ).body
    OpenWeatherMap::City.parse(current_weather)
  end
end
