require 'net/http'

class Weather::Getter < ApplicationService
  include HTTPHelper

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
    body = get("#{ENV.fetch('OPEN_WEATHER_MAP_BASE_URL', nil)}#{coords_params}")

    return body["lat"], body["lon"]
  end

  def get_weather_by_coords
    get("#{ENV.fetch('OPEN_WEATHER_DATA_BASE_URL', nil)}#{weather_params}")
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
