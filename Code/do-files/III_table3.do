
*-------------------------------------------------------------------------------------------
* Table 3
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table 3

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

*intensity of shock

**probability to migrate

foreach var in dinter {

	foreach sma in shshock12 shshock12gs shshock12nogs {
  
	*all months, growing months and non-growing months
	areg `var' c.`sma' $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo res_`var'_`sma'
	
	*irrigation cells
	areg `var' c.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& irrdummy==1, absorb(_ID) $se
	eststo irr_`var'_`sma'
	
	*no irrigation cells
	areg `var' c.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& irrdummy==0, absorb(_ID) $se
	eststo noirr_`var'_`sma'
	
	}
	
	*no crop cells
	areg `var' c.shshock12  $control $fe if cropincell==0, absorb(_ID) $se
	eststo nocrop_`var'_shshock12
	
}

**number of migrants

foreach var in cinter  {

	foreach sma in shshock12 shshock12gs  shshock12nogs {
 
	*all months, growing months and non-growing months
	xtnbreg `var' c.`sma' $control $fe if cropincell==1 & lrsma12gs!=. , ///
	iter(20) fe difficult
	eststo res_`var'_`sma'
	
	*irrigation cells
	xtnbreg `var' c.`sma' $control $fe if cropincell==1 & lrsma12gs!=. ///
	& irrdummy==1, iter(20) fe difficult
	eststo irr_`var'_`sma'
	
	*no-irrigation cells
	xtnbreg `var' c.`sma' $control $fe if cropincell==1 & lrsma12gs!=. ///
	& irrdummy==0 , iter(20) fe difficult
	eststo no_irr`var'_`sma'

	}
	
	*no crop cells
	xtnbreg `var' c.shshock12  $control $fe if cropincell==0, iter(20) fe ///
	difficult
	eststo nocrop_`var'_shshock12

}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

global refcat 	refcat(1.cellfmp "\textit{Num. of FMPs Ref:. No FMP}" ///
				, label(" "))
							
global semitop 	cells(b(star fmt(3) vacant("\multicolumn{1}{c}{--}") ///
				label(" "))  se(fmt(3) par label(" "))) varwidth(35) ///
				starlevels(^{*} 0.1 ^{**} 0.05 ^{***} 0.01) eqlabels(none) ///
				collabels(none) mlabels(none) 
				
global semibottom 	s(N, fmt(%12.0fc) labels("Observations") ///
					layout(\multicolumn{1}{c}{@} @)) nonum style(tex)				
				
global labels 	varlabels(lrsma "SMA index" lrsmags "SMA index g.s." ///
							cellfmp_bin "FMP in cell" ///
							fmpbuff200km "FMP in 200km radius" ///
							lrsmal1 "SMA index\$,_{1 month}\$" ///
							lrsma3 "SMA index\$,_{3 months}\$" ///
							lrsma6 "SMA index\$,_{6 months}\$" ///
							lrsma9 "SMA index\$,_{9 months}\$" ///
							lrsma12 "SMA index\$,_{12 months}\$" ///
							lrsmal1gs "SMA index\$,_{1 month,g.s.}\$" ///
							lrsma3gs "SMA index\$,_{3 months,g.s.}\$" ///
							lrsma6gs "SMA index\$,_{6 months,g.s.}\$" ///
							lrsma12gs "SMA index\$,_{12 months,g.s.}\$" ///
							shshock12 "Intensity >1sd$^{a}$"   ///
							shshock12gs "Intensity >1sd$^{a}$" /// 
							1.growcrop "Growing season" 1.growcrop#c.lrsma ///
							"SMA x Growing season" _cons "Constant")
			
global keep 	keep(shshock*) rename(shshock12gs shshock12 ///
				shshock12nogs shshock12  ///
				shshock12gs_2d  shshock12_2d ///
				shshock12nogs_2d  shshock12_2d) dropped("\multicolumn{1}{c}{--}") 
	  			  
**probability to migrate

estout 	res_dinter_shshock* ///
		nocrop_dinter_shshock12 ///
		noirr_dinter_shshock12gs ///
		irr_dinter_shshock12gs  ///
		using "output\tables\table_03a.txt", ///
		replace  $refcat $semitop $semibottom $keep $labels 
		// I include cinter as a trick to let the last column empty (as non estimable)

**total migration 

estout 	res_cinter_shshock* ///
		nocrop_cinter_shshock12 ///
		no_irrcinter_shshock12gs ///
		irr_cinter_shshock12gs  ///
		using "output\tables\table_03b.txt", ///
		replace $refcat $semitop $semibottom $keep $labels  
