require 'rubygems'
require 'csv'
require 'date'
require 'chroma'
require 'json'

basic_data = CSV.read "basic_con_data.csv"
organized_data = Hash.new { |hash, key| hash[key] = Hash.new { |hash, key| hash[key] = 0 } }
basic_data[1..-1].each do |curr_con|
	organized_data[curr_con[0]][:location] = Hash.new
	organized_data[curr_con[0]][:location][:lat] = curr_con[2].to_f
	organized_data[curr_con[0]][:location][:lng] = curr_con[3].to_f
	organized_data[curr_con[0]][:attendance] = curr_con[4].to_i
	exact_date = Date.strptime(curr_con[5], "%m/%d/%Y")
	hue = exact_date.yday / 365.0 * 360.0
	organized_data[curr_con[0]][:date] = exact_date.strftime "%d %b %Y"
	organized_data[curr_con[0]][:color] = "hsv(#{hue}, 1, 1)".paint.to_hex
	organized_data[curr_con[0]][:fclr] = (curr_con[6].to_i == 1)
end

File.open("map_data.json", "w") do |fout|
   fout.syswrite JSON.pretty_generate(organized_data)
end
