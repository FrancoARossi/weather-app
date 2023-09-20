require 'net/http'

class Weather::Getter < ApplicationService
  include HttpHelper

  def call
    @lat, @lon = get_coords_by_zip_code
    get_weather_by_coords
  end

  def initialize(zip_code:, country_code:)
    @zip_code = zip_code
    @country_code = country_code
  end

  private
  
  attr_reader :zip_code, :country_code, :lat, :lon

  def get_coords_by_zip_code
    body = get(coords_url)

    return body["lat"], body["lon"]
  end

  def get_weather_by_coords
    res = get(weather_url)

    result(res)
  end

  def result(response)
    {
      city: response["name"],
      weather: response["weather"].first["main"],
      temp: response["main"]["temp"],
      feels_like: response["main"]["feels_like"],
      humidity: response["main"]["humidity"],
      wind_speed: response["wind"]["speed"],
    }
  end

  def coords_url
    "#{ENV.fetch('OPEN_WEATHER_MAP_BASE_URL', nil)}?zip=#{zip_code},#{country_code}&appid=#{api_key}"
  end

  def weather_url
    "#{ENV.fetch('OPEN_WEATHER_DATA_BASE_URL', nil)}?lat=#{lat}&lon=#{lon}&units=metric&appid=#{api_key}"
  end

  def api_key
    ENV.fetch('OPEN_WEATHER_API_KEY', nil)
  end
end
