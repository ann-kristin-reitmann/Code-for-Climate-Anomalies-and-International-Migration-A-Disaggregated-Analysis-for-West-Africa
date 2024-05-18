
*-------------------------------------------------------------------------------------------
* Figure 10
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure 10

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear

*-------------------------------------------------------------------------------
* Globals
*-------------------------------------------------------------------------------

global control  cellfmp_bin fmpbuff200km 
global fe		i.month i.year##i.country_share
global fec		i.month c.year##i.country_share
global se   	vce(cluster _ID)

*-------------------------------------------------------------------------------
* Regressions
*-------------------------------------------------------------------------------

eststo clear

*set fixed effects

xtset _ID 

*categorical climate anolamies only for cells with crops

**probability to migrate

foreach var in dafric deuro {

	foreach depvar in 	clrsmal1gs clrsma2gs clrsma3gs clrsma4gs ///
						clrsma5gs clrsma6gs clrsma7gs clrsma8gs clrsma9gs ///
						clrsma10gs clrsma11gs clrsma12gs {
	 
	areg `var' b2.`depvar'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo rob_`var'_`depvar'
	
	}
	
}

**number of migrants

foreach var in cafric {

	foreach depvar in 	clrsmal1gs clrsma2gs clrsma3gs clrsma4gs ///
						clrsma5gs clrsma6gs clrsma7gs clrsma8gs clrsma9gs ///
						clrsma10gs clrsma11gs clrsma12gs {
	 
	xtnbreg `var' b2.`depvar'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	iter(20) fe difficult
	eststo rob_`var'_`depvar'
	
	}
	
}

foreach var in ceuro {

	foreach depvar in 	clrsmal1gs clrsma2gs clrsma3gs clrsma4gs ///
						clrsma5gs clrsma6gs clrsma7gs clrsma8gs clrsma9gs ///
						clrsma10gs clrsma11gs clrsma12gs {
	 
	xtnbreg `var' b2.`depvar'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	iter(20) fe difficult
	eststo rob_`var'_`depvar'
	
	}
	
}

/*clrsma2gs not converging for now, we use c.year##i.country_share

foreach var in ceuro {

	foreach depvar in 	clrsma2gs {
	 
	xtnbreg `var' b2.`depvar'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	iter(50) fe difficult
	eststo rob_`var'_`depvar'
	
	}
	
}*/

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

*graph style locals 

local color yline(0, lcolor(black) lpattern(dash)) ///
			graphregion(fcolor(white) lcolor(white)) ///
			plotregion(fcolor(white) lcolor(white))
local grid 	xlabel(, glwidth(thin) glpattern(dash) glcolor(gs12)) ///
			legend(region(lwidth(none)))
local axis 	ylabel(" ", labsize(medium) labcolor(black) tlcolor(gs5)) ///
			ylabel(, labsize(medium) labcolor(gs5) tlcolor(gs5)) ///
			yscale(lcolor(gs5)) xscale(lcolor(gs5)) 	

**probability to migrate

local deuro 	rob_deuro_clrsmal1gs rob_deuro_clrsma2gs rob_deuro_clrsma3gs ///
				rob_deuro_clrsma4gs rob_deuro_clrsma5gs rob_deuro_clrsma6gs ///
				rob_deuro_clrsma7gs rob_deuro_clrsma8gs rob_deuro_clrsma9gs ///
				rob_deuro_clrsma10gs rob_deuro_clrsma11gs rob_deuro_clrsma12gs
	  
local dafric 	rob_dafric_clrsmal1gs rob_dafric_clrsma2gs rob_dafric_clrsma3gs ///
				rob_dafric_clrsma4gs rob_dafric_clrsma5gs rob_dafric_clrsma6gs ///
				rob_dafric_clrsma7gs rob_dafric_clrsma8gs rob_dafric_clrsma9gs ///
				rob_dafric_clrsma10gs rob_dafric_clrsma11gs rob_dafric_clrsma12gs

*drier conditions 

coefplot 	(`deuro', keep(1.clrsma*) label("Europe")  mcolor(black) ///
			ciopts(lcolor(black)) offset(-0.3)) (`dafric', keep(1.clrsma*) ///
			label("Intra-regional") mcolor(gs8) ciopts(lcolor(gs8))) ,  ///	 
			rename(1.clrsmal1gs=1 1.clrsma2gs=2 1.clrsma3gs=3 1.clrsma4gs=4 ///
				1.clrsma5gs=5 1.clrsma6gs=6 1.clrsma7gs=7 1.clrsma8gs=8 ///
				1.clrsma9gs=9 1.clrsma10gs=10 1.clrsma11gs=11 1.clrsma12gs=12) ///
			vertical ytitle("Probability to migrate") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.04,.04)) ylabel(-.04(.02).04) ///
			title("Drier conditions", size(medium) color(black)) ///
			name("dry1", replace)
						
