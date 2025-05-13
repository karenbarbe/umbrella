require "http"
require "json"
require "dotenv/load"

pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_api_key = ENV.fetch("GMAPS_KEY")

puts "Hello! Where are you located?"
user_location = gets.chomp

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_api_key}"

gmaps_response = HTTP.get(gmaps_url)
parsed_gmaps_response = JSON.parse(gmaps_response)

gmaps_results = parsed_gmaps_response.fetch("results")
geometry = gmaps_results.at(0).fetch("geometry")
location = geometry.fetch("location")

latitude = location.fetch("lat")
longitude = location.fetch("lng")

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{latitude},#{longitude}?&units=ca"

weather_response = HTTP.get(pirate_weather_url)
parsed_weather_response = JSON.parse(weather_response)


currently = parsed_weather_response.fetch("currently")
current_temp = currently.fetch("temperature")
next_hour = parsed_weather_response.fetch("hourly")["data"].at(0)
next_hour_summary = next_hour["summary"]

puts "\n"
puts "The current temperature in #{user_location} is #{current_temp.to_s}°C"
puts "Next hour: It will be #{next_hour_summary.downcase}"
