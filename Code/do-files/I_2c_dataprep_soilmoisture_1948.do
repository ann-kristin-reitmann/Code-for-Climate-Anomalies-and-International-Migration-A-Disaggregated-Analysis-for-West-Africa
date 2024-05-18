
*-------------------------------------------------------------------------------------------
* 2c. Data prep do-file: soil moisture data 
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file prepares the soil moisture data for calculating the SMA
*Note: This data is for creating Figure 1, where we need the SMA calculated back to 1948

*-------------------------------------------------------------------------------------------
* I. Import soil moisture data 
*-------------------------------------------------------------------------------------------

/*

*Define locals 

local 1by1 data/Rdata/moisture_cells  // big cells (33,084 cells)
local 5by5 data/Rdata/.5x.5/moisture_cells // small cells (127,488)

*Import data, format, and save as .dta 

foreach path in `1by1' `5by5' {

import delimited "`path'.csv" , clear

capture noisily rename id cellid 
capture noisily drop v1 
capture noisily duplicates drop 

reshape long x, i(cellid) j(date)
rename x soil
replace soil="" if soil=="NA"

tostring date, replace 

gen year=substr(date,-8,4) 
gen month=substr(date,-4,2)

drop date

destring *, replace 

sort cellid month year 
gen ymonth=ym(year, month)
format ymonth %tm 

save "`path'.dta", replace
}

local 1by1 data/Rdata/field_wilt_cells  // big cells (33,084 cells)
local 5by5 data/Rdata/.5x.5/field_wilt_cells // small cells (127,488)

foreach path in `1by1' `5by5' {

import delimited "`path'.csv", clear
drop v1
capture noisily rename id cellid 

replace fieldcapraster="" if fieldcapraster=="NA"
replace wiltpontraster="" if wiltpontraster=="NA"

destring *, replace 
duplicates drop 
save "`path'.dta", replace

}

*/

*-------------------------------------------------------------------------------------------
* II. Generate std. measure for the long run 
*-------------------------------------------------------------------------------------------

*Merge moisture and field wilt 

use "data/Rdata/moisture_cells_country.dta", clear 

merge m:1 cellid using "data/Rdata/field_wilt_cells_country.dta"
drop _merge 

save "data/country.dta", replace

use "data/Rdata/moisture_cells.dta", clear 
drop latitude* longitude*

merge m:1 cellid using "data/Rdata/field_wilt_cells.dta"
drop _merge 

save "data/monthly.dta", replace

*Merge moisture and field wilt 5x5

use "data/Rdata/.5x.5/moisture_cells.dta", clear 

drop left top right bottom admin 

merge m:1 cellid using "data/Rdata/.5x.5/field_wilt_cells.dta"
drop _merge 

save "data/monthly_5x5.dta", replace

*-------------------------------------------------------------------------------------------
* III. Build soil moisture index and save data
*-------------------------------------------------------------------------------------------

*** Build soil moisture index ***

foreach data in country monthly monthly_5x5 { 

use "data/`data'.dta"

*Generate mean of field capacity and wilt point 

gen avfieldwilt=(fieldcapraster+wiltpontraster)/2

*Calculate Soil Moisture Index

gen smi = 1 -(1/(1+(soil/avfieldwilt)^6))

label var smi "Sol Moisture Index (monthly)"

*** Calculate Soil Moisture Anomaly ***

*Generate mean and standard deviation for the long run 

gen lrm_smi=. 
gen lrsd_smi=.

***********************************************NEW******************************************
	foreach var in  1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 ///
					1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 ///
					1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 ///
					1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 ///
					1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 ///
					2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 ///
					2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {
***********************************************NEW******************************************

	*Mean for the full-period
	
	egen lrm_smi`var'=mean(smi) if year<`var', by(cellid month)
	egen lrsd_smi`var'=sd(smi) if year<`var', by(cellid month)

	*Replace cells that are missing 
	
	replace lrm_smi`var'=lrm_smi`var'[_n-1] if lrm_smi`var'==. & cellid==cellid[_n-1]
	replace lrsd_smi`var'=lrsd_smi`var'[_n-1] if lrsd_smi`var'==. & cellid==cellid[_n-1]

	*Keep mean only for relevant years
	
	replace lrm_smi`var'=. if year!=`var'
	replace lrsd_smi`var'=.  if year!=`var'

	*Consolidate into one variable
	
	replace lrm_smi=lrm_smi`var' if year==`var'
	replace lrsd_smi=lrsd_smi`var' if year==`var'

	drop lrm_smi`var' lrsd_smi`var'

	}

label var lrm_smi "Long run soil moisture mean"
label var lrsd_smi "Long run soil moisture std. dev."

/*
*Mean for the last 20 years 

gen m_smi=. 
gen sd_smi=.

	foreach var in  2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {

	local i= `var'-22
	display `i'

	*Mean for the past 20 years
	
	egen m_smi`var'=mean(smi) if year>`i' & year<`var', by(cellid month)
	egen sd_smi`var'=sd(smi) if year>`i' & year<`var', by(cellid month)

	*Replace cells that are missing 
	
	replace m_smi`var'=m_smi`var'[_n-1] if m_smi`var'==. & cellid==cellid[_n-1]
	replace sd_smi`var'=sd_smi`var'[_n-1] if sd_smi`var'==. & cellid==cellid[_n-1]

	*Keep mean only for relevant years
	
	replace m_smi`var'=. if year!=`var'
	replace sd_smi`var'=.  if year!=`var'

	*Consolidate into one variable
	
	replace m_smi=m_smi`var' if year==`var'
	replace sd_smi=sd_smi`var' if year==`var'

	drop m_smi`var' sd_smi`var'
	
	}

label var m_smi "Soil moisture mean past 20 years"
label var sd_smi "Soil moisture std. dev. past 20 years"
*/

//If smi equals zero then the soil is severly dry, if smi equals 1 then the soil moisture is above field capacity 

label var soil "Soil moisture"

*Generate soil moisture anomalies 

*gen sma=(smi-m_smi)/sd_smi
*label var sma "Soil moisture anomaly"
gen lrsma=(smi-lrm_smi)/lrsd_smi
label var lrsma "Long-run soil moisture anomaly"

*keep if year>=2010
*drop if year==2020

rename ymonth myear 
rename cellid _ID 

drop month year 

label var fieldcapraster "Field capacity"
label var wiltpontraster "Wilting point"
label var avfieldwilt "Average field cap and wilting point"

save "data/smi_sma_cells_`data'_1948.dta", replace

}

*erase "data/monthly.dta"
*erase "data/monthly_5x5.dta"


