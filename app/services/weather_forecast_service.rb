require "net/http"
require "json"

class WeatherForecastService
  class Error < StandardError; end

  API_URL = "https://api.open-meteo.com/v1/forecast"
  TOKYO_LATITUDE = 35.6762
  TOKYO_LONGITUDE = 139.6503

  def self.fetch
    uri = URI(API_URL)
    uri.query = URI.encode_www_form(
      latitude: TOKYO_LATITUDE,
      longitude: TOKYO_LONGITUDE,
      daily: "weather_code,temperature_2m_max,temperature_2m_min",
      timezone: "Asia/Tokyo"
    )

    response = Net::HTTP.get_response(uri)

    raise Error, "天気予報の取得に失敗しました" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue JSON::ParserError, SocketError, Timeout::Error, Errno::ECONNREFUSED => e
    raise Error, "天気予報の取得に失敗しました: #{e.message}"
  end

  def self.fetch_for_date(date)
    daily = fetch["daily"]
    index = daily["time"].index(date.to_s)

    return nil unless index

    {
      date: daily["time"][index],
      weather_code: daily["weather_code"][index],
      weather_description: weather_description(daily["weather_code"][index]),
      maximum_temperature: daily["temperature_2m_max"][index],
      minimum_temperature: daily["temperature_2m_min"][index]
    }
  end

  def self.weather_description(code)
    case code
    when 0 then "快晴"
    when 1 then "晴れ"
    when 2 then "一部曇り"
    when 3 then "曇り"
    when 45, 48 then "霧"
    when 51, 53, 55, 56, 57 then "霧雨"
    when 61, 63, 65, 66, 67 then "雨"
    when 71, 73, 75, 77 then "雪"
    when 80, 81, 82 then "にわか雨"
    when 85, 86 then "にわか雪"
    when 95, 96, 99 then "雷雨"
    else "不明"
    end
  end
end
