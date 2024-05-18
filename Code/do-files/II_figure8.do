
*-------------------------------------------------------------------------------------------
* Figure 8
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure 8

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear

*-------------------------------------------------------------------------------
* Globals
*-------------------------------------------------------------------------------

global control  cellfmp fmpbuff200km
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
  
	areg `var' b2.`sma'##i.povxtile $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo me_`var'_`sma': margins, dydx(`sma') over(povxtile) vsquish noestimcheck post

	areg `var' b2.`sma'inv##i.povxtile $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo me_`var'_`sma'inv: margins, dydx(`sma') over(povxtile) vsquish noestimcheck post
	
	}
	
}

*-------------------------------------------------------------------------------
* Stat. sign. differences?
*-------------------------------------------------------------------------------

log using "output/log/figure8_difference.smcl", replace

*drier

foreach num in l1 3 6 9 12 {

	areg dinter b2.clrsma`num'gs##i.povxtile $control $fe if cropincell==1 & lrsma12gs!=. , absorb(_ID) $se
	margins, dydx(clrsma`num'gs) over(povxtile) vsquish noestimcheck post
	margins, coefl

		lincom _b[1.clrsma`num'gs:1bn.povxtile] - _b[1.clrsma`num'gs:2.povxtile]
		lincom _b[1.clrsma`num'gs:1bn.povxtile] - _b[1.clrsma`num'gs:3.povxtile]
		lincom _b[1.clrsma`num'gs:1bn.povxtile] - _b[1.clrsma`num'gs:4.povxtile]
		lincom _b[1.clrsma`num'gs:1bn.povxtile] - _b[1.clrsma`num'gs:5.povxtile]
		lincom _b[1.clrsma`num'gs:2.povxtile] - _b[1.clrsma`num'gs:3.povxtile]
		lincom _b[1.clrsma`num'gs:2.povxtile] - _b[1.clrsma`num'gs:4.povxtile]
		lincom _b[1.clrsma`num'gs:2.povxtile] - _b[1.clrsma`num'gs:5.povxtile]
		lincom _b[1.clrsma`num'gs:3.povxtile] - _b[1.clrsma`num'gs:4.povxtile]
		lincom _b[1.clrsma`num'gs:3.povxtile] - _b[1.clrsma`num'gs:5.povxtile]
		lincom _b[1.clrsma`num'gs:4.povxtile] - _b[1.clrsma`num'gs:5.povxtile]

}

*wetter

foreach num in l1 3 6 9 12 {

	areg dinter b2.clrsma`num'gsinv##i.povxtile $control $fe if cropincell==1 & lrsma12gs!=. , absorb(_ID) $se
	margins, dydx(clrsma`num'gsinv) over(povxtile) vsquish noestimcheck post
	*margins, coefl

		lincom _b[1.clrsma`num'gsinv:1bn.povxtile] - _b[1.clrsma`num'gsinv:2.povxtile]
		lincom _b[1.clrsma`num'gsinv:1bn.povxtile] - _b[1.clrsma`num'gsinv:3.povxtile]
		lincom _b[1.clrsma`num'gsinv:1bn.povxtile] - _b[1.clrsma`num'gsinv:4.povxtile]
		lincom _b[1.clrsma`num'gsinv:1bn.povxtile] - _b[1.clrsma`num'gsinv:5.povxtile]
		lincom _b[1.clrsma`num'gsinv:2.povxtile] - _b[1.clrsma`num'gsinv:3.povxtile]
		lincom _b[1.clrsma`num'gsinv:2.povxtile] - _b[1.clrsma`num'gsinv:4.povxtile]
		lincom _b[1.clrsma`num'gsinv:2.povxtile] - _b[1.clrsma`num'gsinv:5.povxtile]
		lincom _b[1.clrsma`num'gsinv:3.povxtile] - _b[1.clrsma`num'gsinv:4.povxtile]
		lincom _b[1.clrsma`num'gsinv:3.povxtile] - _b[1.clrsma`num'gsinv:5.povxtile]
		lincom _b[1.clrsma`num'gsinv:4.povxtile] - _b[1.clrsma`num'gsinv:5.povxtile]

}

log close

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------	

*drier conditions 

coefplot 		(me_dinter_clrsmal1gs, keep(1.clrsmal1gs:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsmal1gs, keep(1.clrsmal1gs:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsmal1gs, keep(1.clrsmal1gs:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsmal1gs, keep(1.clrsmal1gs:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsmal1gs, keep(1.clrsmal1gs:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("1 month") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white)) || ///
				(me_dinter_clrsma3gs, keep(1.clrsma3gs:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma3gs, keep(1.clrsma3gs:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma3gs, keep(1.clrsma3gs:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma3gs, keep(1.clrsma3gs:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma3gs, keep(1.clrsma3gs:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("3 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white)) || ///
				(me_dinter_clrsma6gs, keep(1.clrsma6gs:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma6gs, keep(1.clrsma6gs:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma6gs, keep(1.clrsma6gs:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma6gs, keep(1.clrsma6gs:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma6gs, keep(1.clrsma6gs:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("6 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white))|| ///
				(me_dinter_clrsma9gs, keep(1.clrsma9gs:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma9gs, keep(1.clrsma9gs:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma9gs, keep(1.clrsma9gs:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma9gs, keep(1.clrsma9gs:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma9gs, keep(1.clrsma9gs:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("9 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white))|| ///
				(me_dinter_clrsma12gs, keep(1.clrsma12gs:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma12gs, keep(1.clrsma12gs:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma12gs, keep(1.clrsma12gs:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma12gs, keep(1.clrsma12gs:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma12gs, keep(1.clrsma12gs:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("12 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white))|| ///
			, vertical norecycle legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4" 10 "Q5") col(5) size(small)) ///
			yline(0, lcolor(black) lpattern(dash)) ///
			ylabel(-0.1(0.05)0.1, grid labsize(medium) labcolor(black) tlcolor(gs5)) ///
			ylabel(, labsize(medium) labcolor(black) tlcolor(gs5)) ///
			yscale(lcolor(gs5)) ytitle("Probability to migrate") ///
			xlabel(none, glwidth(thin) labsize(medium) glpattern(dash) glcolor(gs12))  ///
			xscale(lcolor(gs5)) xtitle("Poverty quintiles") ///
			byopts(rows(1) title("Drier conditions", size(medium) color(black))) ///
			name(pov_bin_rev, replace)
				  
*wetter conditions	

coefplot 		(me_dinter_clrsmal1gsinv, keep(1.clrsmal1gsinv:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsmal1gsinv, keep(1.clrsmal1gsinv:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsmal1gsinv, keep(1.clrsmal1gsinv:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsmal1gsinv, keep(1.clrsmal1gsinv:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsmal1gsinv, keep(1.clrsmal1gsinv:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("1 month") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white)) || ///
				(me_dinter_clrsma3gsinv, keep(1.clrsma3gsinv:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma3gsinv, keep(1.clrsma3gsinv:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma3gsinv, keep(1.clrsma3gsinv:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma3gsinv, keep(1.clrsma3gsinv:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma3gsinv, keep(1.clrsma3gsinv:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("3 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white)) || ///
				(me_dinter_clrsma6gsinv, keep(1.clrsma6gsinv:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma6gsinv, keep(1.clrsma6gsinv:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma6gsinv, keep(1.clrsma6gsinv:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma6gsinv, keep(1.clrsma6gsinv:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma6gsinv, keep(1.clrsma6gsinv:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("6 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white))|| ///
				(me_dinter_clrsma9gsinv, keep(1.clrsma9gsinv:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma9gsinv, keep(1.clrsma9gsinv:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma9gsinv, keep(1.clrsma9gsinv:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma9gsinv, keep(1.clrsma9gsinv:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma9gsinv, keep(1.clrsma9gsinv:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("9 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white))|| ///
				(me_dinter_clrsma12gsinv, keep(1.clrsma12gsinv:1.povxtile) mcolor (black) ciopts(color(black))) ///
				(me_dinter_clrsma12gsinv, keep(1.clrsma12gsinv:2.povxtile) mcolor (gs4) ciopts(color(gs4))) ///
				(me_dinter_clrsma12gsinv, keep(1.clrsma12gsinv:3.povxtile) mcolor (gs6) ciopts(color(gs6))) ///
				(me_dinter_clrsma12gsinv, keep(1.clrsma12gsinv:4.povxtile) mcolor (gs8) ciopts(color(gs8))) ///
				(me_dinter_clrsma12gsinv, keep(1.clrsma12gsinv:5.povxtile) mcolor (gs10) ciopts(color(gs10))) ///
				, bylabel("12 months") subtitle(,fcolor(white) lcolor(white)) ///
				by(,graphregion(color(white)) bgcolor(white))|| ///
			, vertical norecycle legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4" 10 "Q5") col(5) size(small)) ///
			yline(0, lcolor(black) lpattern(dash)) ///
			ylabel(-0.1(0.05)0.1, grid labsize(medium) labcolor(black) tlcolor(gs5)) ///
			ylabel(, labsize(medium) labcolor(black) tlcolor(gs5)) ///
			yscale(lcolor(gs5)) ytitle("Probability to migrate") ///
			xlabel(none, glwidth(thin) labsize(medium) glpattern(dash) glcolor(gs12))  ///
			xscale(lcolor(gs5)) xtitle("Poverty quintiles") ///
			byopts(rows(1) title("Wetter conditions", size(medium) color(black))) ///
			name(pov_bin_inv_rev, replace)
			
graph 	combine pov_bin_inv_rev pov_bin_rev , ///
		col(1) graphregion(fcolor(white) lcolor(white)) imargin(medium)	  
graph export "output/figures/figure_08.pdf", replace 
