#1. download dataset from https://data.worldbank.org/indicator/SI.POV.DDAY?locations=1W

#2. import dataset
	import delimited "/Users/huongvu/Documents/STATA/API_SI.POV.DDAY_DS2_en_csv_v2_4354616/API_SI.POV.DDAY_DS2_en_csv_v2_4354616.csv"

#3. drop unimportant variables
	drop v3 v4

#4. rename variables
	rename v1 country_name
	rename v2 country_code

#5. create a loop to rename variable names
	forvalues x = 5 / 67 {
		local year = 1955 + `x'
		rename v`x' poverty_rate`year'
	}

#6. drop the first three lines in the dataset
	drop if _n < 4

#7. reshape the data from wide to long format
	reshape long poverty_rate, i(country_name) j(year)

#8. reorder the variables
	order country_code, after(country_name)

#9. drop missing observations
	drop if missing(poverty_rate)

#10. label variable
	label variable poverty_rate "Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population)" 

#11. save 
	save poverty_rate, replace
