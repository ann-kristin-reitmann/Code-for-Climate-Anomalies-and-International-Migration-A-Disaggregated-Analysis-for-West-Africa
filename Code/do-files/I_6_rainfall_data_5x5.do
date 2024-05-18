
*-------------------------------------------------------------------------------------------
* 6. Data prep do-file: rainfall data
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file imports rainfall data

*-------------------------------------------------------------------------------
* I. Import rainfall data 
*-------------------------------------------------------------------------------

import delimited "data/_orig/africa_grid5x5.csv", clear 

replace temperature_c_2m_mean="" if temperature_c_2m_mean=="NA"
replace total_precipitation_mm_sum=. if total_precipitation_mm_mean=="NA"
replace total_precipitation_mm_mean="" if total_precipitation_mm_mean=="NA"

destring *, replace 

gen date = date(month, "YMD")
format date %td

gen myear = mofd(date)
format myear %tm

drop month 
rename id _ID

save "data/temp_precipitation_2016_2020.dta", replace 

*-------------------------------------------------------------------------------
* II. Merge with migration data
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear


merge 1:1 _ID myear using "data/temp_precipitation_2016_2020.dta" 
*keep if _merge==3

gen lntemp=ln(temperature_c_2m_mean)
gen lnprec=ln(total_precipitation_mm_mean) 

*-------------------------------------------------------------------------------
* III. Save data
*-------------------------------------------------------------------------------

save "data/final_cell_5by5_month_sample_rain.dta", replace 

