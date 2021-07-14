require 'json'

module OpenWeatherMap
  module Resolver
    def self.city_id(city_name)
      file_string = File.read(File.expand_path('city_ids.json', __dir__))
      cities = JSON.parse(file_string)
      city = cities.find { |city| city['name'] == city_name }
      city.to_h['id']
    end
  end
end
