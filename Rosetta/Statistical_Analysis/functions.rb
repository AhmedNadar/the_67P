require 'readline'
require 'date'

# Earliest date for consistent data
DATA_START_DATE ='2006-09-20'

# Max number of days to retrive data, be kind to remote server
MAX_DAYS = 7

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