require 'faraday'

module OpenWeatherMap
  def self.city(city_name)
    city_id = Resolver.city_id(city_name)
    return nil if city_id.nil?

    current_weather = (Faraday.get 'https://api.openweathermap.org/data/2.5/weather',
                                   { id: city_id,
                                     appid: 'd5573e972de12da9e572b97e1cd2ad98' }
                      ).body
    City.parse(current_weather)
  end

  def self.cities(city_names)
    city_ids = city_names.collect { |city_name| Resolver.city_id(city_name) }.compact.join(',')
    return nil if city_ids.empty?

    multi_city_weather = (Faraday.get 'https://api.openweathermap.org/data/2.5/group',
                                      { id: city_ids,
                                        appid: 'd5573e972de12da9e572b97e1cd2ad98' }
                         ).body
    JSON.parse(multi_city_weather)['list'].map { |city| City.parse(city) }
  end
end

OpenWeatherMap.city('')
