#!/usr/bin/ruby

require 'rubygems'
require 'csv'
require 'date'
require 'hsluv'
require 'json'

ehcm = 20037580.0 # Earth half-circumference in meters

def calc_geo_distance(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[:lat]-loc1[:lat]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[:lng]-loc1[:lng]) * rad_per_deg

    lat1_rad = loc1[:lat] * rad_per_deg
    lng1_rad = loc1[:lng] * rad_per_deg
    lat2_rad = loc2[:lat] * rad_per_deg
    lng2_rad = loc2[:lng] * rad_per_deg

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
end

def calc_time_distance(a, b)
    [(a.yday - b.yday).abs, 365-((a.yday - b.yday).abs)].min
end

basic_data = CSV.read "basic_con_data.csv"
organized_data = Array.new
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
    curr_organizer[:color] = Hsluv.hsluv_to_hex(hue, 100, 65)
    curr_organizer[:fclr] = (curr_con[6].to_i == 1)
    curr_organizer[:host_population] = curr_con[8].to_i
    curr_organizer[:gimmick] = (curr_con[9].to_i == 1)
    organized_data << curr_organizer
end

organized_data.sort! { |a, b| -a[:attendance] <=> -b[:attendance] }

geo_distance_matrix = Hash.new { |hash, key| hash[key] = Hash.new { |hash, key| hash[key] = 0 } }
time_distance_matrix = Hash.new { |hash, key| hash[key] = Hash.new { |hash, key| hash[key] = 0 } }
number_cons = organized_data.count
(0..number_cons-1).each do |i|
    (0..i-1).each do |j|
        geo = calc_geo_distance(organized_data[i][:location], organized_data[j][:location])
        time = calc_time_distance(Date.strptime(organized_data[i][:date], "%d %b %Y"), Date.strptime(organized_data[j][:date], "%d %b %Y"))
        if organized_data[i][:attendance] > 0 and organized_data[j][:attendance] > 0 and i != j
            geo_distance_matrix[i][j]  = (geo + 1000.0) / (ehcm + 1000.0) * organized_data[i][:attendance] / organized_data[j][:attendance]
            geo_distance_matrix[j][i]  = (geo + 1000.0) / (ehcm + 1000.0) * organized_data[j][:attendance] / organized_data[i][:attendance]
            time_distance_matrix[i][j] = (time + 1.0)   / (182.0 + 1.0)
            time_distance_matrix[j][i] = (time + 1.0)   / (182.0 + 1.0)
        else
            geo_distance_matrix[i][j] = 0
            geo_distance_matrix[j][i] = 0
            time_distance_matrix[i][j] = 0
            time_distance_matrix[j][i] = 0
        end
    end
end

(0..number_cons-1).each do |i|
    geos = (0..number_cons-1).collect{|j| geo_distance_matrix[i][j]}
    times = (0..number_cons-1).collect{|j| time_distance_matrix[i][j]}

    geos.delete 0
    times.delete 0

    s = geos.zip(times).collect{ |x| 1.0 / (x[0] * x[1]) }.reduce(0, :+)
    pop = organized_data[i][:host_population] * (organized_data[i][:gimmick] ? 10000 : 1)

    organized_data[i][:surprise_index] = s * organized_data[i][:attendance] / pop
end

File.open("map_data.json", "w") do |fout|
   fout.syswrite JSON.pretty_generate(organized_data)
end
