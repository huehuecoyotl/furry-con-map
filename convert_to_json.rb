require 'rubygems'
require 'csv'
require 'date'
require 'chroma'
require 'json'

basic_data = CSV.read "basic_con_data.csv"
organized_data = Array.new { |hash, key| hash[key] = Hash.new { |hash, key| hash[key] = 0 } }
basic_data[1..-1].each do |curr_con|
	curr_organizer = Hash.new { |hash, key| hash[key] = 0 }
	curr_organizer[:name] = curr_con[0]
	curr_organizer[:location] = Hash.new { |hash, key| hash[key] = 0 }
	curr_organizer[:location][:lat] = curr_con[2].to_f
	curr_organizer[:location][:lng] = curr_con[3].to_f
	curr_organizer[:attendance] = curr_con[4].to_i
	exact_date = Date.strptime(curr_con[5], "%m/%d/%Y")
	hue = exact_date.yday / 365.0 * 360.0
	curr_organizer[:date] = exact_date.strftime "%d %b %Y"
	curr_organizer[:color] = "hsv(#{hue}, 1, 1)".paint.to_hex
	curr_organizer[:fclr] = (curr_con[6].to_i == 1)
	organized_data << curr_organizer
end

organized_data.sort { |a,b| a[:attendance] <=> b[:attendance] }

File.open("map_data.json", "w") do |fout|
   fout.syswrite JSON.pretty_generate(organized_data)
end
