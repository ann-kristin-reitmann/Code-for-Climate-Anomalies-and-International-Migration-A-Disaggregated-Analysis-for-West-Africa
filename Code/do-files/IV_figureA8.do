
*-------------------------------------------------------------------------------------------
* Figure A8
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure A8

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear

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

*continuous lrsma measure only for cells with crops

**probability to migrate

foreach var in dinter {

	foreach sma in 	lrsmal1gs lrsma2gs lrsma3gs lrsma4gs lrsma5gs lrsma6gs ///
					lrsma7gs lrsma8gs lrsma9gs lrsma10gs lrsma11gs lrsma12gs {
	 
	areg `var' c.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo res_`var'_`sma'
	
	}
	
}

**number of migrants

foreach var in cinter {
  
	foreach sma in 	lrsmal1gs lrsma2gs lrsma3gs lrsma4gs lrsma5gs lrsma6gs ///
					lrsma7gs lrsma8gs lrsma9gs lrsma10gs lrsma11gs lrsma12gs {	
	
	ppmlhdfe `var'  c.`sma'  $control $fe if ///
	cropincell==1 & lrsma12gs!=., absorb(_ID) vce(cluster _ID)
	eststo ppml_`var'_`sma'
	
	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

local color yline(0, lcolor(black) lpattern(dash)) graphregion(fcolor(white) ///
			lcolor(white)) plotregion(fcolor(white) lcolor(white))
local grid 	xlabel(, glwidth(thin) glpattern(dash) glcolor(gs12)) ///
			legend(region(lwidth(none)))
local axis 	ylabel(" ", labsize(medium) labcolor(black) tlcolor(gs5)) ///
			ylabel(, labsize(medium) labcolor(gs5) tlcolor(gs5)) ///
			yscale(lcolor(gs5)) xscale(lcolor(gs5)) 	
			
local resultsgs 	res_dinter_lrsmal1gs res_dinter_lrsma2gs res_dinter_lrsma3gs ///
					res_dinter_lrsma4gs res_dinter_lrsma5gs res_dinter_lrsma6gs ///
					res_dinter_lrsma7gs res_dinter_lrsma8gs res_dinter_lrsma9gs ///
					res_dinter_lrsma10gs res_dinter_lrsma11gs res_dinter_lrsma12gs

coefplot 	(`resultsgs', keep(lrsma*) label("Average SMA")  mcolor(black) ///
			ciopts(lcolor(black)) offset(-0.2)),  /// 
			rename(lrsmal1gs=1 lrsma2gs=2 lrsma3gs=3 lrsma4gs=4 ///
				lrsma5gs=5 lrsma6gs=6 lrsma7gs=7 lrsma8gs=8 ///
				lrsma9gs=9 lrsma10gs=10 lrsma11gs=11 lrsma12gs=12) ///
			vertical ytitle("Probablity to migrate") xtitle("Number of months") ///
			`color' `coeff' `grid'  ///
			name("prob", replace)
			  
local resultsgs 	ppml_cinter_lrsmal1gs ppml_cinter_lrsma2gs ppml_cinter_lrsma3gs ///
					ppml_cinter_lrsma4gs ppml_cinter_lrsma5gs ppml_cinter_lrsma6gs ///
					ppml_cinter_lrsma7gs ppml_cinter_lrsma8gs ppml_cinter_lrsma9gs ///
					ppml_cinter_lrsma10gs ppml_cinter_lrsma11gs ppml_cinter_lrsma12gs

coefplot 	(`resultsgs', keep(lrsma*) label("Average SMA")  mcolor(black) ///
			ciopts(lcolor(black)) offset(-0.2)) , /// 
			rename(lrsmal1gs=1 lrsma2gs=2 lrsma3gs=3 lrsma4gs=4 ///
				lrsma5gs=5 lrsma6gs=6 lrsma7gs=7 lrsma8gs=8 ///
				lrsma9gs=9 lrsma10gs=10 lrsma11gs=11 lrsma12gs=12) ///
			vertical ytitle("Number of migrants") xtitle("Number of months") ///
			`color' `coeff' `grid'  ///
			name("total", replace)
	
graph 	combine prob  total, col(1) graphregion(fcolor(white) lcolor(white)) ///
		imargin(medium) ysize(3) 
graph export "output/figures/figure_A8.pdf", replace 