*wetter conditions
		
coefplot 	(`deuro', keep(3.clrsma*) label("Europe")  mcolor(black) ///
			ciopts(lcolor(black)) offset(-0.3)) (`dafric', keep(3.clrsma*) ///
			label("Intra-regional") mcolor(gs8) ciopts(lcolor(gs8))) ,  ///	 
			rename(3.clrsmal1gs=1 3.clrsma2gs=2 3.clrsma3gs=3 3.clrsma4gs=4 ///
				3.clrsma5gs=5 3.clrsma6gs=6 3.clrsma7gs=7 3.clrsma8gs=8 ///
				3.clrsma9gs=9 3.clrsma10gs=10 3.clrsma11gs=11 3.clrsma12gs=12) ///
			vertical ytitle("Probability to migrate") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.04,.04)) ylabel(-.04(.02).04)  ///
			title("Wetter conditions", size(medium) color(black)) ///
			name("wet1", replace)

**number of migrants
	
local ceuro 	rob_ceuro_clrsmal1gs rob_ceuro_clrsma2gs rob_ceuro_clrsma3gs ///
				rob_ceuro_clrsma4gs rob_ceuro_clrsma5gs rob_ceuro_clrsma6gs ///
				rob_ceuro_clrsma7gs rob_ceuro_clrsma8gs rob_ceuro_clrsma9gs ///
				rob_ceuro_clrsma10gs rob_ceuro_clrsma11gs rob_ceuro_clrsma12gs
	  
local cafric 	rob_cafric_clrsmal1gs rob_cafric_clrsma2gs rob_cafric_clrsma3gs ///
				rob_cafric_clrsma4gs rob_cafric_clrsma5gs rob_cafric_clrsma6gs ///
				rob_cafric_clrsma7gs rob_cafric_clrsma8gs rob_cafric_clrsma9gs ///
				rob_cafric_clrsma10gs rob_cafric_clrsma11gs rob_cafric_clrsma12gs

*drier conditions 
				
coefplot 	(`ceuro', keep(1.clrsma*) label("Europe")  mcolor(black) ///
			ciopts(lcolor(black)) offset(-0.3)) (`cafric', keep(1.clrsma*) ///
			label("Intra-regional") mcolor(gs8) ciopts(lcolor(gs8))) , ///	 
			rename(1.clrsmal1gs=1 1.clrsma2gs=2 1.clrsma3gs=3 1.clrsma4gs=4 ///
				1.clrsma5gs=5 1.clrsma6gs=6 1.clrsma7gs=7 1.clrsma8gs=8 ///
				1.clrsma9gs=9 1.clrsma10gs=10 1.clrsma11gs=11 1.clrsma12gs=12) ///
			vertical ytitle("Number of migrants") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.6,.6)) ylabel(-.6(.2).6)  ///
			title("Drier conditions", size(medium) color(black)) ///
			name("dry2", replace)
		  
*wetter conditions		
				
coefplot 	(`ceuro', keep(3.clrsma*) label("Europe")  mcolor(black) ///
			ciopts(lcolor(black)) offset(-0.3)) (`cafric', keep(3.clrsma*) ///
			label("Intra-regional") mcolor(gs8) ciopts(lcolor(gs8))) ,  ///	 
			rename(3.clrsmal1gs=1 3.clrsma2gs=2 3.clrsma3gs=3 3.clrsma4gs=4 ///
				3.clrsma5gs=5 3.clrsma6gs=6 3.clrsma7gs=7 3.clrsma8gs=8 ///
				3.clrsma9gs=9 3.clrsma10gs=10 3.clrsma11gs=11 3.clrsma12gs=12) ///
			vertical ytitle("Number of migrants") xtitle("Number of months") ///
			`color' `coeff' `grid' yscale(r(-.6,.6)) ylabel(-.6(.2).6)  ///
			title("Wetter conditions", size(medium) color(black)) ///
			name("wet2", replace)
						
graph 	combine wet1 dry1 wet2 dry2 , col(2) ///
		graphregion(fcolor(white) lcolor(white)) imargin(medium) ysize(3) 
graph export "output/figures/figure_10.pdf", replace 	
