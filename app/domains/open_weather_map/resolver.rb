module OpenWeatherMap
  module Resolver
    def self.city_id(city_name)
      cities.find { |city| city['name'] == city_name }.to_h['id']
    end

    def self.cities
      @cities ||= JSON.parse(File.read(File.expand_path('city_ids.json', __dir__)))
    end
  end
end
