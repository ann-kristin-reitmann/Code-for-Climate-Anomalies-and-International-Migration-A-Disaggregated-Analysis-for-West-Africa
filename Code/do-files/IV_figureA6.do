
*-------------------------------------------------------------------------------------------
* Figure A6
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure A6

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

eststo clear

*set fixed effects

xtset _ID 

twoway 	(scatter cinter inf_mort, ///
		mcolor(black) msize(vsmall) msymbol(circle_hollow) mlwidth(vthin)) ///
		(qfit cinter inf_mort, lcolor(gs8) yaxis(2) yscale(r(-.2,1) axis(2)) ///
		ylabel(-.2(.3)1, axis(2))), ///
		ytitle(Number of migrants) xtitle(Infant mortality rate) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off)
graph export "output/figures/figure_A6.pdf", replace
