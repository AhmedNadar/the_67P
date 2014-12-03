## Lake Readings

#### LAKE PEND OREILLE READINGS

Calculates the means and median of the wind speed, air temperature, and barometric pressure recorded at the Deep Moor station on [Lake Pend Oreille](http://lpo.dt.navy.mil ) for a given range of dates.

### Methods

* **Readline** Reads one inputted line with line edit by *readline* method.
* **readline(.. , ..)** Method accepts 2 parameters. (prompt = "", add_hist = false) → string or nil
  Shows the prompt and reads the inputted line with line editing. The inputted line is added to the history if add_hist is true.
* **is_a** Returns true if class is the class of obj, or if class is one of the superclasses of obj or modules included in obj.

	`date.is_a? Date #=> true` if `date` is a class of `Date`

* **cover?(obj)**  Return true or false
Returns true if obj is between the begin and end of the range.

```
	("a".."z").cover?("c")    #=> true
	("a".."z").cover?("5")    #=> false
	("a".."z").cover?("cc")   #=> true
	if valid_dates.cover?(date) end #=> [true, false]
```

**parse(...)** (string='-4712-01-01'[, comp=true[, start=ITALY]])
  Parses the given representation of date and time, and creates a date object.

If the optional second argument is true and the detected year is in the range “00” to “99”, cons    iders the year a 2-digit form and makes it full.

```
	valid_dates = Date.parse(DATA_START_DATE) #=> '2006-09-20'
	Date.parse('2001-02-03')          #=> #<Date: 2001-02-03 ...
	Date.parse('20010203')            #=> #<Date: 2001-02-03 ...>
	Date.parse('3rd Feb 2001')        #=> #<Date: 2001-02-03 ...>
```