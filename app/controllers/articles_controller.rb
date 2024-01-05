require 'net/http'
require 'csv'
require 'icalendar'
require 'open-uri'
require 'nokogiri'
require 'feedjira'
require 'httparty'

class ArticlesController < ApplicationController
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
    
    # Assuming your existing code to fetch and parse the RSS feed
    rss_feed_url = 'https://www.srf.ch/news/bnf/rss/1646'
    rss_feed_response = HTTParty.get(rss_feed_url)

    if rss_feed_response.success?
      rss_data = Nokogiri::XML(rss_feed_response.body)

      @rss_news = rss_data.css('item').map do |item|
        # Parse the description as HTML
        description_html = Nokogiri::HTML.fragment(item.css('description').text)

        # Extract the image source
        image_src = description_html.at_css('img')['src'] if description_html.at_css('img')

        {
          title: item.css('title').text,
          link: item.css('link').text,
          description: item.css('description').text,
          image_src: image_src,
          pub_date: DateTime.parse(item.css('pubDate').text)
        }
      end
    else
      @rss_news = []
    end

    
    # url3 = 'https://newsapi.org/v2/top-headlines?country=ch&apiKey=5198179471974a11ba335b68f308f387'
    # uri3 = URI(url3)
    # res3 = Net::HTTP.get_response(uri3)
    # @data3 = JSON.parse(res3.body)

    # @news = @data3["articles"]

    # @i_news = @news.select { |item| item["author"] == "SRF News" || item["author"] == "blue News" || item["author"] == "Polizei Basel-Landschaft" || item["author"] == "Tages-Anzeiger" || item["author"] == "BLICK" }

    # Fetch and parse calendar data from testraum.txt
    file_path_meetingroom = Rails.public_path.join('meetingroom.txt')
    calendar_file_meetingroom = File.read(file_path_meetingroom)
    @events_meetingroom = parse_calendar_data(calendar_file_meetingroom)

    # Fetch and parse calendar data from testraum.txt
    file_path_schoolroom = Rails.public_path.join('schoolroom.txt')
    calendar_file_schoolroom = File.read(file_path_schoolroom)
    @events_schoolroom = parse_calendar_data(calendar_file_schoolroom)
  end

  private

  # Method to parse calendar data
  def parse_calendar_data(data)
    events = []
  
    data.each_line do |line|
      match_data = line.match(/Subject: (.+) - Start: (.+) - End: (.+)/)
  
      if match_data
        subject_info = match_data[1].strip
        # Extrahiere den gewünschten Teil des Subjects und füge es zum Hash hinzu
        subject_parts = subject_info.split('ZI')
        subject = subject_parts.length > 1 ? subject_parts[1].strip : subject_info
        # Begrenze auf 40 Zeichen mit "..." am Ende
        subject = truncate_subject(subject)

        event = {
          summary: subject,
          dtstart: DateTime.parse(match_data[2]),
          dtend: DateTime.parse(match_data[3])
        }
        events << event
      end
    end

    events
  end

  def truncate_subject(subject)
    if subject.length > 45
      subject = subject[0..45] + '...'
    end
    subject
  end
end
