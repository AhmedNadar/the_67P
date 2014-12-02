#!/usr/bin/env ruby

require_relative('functions')

puts "\n*** LAKE PEND OREILLE READINGS *** "
puts "Calculates the means and median of the wind speed, air trmpeature,"
puts "and barometric pressure recorded at the Deep Moor station"
puts "on Lake Pend Oreille for a given range of dates."

start_date, end_date = query_user_for_date_range

puts start_date.strftime('%B %d, %Y')
puts end_date.strftime('%B %d, %Y')