
*-------------------------------------------------------------------------------------------
* 5a. Data prep do-file: restricted sample (robustness Jan 18 - Dec 19)
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file generates the restricted sample, which we will use for the rest of the analysis (robustness Jan 18 - Dec 19)
*Note: This data is for running the robustness check "FMPs open Jan 2018 - Dec 2019"

use "data/final_cell_5by5_month_jan18dec19.dta", clear

eststo clear

*-------------------------------------------------------------------------------------------
* I. Add extra variables (these were included after running the preliminary regressions)
*-------------------------------------------------------------------------------------------

xtile povxtile=inf_mort if west==1, nq(5)
label var povxtile "Poverty quintile"

xtile popxtile5=pop_sum if west==1, nq(5)
label var popxtile5 "Poverty quintile"
xtile popxtile4=pop_sum if west==1, nq(4)
label var popxtile4 "Poverty quintile"

xtset _ID myear

*Merge irrigation variables 

drop _merge
merge m:1 _ID using "data/irrigation_area.dta"
drop if _merge==2
drop _merge

gen irrdummy=0
replace irrdummy=1 if irrigation>=5
label var irrdummy "Cell has an irrigation system"

gen irrdummyinv=1
replace irrdummyinv=0 if irrigation>=10
label var irrdummyinv "Cell has no irrigation syste"

gen nodiv=0
replace nodiv=1 if crop_area>=60
label var nodiv "Cell has no crop diversity"
			 
sort  _ID myear

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

*FMP binary variable

gen cellfmp_bin=.
replace cellfmp_bin=1 if cellfmp==1 | cellfmp==2
replace cellfmp_bin=0 if cellfmp==0
label var cellfmp_bin "FMP in cell"

*--------------------------------------------------------------------------------
*II. Keep if e(sample)
*--------------------------------------------------------------------------------
			
rename dinternational dinter
rename cinternational cinter 

rename dintonmove dmove
rename cintonmove cmove
rename dmigeurope deuro
rename cmigeurope ceuro

rename dmigafrica dafric
rename cmigafrica cafric

keep if year==2018 | year==2019 // first restriction 
keep if west==1 // second restriction

*Define globals 

global control  cellfmp_bin fmpbuff200km
global fe		i.month i.year##i.country_share
global se   	vce(cluster _ID)

foreach var in dinter cinter {

  foreach sma in lrsmal1 lrsma2 lrsma3 lrsma4 lrsma5 lrsma6 ///
					lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 {
  
	areg `var' c.`sma'  $control $fe, absorb(_ID) $se
	keep if e(sample)
		
	}
	
}

*--------------------------------------------------------------------------------
*III. Save data
*--------------------------------------------------------------------------------

save "data/final_cell_5by5_month_sample_jan18dec19.dta", replace
