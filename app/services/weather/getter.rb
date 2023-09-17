require 'net/http'

class Weather::Getter < ApplicationService
  def call
    @lat, @lon = get_coords_by_zip_code
    get_weather_by_coords
  end

  def initialize(zip_code:, country_code:)
    @zip_code = zip_code
    @country_code = country_code
  end

  private
  
  attr_reader :zip_code, :country_code

  def get_coords_by_zip_code
    url = URI.parse("#{ENV.fetch('OPEN_WEATHER_MAP_BASE_URL', nil)}#{coords_params}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    body = JSON.parse(res.body)

    return body["lat"], body["lon"]
  end

  def get_weather_by_coords
    url = URI.parse("#{ENV.fetch('OPEN_WEATHER_DATA_BASE_URL', nil)}#{weather_params}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }

    JSON.parse(res.body)
  end

  def coords_params
    "?zip=#{zip_code},#{country_code}&appid=#{api_key}"
  end

  def weather_params
    "?lat=#{@lat}&lon=#{@lon}&units=metric&appid=#{api_key}"
  end

  def api_key
    ENV.fetch('OPEN_WEATHER_API_KEY', nil)
  end
end
