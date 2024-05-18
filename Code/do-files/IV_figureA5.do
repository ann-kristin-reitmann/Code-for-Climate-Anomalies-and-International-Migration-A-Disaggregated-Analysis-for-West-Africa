
*-------------------------------------------------------------------------------------------
* Figure A5
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure A5

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

sort povxtile myear _ID 

gen obs1=_n if povxtile==1 & lrsma!=. 

sort  povxtile myear _ID 

label var obs1 "First poverty quintile"

line 	lrsma obs1 if obs1!=., ///
		xlabel(2516 "18m6" 5464 "18m12"  8357 "19m6"  11240 "19m12") ///
		name(pov1, replace)  graphregion(fcolor(white) lcolor(white)) ///
		scheme(s2mono) lwidth(vvthin)

drop obs1 

sort povxtile myear _ID 

gen obs2=_n if povxtile==5 & lrsma!=. 

replace obs2=obs2-48751

bys myear: sum obs2

sort povxtile myear _ID 

label var obs2 "Fifth poverty quintile"

line 	lrsma obs2 if obs2!=., ///
		xlabel(2768 "18m6" 5985 "18m12" 9212 "19m6" 12430 "19m12") ///
		name(pov2, replace) graphregion(fcolor(white) lcolor(white)) ///
		scheme(s2mono) lwidth(vvthin)

graph 	combine pov1 pov2, col(1) ///
		graphregion(fcolor(white) lcolor(white)) imargin(medium)	  
graph export "output/figures/figure_A5.pdf", replace 
