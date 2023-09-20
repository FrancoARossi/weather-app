class HomeController < ApplicationController
  def index
    if valid_params?
      @weather_data = Weather::Getter.call(zip_code: params[:zip_code], country_code: params[:country_code].upcase)
    end
  end

  def valid_params?
    params[:zip_code].present? && params[:country_code].present?
  end
end
