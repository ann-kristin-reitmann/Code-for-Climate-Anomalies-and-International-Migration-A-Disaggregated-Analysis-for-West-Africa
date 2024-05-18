
*-------------------------------------------------------------------------------------------
* 7b. Data prep do-file: quarterly data
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file generates the annual data

*-------------------------------------------------------------------------------
* I. Prepare annual data 5x5
*-------------------------------------------------------------------------------

*Identify cells included in final sample 

use "data/final_cell_5by5_month_sample.dta", clear

	keep _ID 
	duplicates drop 
	gen flag=1
	
save "data\junk.dta", replace 

*-------------------------------------------------------------------------------
* II. Generate new variables 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month.dta", clear

eststo clear

xtset _ID 

egen sumshockgs=sum(shockgs), by(_ID year)
egen sumcropmonths=sum(growcrop), by(_ID year)

egen sumshock=sum(shock), by(_ID year)
egen sumposshock=sum(posshock), by(_ID year)

*Dry and wet months in the past 5 years 

gen year5_18=1 if year>=2013 & year<=2017

gen year5_19=1 if  year>=2014 & year<=2018

egen sumshock5=sum(shock), by(_ID year5_18) 
replace sumshock5=. if year!=2018

egen sumshock52=sum(shock), by(_ID year5_19) // number of dry months for the past 5 years in 2018
replace sumshock52=. if year!=2019 // number of dry months for the past 5 years in 2019
replace sumshock5=sumshock52 if sumshock5==. // combine both into one variable 
drop sumshock52

egen sumposshock5=sum(posshock), by(_ID year5_18) 
replace sumposshock5=. if year!=2018

egen sumposshock52=sum(posshock), by(_ID year5_19) // number of dry months for the past 5 years in 2018
replace sumposshock52=. if year!=2019 // number of dry months for the past 5 years in 2019
replace sumposshock5=sumposshock52 if sumposshock5==. // combine both into one variable 
drop sumposshock52

keep if month==12
drop _merge

merge m:1 _ID using "data\junk.dta"
keep if _merge==3
drop _merge

keep _ID myear sumshockgs sumcropmonths sum*

gen sumshmonths=sumshockgs/sumcropmonths 

save "data\junk.dta", replace 

*-------------------------------------------------------------------------------
* III. Prepare and merge quarterly data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_quarter.dta", clear

gen dry_q=0 
replace dry_q=1 if cqlrsma==1

gen wet_q=0 
replace wet_q=1 if cqlrsma==3

*Dummy if dry or wet conditions happened during the year 

egen maxdry_q=max(dry_q), by(_ID year)

egen maxwet_q=max(wet_q), by(_ID year)

gen maxnorm_q=0 
replace maxnorm_q=1 if maxdry_q==0 & maxwet_q==0  

drop _merge 

keep _ID year max* 
duplicates drop 

save "data\junk1.dta", replace 

use "data/final_cell_5by5_month_sample.dta", clear

egen mig=max(dinter), by(_ID)
gen same=1 if cinter==cinter[_n-1] & _ID==_ID[_n-1]

egen maxsame=max(same), by(_ID)
keep _ID  cropincell mig

duplicates drop 
bys cropincell: tab mig
rename mig samplecell
save "data/junk2.dta", replace 

use "data/final_cell_5by5.dta", clear

drop _merge 
merge 1:1 _ID myear using "data\junk.dta"
keep if _merge==3
drop _merge

merge 1:1 _ID year using "data\junk1.dta"
drop if _merge==2  // not all years will merge, because quarterly data was restricted
drop _merge

merge m:1 _ID using "data/junk2.dta"
drop _merge 

*-------------------------------------------------------------------------------
* IV. Merge irrigation variables 
*-------------------------------------------------------------------------------

merge m:1 _ID using "data/irrigation_area.dta"
drop if _merge==2
drop _merge

gen irrdummy=0
replace irrdummy=1 if irrigation>=5
label var irrdummy "Cell has an irrigation system"

gen irrdummyinv=1
replace irrdummyinv=0 if irrigation>=10
label var irrdummyinv "Cell has no irrigation system"

gen nodiv=0
replace nodiv=1 if crop_area>=60
label var nodiv "Cell has no crop diversity"

*-------------------------------------------------------------------------------
*V. Generate new variables 
*-------------------------------------------------------------------------------

xtset _ID myear

eststo clear
		 
sort _ID myear

*Lagged variable
 	
gen lrsmal1=l1.lrsma if  _ID==_ID[_n-1]	

gen lrsmal1gs=l1.lrsma if  growcrop[_n-1]==1 & _ID==_ID[_n-1]	

*Categorical variable 

foreach var in lrsmal1 lrsma2 lrsma3 lrsma4 lrsma5 lrsma6 ///
lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 ///
lrsmal1gs lrsma2gs lrsma3gs lrsma4gs lrsma5gs lrsma6gs ///
lrsma7gs lrsma8gs lrsma9gs lrsma10gs lrsma11gs lrsma12gs {

gen c`var'=. 
replace c`var'=1 if `var'<-1  & !mi(`var')
replace c`var'=2 if `var'>=-1 & `var'<=1 & !mi(`var')
replace c`var'=3 if `var'>1 & !mi(`var')
label var c`var' "Categorical `var'"
} 

*Invert categories

foreach var in lrsmal1 lrsma2 lrsma3 lrsma4 lrsma5 lrsma6 ///
lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 ///
lrsmal1gs lrsma2gs lrsma3gs lrsma4gs lrsma5gs lrsma6gs ///
lrsma7gs lrsma8gs lrsma9gs lrsma10gs lrsma11gs lrsma12gs {

gen c`var'inv=. 
replace c`var'inv=3 if `var'<-1  & !mi(`var')
replace c`var'inv=2 if `var'>=-1 & `var'<=1 & !mi(`var')
replace c`var'inv=1 if `var'>1 & !mi(`var')
label var c`var'inv "Inverse categorical `var'"
} 

xtset _ID year
	
*Make sure we have the correct number of cells 

egen num_cell=group(_ID)
sum num_cell  // I have 2636 cells 

*keep if year==2018 | year==2019
egen max_mig=max(yinternational), by(_ID) 

gen lagshock=l1.shock12
gen lagposshock=l1.posshock12

xtile povxtile=inf_mort if west==1, nq(5)
label var povxtile "Poverty quintile"

*-------------------------------------------------------------------------------
* VI. Save data
*-------------------------------------------------------------------------------

save "data/final_cell_5by5_yearly.dta", replace 
