
*-------------------------------------------------------------------------------------------
* Figure 7
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure 7

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month.dta", clear

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------

sort _ID myear

*lagged variable 
	
gen lrsmal1=l1.lrsma 	if _ID==_ID[_n-1]	

gen lrsmal1gs=l1.lrsma 	if growcrop[_n-1]==1 & _ID==_ID[_n-1]	

*categorical variable 

foreach var in lrsmal1gs lrsma3gs lrsma6gs lrsma9gs lrsma12gs {

	gen c`var'=. 
	replace c`var'=1 if `var'<-1  & !mi(`var')
	replace c`var'=2 if `var'>=-1 & `var'<=1 & !mi(`var')
	replace c`var'=3 if `var'>1 & !mi(`var')
	label var c`var' "Categorical `var'"
	
} 

*invert categories

foreach var in lrsmal1gs lrsma3gs lrsma6gs lrsma9gs lrsma12gs {

	gen c`var'inv=. 
	replace c`var'inv=3 if `var'<-1  & !mi(`var')
	replace c`var'inv=2 if `var'>=-1 & `var'<=1 & !mi(`var')
	replace c`var'inv=1 if `var'>1 & !mi(`var')
	label var c`var'inv "Inverse categorical `var'"
	
} 

*rename variables

rename dinternational dinter 

*identify cells with shocks in the past 5 years 

preserve

	sort _ID year 
	
	keep if month==12
	
	gen flag=1 if clrsma12gs==1
	
	replace flag=0 if flag==.
	
	xtset _ID year
	
	gen trend=(L1.flag+L2.flag+L3.flag+L4.flag+L4.flag) 

	keep if year==2018 | year==2019

	keep _ID year trend 

save "data/junk4_v2.dta", replace

restore

*merge other data

use "data/final_cell_5by5_month_sample.dta", clear

xtset _ID

*Define globals
 
global control  cellfmp_bin fmpbuff200km
global fe		i.month i.year##i.country_share
global se   	vce(cluster _ID)

eststo clear

merge m:1 year _ID using "data/junk4_v2.dta"
drop if _merge==2
drop _merge 

*previous very dry seasons 

replace trend=2 if trend>=2 & trend!=.
replace trend=trend+1 

*-------------------------------------------------------------------------------
* Globals
*-------------------------------------------------------------------------------

global control  cellfmp_bin fmpbuff200km
global fe		i.month i.year##i.country_share
global se   	vce(cluster _ID)

*-------------------------------------------------------------------------------
* Regressions
*-------------------------------------------------------------------------------

eststo clear

*set fixed effects

xtset _ID 

*categorical climate anolamies only for cells with crops

**probability to migrate

foreach var in dinter {

	foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
	
	areg `var' b2.`sma'##i.trend  $control $fe if cropincell==1 & lrsma12gs!=., ///
	absorb(_ID) $se
	eststo nor_`var'_`sma'
	eststo me_`var'_`sma': margins, dydx(`sma') at(trend=(1(1)3)) vsquish ///
	noestimcheck post

	areg `var' b2.`sma'inv##i.trend  $control $fe if cropincell==1 & lrsma12gs!=., ///
	absorb(_ID) $se
	eststo nor_`var'_`sma'
	eststo me_`var'_`sma'inv: margins, dydx(`sma') at(trend=(1(1)3)) vsquish ///
	noestimcheck post

  }
  
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

*graph style locals 

local color yline(0, lcolor(black) lpattern(dash)) ///
			graphregion(fcolor(white) lcolor(white)) ///
			plotregion(fcolor(white) lcolor(white))
local coeff mcolor(black) ciopts(lcolor(black))
local grid 	xlabel(, glwidth(thin) glpattern(dash) glcolor(gs12)) ///
			legend(region(lwidth(none)))
local axis 	ylabel(, labsize(medium) labcolor(black) tlcolor(gs5)) ///
			ylabel(, labsize(medium) labcolor(gs5) tlcolor(gs5)) ///
			yscale(lcolor(gs5)) xscale(lcolor(gs5)) 	

*drier conditions
 
coefplot 	(me_dinter_clrsmal1gs, label("1 month") mcolor(black) ///
				ciopts(lcolor(black)) offset(-0.2)) ///
			(me_dinter_clrsma3gs, label("3 months") mcolor(gs4) ///
				ciopts(lcolor(gs4)) offset(-0.1)) ///
			(me_dinter_clrsma6gs, label("6 months") mcolor(gs6) ///
				ciopts(lcolor(gs6)) offset(0)) ///
			(me_dinter_clrsma9gs, label("9 months") mcolor(gs8) ///
				ciopts(lcolor(gs8)) offset(0.1)) ///
			(me_dinter_clrsma12gs, label("12 months")  mcolor(gs10) ///
				ciopts(lcolor(gs10)) offset(0.2)) , vertical  ///
			xlabel(1 "No previous drought" 2 "One drought" 3 "Two or more droughts") ///
			ytitle("Probability to migrate") legend(col(5)) xtitle(" ") ///
			`color' `grid' name(drought_bin, replace)  title("Drier conditions", ///
			size(medium) color(black))

*wetter conditions
			
coefplot 	(me_dinter_clrsmal1gsinv, label("1 month") mcolor(black) ///
				ciopts(lcolor(black)) offset(-0.2)) ///
			(me_dinter_clrsma3gsinv, label("3 months") mcolor(gs4) ///
				ciopts(lcolor(gs4)) offset(-0.1)) ///
			(me_dinter_clrsma6gsinv, label("6 months") mcolor(gs6) ///
				ciopts(lcolor(gs6)) offset(0)) ///
			(me_dinter_clrsma9gsinv, label("9 months") mcolor(gs8) ///
				ciopts(lcolor(gs8)) offset(0.1)) ///
			(me_dinter_clrsma12gsinv, label("12 months")  mcolor(gs10) ///
				ciopts(lcolor(gs10)) offset(0.2)) , vertical ///
			xlabel(1 "No previous drought" 2 "One drought" 3 "Two or more droughts") ///
			ytitle("Probability to migrate") legend(off) xtitle(" ") ///
			`color' `grid' name(drought_bin_inv, replace)  title("Wetter conditions", ///
			size(medium) color(black))

graph 	combine drought_bin_inv drought_bin , col(1) ///
		graphregion(fcolor(white) lcolor(white)) imargin(medium)	  
graph export "output/figures/figure_07.pdf", replace 
