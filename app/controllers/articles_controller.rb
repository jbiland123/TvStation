require 'net/http'
require 'csv'
require 'icalendar'
require 'open-uri'
require 'nokogiri'

class ArticlesController < ApplicationController
  helper_method :truncate_title

  def index
    url = 'https://api.openweathermap.org/data/2.5/weather?lat=47.496658463630894&lon=7.7210972814041545&units=metric&appid=2cd6c916e89c89f156c3ee6332d5bd03&lang=de'
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    @data = JSON.parse(res.body)

    url1 = 'https://api.openweathermap.org/data/2.5/forecast?lat=47.496658463630894&lon=7.7210972814041545&units=metric&appid=2cd6c916e89c89f156c3ee6332d5bd03&lang=de'
    uri1 = URI(url1)
    res1 = Net::HTTP.get_response(uri1)
    @data1 = JSON.parse(res1.body)

    @temperatures = @data1["list"][0..4].map { |interval| interval["main"]["temp"] }
    @times_formatted = @data1["list"][0..4].map do |interval|
      parsed_time = DateTime.parse(interval["dt_txt"])
      formatted_time = parsed_time.strftime('%H:%M')
      formatted_time
    end

    daily_temperatures = {}

    @data1["list"].each do |interval|
      date = interval["dt_txt"].split[0]
      min_temp = interval["main"]["temp_min"]
      max_temp = interval["main"]["temp_max"]

      if daily_temperatures[date]
        daily_temperatures[date][:min] = [daily_temperatures[date][:min], min_temp].min
        daily_temperatures[date][:max] = [daily_temperatures[date][:max], max_temp].max
      else
        daily_temperatures[date] = { min: min_temp, max: max_temp }
      end
    end

    @daily_temperatures = daily_temperatures

    daily_weather_icons = {}

    @data1["list"].each do |interval|
      time = interval["dt_txt"].split[1]
      date = interval["dt_txt"].split[0]

      if time == "12:00:00"
        weather_icon = interval["weather"][0]["icon"]
        daily_weather_icons[date] = weather_icon
      end
    end

    @daily_weather_icons = daily_weather_icons


    url3 = 'https://newsapi.org/v2/top-headlines?country=ch&apiKey=5198179471974a11ba335b68f308f387'
    uri3 = URI(url3)
    res3 = Net::HTTP.get_response(uri3)
    @data3 = JSON.parse(res3.body)

    @news = @data3["articles"]

    @i_news = @news.select { |item| item["author"] == "SRF News" or item["author"] == "blue News" or item["author"] == "Polizei Basel-Landschaft" or item["author"] == "Tages-Anzeiger" or item["author"] == "BLICK"}

    file_path = Rails.public_path.join('sitzungszimmer310.txt')
    calendar_file = File.read(file_path)
    calendar = Icalendar::Calendar.parse(calendar_file).first
    
    @events = calendar.events.select { |event| event.dtend >= DateTime.now }
    
    @location = @events.first.location

    file_path2 = Rails.public_path.join('schulungsraum1.txt')
    calendar_file2 = File.read(file_path2)
    calendar2 = Icalendar::Calendar.parse(calendar_file2).first
    
    @events2 = calendar2.events.select { |event2| event2.dtend >= DateTime.now }
    
    @location2 = @events2.first.location

    def truncate_title(title, author)
      truncated_title = title.strip
      truncated_title.gsub!(author, '')
      truncated_title.gsub!(/— Baselland\.ch/i, '')
      truncated_title.gsub!(/-\s*\z/, '')
      truncated_title.strip
    end
  end
end
