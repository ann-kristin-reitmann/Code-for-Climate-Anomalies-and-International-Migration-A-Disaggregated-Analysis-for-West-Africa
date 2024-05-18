*-------------------------------------------------------------------------------------------
* Figure 6
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure 6

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

*categorical climate anolamies only for cells with crops

**probability to migrate

foreach var in dinter {

	foreach sma in 	clrsmal1gs clrsma2gs clrsma3gs clrsma4gs clrsma5gs clrsma6gs ///
					clrsma7gs clrsma8gs clrsma9gs clrsma10gs clrsma11gs clrsma12gs {
	 
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo res_`var'_`sma'

	}
	
}

**number of migrants

foreach var in cinter {
  
	foreach sma in 	clrsmal1gs clrsma2gs clrsma3gs clrsma4gs clrsma5gs clrsma6gs ///
					clrsma7gs clrsma8gs clrsma9gs clrsma10gs clrsma11gs clrsma12gs {					
	
	xtnbreg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	iter(20) fe difficult
	eststo res_`var'_`sma'
	
	}	
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------	

local color yline(0, lcolor(black) lpattern(dash)) graphregion(fcolor(white) ///
			lcolor(white)) plotregion(fcolor(white) lcolor(white))
local grid 	xlabel(, glwidth(thin) glpattern(dash) glcolor(gs12))  ///
			legend(region(lwidth(none)))
local axis 	ylabel(" ", labsize(medium) labcolor(black) tlcolor(gs5)) ///
			ylabel(, labsize(medium) labcolor(gs5) tlcolor(gs5)) ///
			yscale(lcolor(gs5)) xscale(lcolor(gs5)) 	

local resultsgs 	res_dinter_clrsmal1gs res_dinter_clrsma2gs res_dinter_clrsma3gs ///
					res_dinter_clrsma4gs res_dinter_clrsma5gs res_dinter_clrsma6gs ///
					res_dinter_clrsma7gs res_dinter_clrsma8gs res_dinter_clrsma9gs ///
					res_dinter_clrsma10gs res_dinter_clrsma11gs res_dinter_clrsma12gs

coefplot 	(`resultsgs', keep(1.clrsma*) label("Estimated coefficient")  ///
			mcolor(black) ciopts(lcolor(black)) offset(-0.3)) , /// 
			rename(1.clrsmal1gs=1 1.clrsma2gs=2 1.clrsma3gs=3 1.clrsma4gs=4 ///
				1.clrsma5gs=5 1.clrsma6gs=6 1.clrsma7gs=7 1.clrsma8gs=8 ///
				1.clrsma9gs=9 1.clrsma10gs=10 1.clrsma11gs=11 1.clrsma12gs=12) ///
			vertical ytitle("Probability to migrate") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.04,.04)) ylabel(-.04(.02).04) ///
			title("Drier conditions", size(medium) color(black)) name("dry1", replace)
						
coefplot 	(`resultsgs', keep(3.clrsma*) label("Estimated coefficient")  ///
			mcolor(black) ciopts(lcolor(black)) offset(-0.3)) , ///
			rename(3.clrsmal1gs=1 3.clrsma2gs=2 3.clrsma3gs=3 3.clrsma4gs=4 ///
				3.clrsma5gs=5 3.clrsma6gs=6 3.clrsma7gs=7 3.clrsma8gs=8 ///
				3.clrsma9gs=9 3.clrsma10gs=10 3.clrsma11gs=11 3.clrsma12gs=12) ///
			vertical ytitle("Probability to migrate") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.04,.04)) ylabel(-.04(.02).04)  ///
			title("Wetter conditions", size(medium) color(black)) name("wet1", replace)
							  
local resultsgs 	res_cinter_clrsmal1gs res_cinter_clrsma2gs res_cinter_clrsma3gs ///
					res_cinter_clrsma4gs res_cinter_clrsma5gs res_cinter_clrsma6gs ///
					res_cinter_clrsma7gs res_cinter_clrsma8gs res_cinter_clrsma9gs ///
					res_cinter_clrsma10gs res_cinter_clrsma11gs res_cinter_clrsma12gs				
				
coefplot 	(`resultsgs', keep(1.clrsma*) label("Estimated coefficient")  ///
			mcolor(black) ciopts(lcolor(black)) offset(-0.3)) , ///
			rename(1.clrsmal1gs=1 1.clrsma2gs=2 1.clrsma3gs=3 1.clrsma4gs=4 ///
				1.clrsma5gs=5 1.clrsma6gs=6 1.clrsma7gs=7 1.clrsma8gs=8 ///
				1.clrsma9gs=9 1.clrsma10gs=10 1.clrsma11gs=11 1.clrsma12gs=12) ///
			vertical ytitle("Number of migrants") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.6,.6)) ylabel(-.6(.2).6)  ///
			title("Drier conditions", size(medium) color(black)) name("dry2", replace)
						
coefplot 	(`resultsgs', keep(3.clrsma*) label("Estimated coefficient")  ///
			mcolor(black) ciopts(lcolor(black)) offset(-0.3)) , ///
			rename(3.clrsmal1=1 3.clrsma2=2 3.clrsma3=3 3.clrsma4=4 ///
				3.clrsma5=5  3.clrsma6=6 3.clrsma7=7 3.clrsma8=8 ///
				3.clrsma9=9  3.clrsma10=10 3.clrsma11=11 3.clrsma12=12 ///
				3.clrsmal1gs=1 3.clrsma2gs=2 3.clrsma3gs=3 3.clrsma4gs=4 ///
				3.clrsma5gs=5 3.clrsma6gs=6 3.clrsma7gs=7 3.clrsma8gs=8 ///
				3.clrsma9gs=9 3.clrsma10gs=10 3.clrsma11gs=11 3.clrsma12gs=12) ///
			vertical ytitle("Number of migrants") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.6,.6)) ylabel(-.6(.2).6)  ///
			title("Wetter conditions", size(medium) color(black)) name("wet2", replace)
							
graph 	combine wet1 dry1 wet2 dry2 , col(2) graphregion(fcolor(white) ///
		lcolor(white)) imargin(medium) ysize(3) 
graph export "output/figures/figure_06.pdf", replace 
		