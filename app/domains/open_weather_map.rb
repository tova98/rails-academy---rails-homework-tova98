module OpenWeatherMap
  BASE_URL = 'https://api.openweathermap.org/data/2.5'
  API_KEY = Rails.application.credentials.open_weather_map_api_key
  def self.city(city_name)
    city_id = Resolver.city_id(city_name)
    return nil if city_id.nil?

    current_weather = (Faraday.get "#{BASE_URL}/weather",
                                   { id: city_id,
                                     appid: API_KEY }
                      ).body
    City.parse(JSON.parse(current_weather))
  end

  def self.cities(city_names)
    city_ids = city_names.map { |city_name| Resolver.city_id(city_name) }.compact.join(',')
    return nil if city_ids.empty?

    multi_city_weather = (Faraday.get "#{BASE_URL}/group",
                                      { id: city_ids,
                                        appid: API_KEY }
                         ).body
    JSON.parse(multi_city_weather)['list'].map { |city| City.parse(city) }
  end
end
