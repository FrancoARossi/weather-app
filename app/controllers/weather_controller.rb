class WeatherController < ApplicationController
  def current_weather
    weather_data = Weather::Getter.call(zip_code: params[:zip_code], country_code: params[:country_code].upcase)

    respond_to do |format|
      format.html { render partial: 'weather/current_weather', locals: { weather_data: weather_data } }
    end
  end
end
