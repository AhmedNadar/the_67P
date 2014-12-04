require 'readline'
require 'date'
require 'open-uri'


# Earliest date for consistent data
DATA_START_DATE ='2006-09-20'

# Max number of days to retrive data, be kind to remote server
MAX_DAYS = 7


# Reading types as a hash. Eash key is the name by the remote server as "Wind_Speed"
# And each value is a plain text for that datq
READING_TYPES ={
  Air_Temp: "Air Temp",
  Barometric_Press: "Pressure",
  Wind_Speed: "Wind Speed"
}

### user Input ###

# ask the user to provide start and end date
def query_user_for_date_range
  start_date, end_date = nil

  # untill we have both dates
  until start_date && end_date
    puts "\nFirst, we need a start date:"
    start_date = query_user_for_date

    puts "\nNext, we need an end date:"
    end_date = query_user_for_date

    if !date_range_valid?(start_date, end_date)
      puts "Let's start again!"
      start_date = end_date = nil
    end
  end
  return start_date, end_date # retunr both values as an array
end

# ask the user for a valid date. We use same method for btoth start and end dates.
def query_user_for_date
  date = nil
  until date.is_a? Date # make sure date is a Date object
    prompt = "Please enter a date as YYYY-MM-DD: "
    response = Readline.readline(prompt, true)

    # give the user option to quit any time
    exit if ['exit', 'q', 'x', 'quit'].include?(response)

    # parse user response to Date object or throw an error when input is wrong
    begin
      date = Date.parse(response)
    rescue ArgumentError
      puts "\nInvalid date format."
    end
    # set the date to nothing unless the date is valid
    date = nil unless date_valid?(date)
  end
  return date
end

# validation for single date either start or end date
# that date should be in a range between start date and today
def date_valid?(date)
  valid_dates = Date.parse(DATA_START_DATE)..Date.today
  if valid_dates.cover?(date)
    return true
  else
    puts "\nDate must be after #{DATA_START_DATE} and before today."
    return false
  end
end

def date_range_valid?(start_date, end_date)
  if start_date > end_date
    puts "\n Start date mush be before end date"
    return false
  elsif start_date + MAX_DAYS < end_date
     puts "\nNo more that #{MAX_DAYS} days. Be kind to the remote server."
    return false
  end
  return true
end

### Retrive Remote Data ###

# Retrives reading for specific reading type as "Wind_Speed", for a range of dates, form
# the remote server as an array of floating point valuse

def get_readings_from_remote_server_for_dates(type, start_date, end_date)
  readings = []
  start_date.upto(end_date) do |date|
    readings += get_readings_from_remote(type, date)
  end
  return readings
end

# Retrieves readings for a particular reading type for a particular date from the remote
# server as an array of floating points values

def get_readings_from_remote(type, date)
  raise "Invalid Reading Type" unless READING_TYPES.keys.include?(type)

  # read the remote file, splite reading into an array
  # http://lpo.dt.navy.mil/data/DM/2012/2012_01_01/Wind_Speed <=> the end result
  base_url = "http://lpo.dt.navy.mil/data/DM"
  url = "#{base_url}/#{date.year}/#{date.strftime("%Y_%m_%d")}/#{type}"
  puts "Retriving: #{url}"
  data = open(url).readlines # ruby reads lines

  # Extract the reading from each line
  # "2014_02_22 00:23:45 4.7\r\n" becomes 4.7
  readings = data.map do |line| # loop through each line
    line_times = line.chomp.split(" ") # chomp and split each line
    reading = line_times[2].to_f # convert each line to float
  end
  return readings
end

### Data Calculations ###
# calculate the mean (average) on an array of numbers
def mean(array)
  total = array.inject(0) {|sum, x| sum += x}
  # user to_f to avoid get integer result
  return total.to_f / array.length
end

# calculate the median (middle) of an array of number
def median(array)
  array.sort!
  length = array.length
  if length % 2 == 1
    # odd length, return the middle number
    return array[length / 2]
  else
    # even number, average the two middle numbers
    item1 = array[length / 2 - 1]
    item2 = array[length / 2]
    return mean([item1, item2])
  end
end

def retrieve_and_calculate_results(start_date, end_date)
  results = {}
  READING_TYPES.each do |type, label|
    readings = get_readings_from_remote_server_for_dates(type, start_date, end_date)
    results[label] = {
      mean: mean(readings),
      median: median(readings)
    }
  end
  return results
end
