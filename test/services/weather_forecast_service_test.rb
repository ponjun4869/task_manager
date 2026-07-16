require "test_helper"
require "minitest/mock"

class WeatherForecastServiceTest < ActiveSupport::TestCase
  test "指定した日付の天気予報を返す" do
    response = success_response(
      "daily" => {
        "time" => ["2026-07-13"],
        "weather_code" => [55],
        "temperature_2m_max" => [27.4],
        "temperature_2m_min" => [23.8]
      }
    )

    Net::HTTP.stub(:get_response, response) do
      forecast = WeatherForecastService.fetch_for_date(Date.new(2026, 7, 13))

      assert_equal "霧雨", forecast[:weather_description]
      assert_equal 27.4, forecast[:maximum_temperature]
      assert_equal 23.8, forecast[:minimum_temperature]
    end
  end

  test "予報期間外の日付にはnilを返す" do
    response = success_response(
      "daily" => {
        "time" => ["2026-07-13"],
        "weather_code" => [0],
        "temperature_2m_max" => [30.0],
        "temperature_2m_min" => [24.0]
      }
    )

    Net::HTTP.stub(:get_response, response) do
      assert_nil WeatherForecastService.fetch_for_date(Date.new(2030, 1, 1))
    end
  end

  test "APIが失敗した場合は専用の例外を発生させる" do
    response = Net::HTTPInternalServerError.new("1.1", "500", "Internal Server Error")

    Net::HTTP.stub(:get_response, response) do
      assert_raises(WeatherForecastService::Error) do
        WeatherForecastService.fetch
      end
    end
  end

  private

  def success_response(body)
    response = Net::HTTPOK.new("1.1", "200", "OK")
    response.instance_variable_set(:@body, JSON.generate(body))
    response.instance_variable_set(:@read, true)
    response
  end
end
