#install required package
	#ssc install egenmore
	
#download data from https://github.com/owid/covid-19-data/blob/master/public/data/archived/ecdc/full_data.csv
	import delimited "/Users/huongvu/Documents/STATA/COVID-19 data/full_data.csv", clear

#drop unnecessary variables
	local key_vars total_cases total_deaths
	keep location date `key_vars'
	drop if location == "World"
	drop if location == "Africa"
	drop if location == "Asia"
	drop if location == "Europe"
	drop if location == "European Union"
	drop if location == "High income"
	drop if location == "International"
	drop if location == "Low income"
	drop if location == "Lower middle income"
	drop if location == "Upper middle income"
	drop if location == "North America"
	drop if location == "South Africa"
	drop if location == "South America"

#destring date variable
	gen year = substr(date,1,4)
	gen month = substr(date,6,2)
	gen day = substr(date,9,2)
	destring year month day, replace
	gen destring_date = mdy(month, day, year)
	format destring_date %td
	drop date year month day
	rename destring_date date
	
#create total cases and deaths for each day
	foreach var in `key_vars' {
		bys date: egen `var'_world = total(`var')
		#local final_vars `final_vars' `vars'_world
	}
	
#another way to calculate total cases and deaths for each day - not using macro
	bysort date: egen total_cases_world=total(total_cases)
	bysort date: egen total_deaths_world=total(total_deaths)
	
line total_cases_world total_deaths_world date
	
