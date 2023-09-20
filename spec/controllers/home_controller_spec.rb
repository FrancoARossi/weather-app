require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #index' do
    before { get :index }

    it 'is successful' do
      expect(subject.send(:valid_params?)).to be_falsy
      expect(response).to be_successful
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #index with valid params' do
    before do
      allow(Weather::Getter).to receive(:call).with(zip_code: '12345', country_code: 'US').and_return({
        city: "Schenectady",
        weather: "Clear",
        temp: 13.06,
        feels_like: 12.59,
        humidity: 83,
        wind_speed: 3.09,
      })
      get :index, params: { zip_code: '12345', country_code: 'US' }
    end

    it 'is successful' do
      expect(subject.send(:valid_params?)).to be_truthy
      expect(response).to be_successful
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #index with invalid params' do
    before { get :index, params: { zip_code: '', country_code: '' } }

    it 'is successful' do
      expect(subject.send(:valid_params?)).to be_falsy
      expect(response).to be_successful
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end
end
