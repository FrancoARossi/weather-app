class HomeController < ApplicationController
  def index
    if valid_params?
      @weather_data = Weather::Getter.call(zip_code: zip_code, country_code: country_code)
    end
  end

  def valid_params?
    zip_code.present? && country_code.present?
  end

  private

  def zip_code
    params[:zip_code]
  end

  def country_code
    params[:country_code].upcase
  end
end
