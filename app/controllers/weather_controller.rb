class WeatherController < ApplicationController
  def get_current_weather
    @weather = Weather::GetCurrent.run(zip_code: params[:zip_code])

    render json: @weather
  end
end
