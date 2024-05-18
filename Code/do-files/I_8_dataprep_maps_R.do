
*-------------------------------------------------------------------------------------------
* 8. Data prep do-file: R & maps
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file prepares data to read in R and generate maps

*-------------------------------------------------------------------------------------------
* I. Save data for maps in R 
*-------------------------------------------------------------------------------------------

foreach data in 1by1 5by5 {

use "data/final_cell_`data'.dta", clear // load yearly cell data

keep if year>=2017 
keep _ID year *sma* ymig*  yintonmove yinternational yinternal inf_mort pop_sum west

*replace ysma_gs=. if ysma_gs==0
*replace ylrsma_gs=. if ylrsma_gs==0

foreach var in ysma ylrsma ysma_gs ylrsma_gs ysma ylrsma ysma_gs ylrsma_gs inf_mort pop_sum {
replace `var'=. if west!=1 
}

reshape wide *sma* ymig*  yintonmove yinternational yinternal inf_mort, i(_ID) j(year)

	if "`data'" == "1by1" {
	export delimited "data/Rdata/final_sma_mig.csv", replace
	}

	if "`data'" == "5by5" {
	export delimited "data/Rdata/.5x.5/final_sma_mig.csv", replace
	}

}

*To generate descriptive migration maps

use "data/final_cell_5by5_month.dta", clear

keep if year==2018

keep _ID year month myear cmigrant 
egen totmigrant=sum(cmigrant), by(_ID year)

keep if month==3 | month==8
 
replace totmigrant=. if cmigrant==. 
 
keep _ID month cmigrant totmigrant  
reshape wide cmigrant totmigrant , i(_ID) j(month)

drop totmigrant8 
rename totmigrant3 totmigrant

export delimited "data/Rdata/.5x.5/num_mig_desc.csv", replace

use "data/final_country_month.dta", clear

keep if year==2018

keep _ID year month myear cmigrant 
egen totmigrant=sum(cmigrant), by(_ID year)

keep if month==3 | month==8
 
replace totmigrant=. if cmigrant==. 
 
keep _ID month cmigrant totmigrant  
reshape wide cmigrant totmigrant , i(_ID) j(month)

drop totmigrant8 
rename totmigrant3 totmigrant

export delimited "data/Rdata/.5x.5/num_mig_desc_country.csv", replace

*** ONLY FOR R MAPS

use "data\cells_5by5_all.dta", clear
keep _ID west
duplicates drop 
save "data\west_monthly_5x5.dta", replace 

use "data\cells_1by1_all.dta", clear
keep _ID west
duplicates drop 
save "data\west_monthly.dta", replace 

use "data\country_all.dta", clear
keep _ID west
duplicates drop
save "data\west_country.dta", replace 

foreach data in country monthly monthly_5x5 { 

use "data/smi_sma_cells_`data'.dta", clear

sort _ID myear

capture noisily drop west 

merge m:1 _ID using  "data/west_`data'.dta"

drop if _merge==2
drop _merge 

gen year=yofd(dofm(myear))

keep if year>=2018

	foreach var in smi lrm_smi m_smi sma lrsma {

	egen `var'2018temp=mean(`var') if year==2018, by(_ID year)
	egen `var'2019temp=mean(`var') if year==2019, by(_ID year)

	egen `var'2018=max(`var'2018temp), by(_ID)
	egen `var'2019=max(`var'2019temp), by(_ID)

	}

generate myear2 = string(myear, "%tm")
drop myear 
rename myear2 myear 

sum sma2018, d
sum sma2019, d

	foreach var in smi lrm_smi m_smi sma lrsma sma2018 sma2019 lrm_smi2018 lrm_smi2019 m_smi2018 m_smi2019 sma2018 sma2019 lrsma2018 lrsma2019 lrsd_smi sd_smi smi2018 smi2019 {

	replace `var'=. if sma2018>=13 & `var'!=. // remove outliers
	replace `var'=. if sma2019>=13 & `var'!=. // remove outliers

	}

	/*foreach var in lrsma2018 sma2018 lrsma2019 sma2019 sma lrsma {

	replace `var'=3 if `var'>=3 & `var'!=.  // remove outliers
	replace `var'=-3 if `var'<=-3 & `var'!=. // remove outliers

	}*/

	drop year *temp

reshape wide soil smi lrm_smi lrsd_smi m_smi sd_smi sma lrsma, i(_ID) j(myear) string

order _ID soil* smi* lrm_smi* m_smi* sma* lrsma* 

	foreach var in lrsma2018m1 lrsma2018m10 lrsma2018m11 lrsma2018m12 lrsma2018m2 lrsma2018m3 	lrsma2018m4 lrsma2018m5 lrsma2018m6 lrsma2018m7 lrsma2018m8 lrsma2018m9 lrsma2019m1 lrsma2019m10 lrsma2019m11 lrsma2019m12 lrsma2019m2 lrsma2019m3 lrsma2019m4 lrsma2019m5 lrsma2019m6 lrsma2019m7 lrsma2019m8 lrsma2019m9 lrsma2020m1 lrsma2018 lrsma2019 {
	replace `var'=. if west==0 | west==.
	}

	local path `data'
	 
	if  "`path'" == "country" {
	export delimited "data/Rdata/moisture_cells_year_country.csv", replace
	}

	if  "`path'" == "monthly" {
	export delimited "data/Rdata/moisture_cells_year.csv", replace
	}

	if  "`path'" == "monthly_5x5" {
	export delimited "data/Rdata/.5x.5/moisture_cells_year.csv", replace
	}

}
