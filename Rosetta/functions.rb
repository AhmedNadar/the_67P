require 'readline'
require 'date'
# ask the user to provide start and end date
def query_user_for_date_range
  start_date, end_date = nil

  puts "\nFirst, we need a start date:"
  start_date = query_user_for_date

  puts "\nNext, we need an end date:"
  end_date = query_user_for_date

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
  end
  return date
end