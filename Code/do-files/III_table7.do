
*-------------------------------------------------------------------------------------------
* Table 7
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table 7

********************************************************************************
* PANELS A, C, F & G
********************************************************************************

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------
									
egen sum=sum(cinter), by(_ID) 

gen log_pop_sum=ln(pop_sum) if pop_sum!=0

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

**number of migrants

foreach var in cinter {

  foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
		
	*Panel A: Excluding cells with a border
	xtnbreg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& border==0, iter(20) fe difficult
	eststo bor_`var'_`sma'
	
		}
	
}

foreach var in cinter {

  foreach sma in clrsmal1gs /*clrsma3gs*/ clrsma6gs clrsma9gs clrsma12gs {
  
	*Panel F: Population weights
	xtnbreg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	[iw=pop_sum], iter(20) fe difficult
	eststo pw_`var'_`sma'
	
			}
	
}

foreach var in cinter {

  foreach sma in clrsma3gs {
  
	*Panel F: Population weights
	xtnbreg `var' b2.`sma'  $control $fec if cropincell==1 & lrsma12gs!=. ///
	[iw=pop_sum], iter(20) fe difficult
	eststo pw_`var'_`sma'
	
			}
	
}

foreach var in cinter {

  foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
	
	*Panel G: Top 20\% populated cells
	xtnbreg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& popxtile5==5, iter(20) fe difficult
	eststo pq5_`var'_`sma'
	
	}
	
}

foreach var in cinter {

 foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
	 
	*Panel C: PPML model
	ppmlhdfe cinter  b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& sum!=0 , absorb(_ID) vce(r)
	eststo ppml_cinter_`sma'
	
	}	

}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

global top 		cells(b(star fmt(3) vacant("\multicolumn{1}{c}{--}") ///
				label(" "))  se(fmt(3) par label(" "))) varwidth(35) ///
				starlevels(^{*} 0.1 ^{**} 0.05 ^{***} 0.01) eqlabels(none) ///
				collabels(none) mlabels(none) ///
				drop(*country_share *.month *.year 0.*) 
			
global bottom 	s(N r2, fmt(%12.0fc %-9.3fc) labels("Observations" "R$^{2}$") ///
				layout(\multicolumn{1}{c}{@} @)) nonum ///
				prefoot(\addlinespace  Cell FE  			///
						&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
						&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
									\\ Month FE   			///
						&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
						&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
									\\ Country-by-year FE   ///
						&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
						&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
									\\  \midrule) ///
				postfoot(\bottomrule) style(tex)		
							
global labels 	varlabels(lrsma "SMA index" ///
				cellfmp_bin "FMP in cell" ///
				fmpbuff200km "FMP in 200km radius" ///
				lrsmal1gs "SMA index\$,_{1 month}\$" ///
				lrsma3gs "SMA index\$,_{3 months}\$" ///
				lrsma6gs "SMA index\$,_{6 months}\$" ///
				lrsma12gs "SMA index\$,_{12 months}\$" ///
				1.clrsma "\hspace*{1em}Drier than normal" ///
				3.clrsma "\hspace*{1em}Wetter than normal" ///
				shshock12 "1 std. dev."   ///
				shshock12_2d "2 std. dev."  ///
				shshock12gs "1 std. dev. g.s." /// 
				shshock12gs_2d "2 std. dev. g.s." ///
				1.growcrop "Growing season" ///
				1.growcrop#c.lrsma "SMA x Growing season" ///
				_cons "Constant")
			
global format  	cells(b(star fmt(3)) se(fmt(3) par)) ///
				s(N r2, fmt(%12.0fc %-9.3fc)) varwidth(35) ///
				indicate (/*"Cell FE = *_ID"*/ "Month FE = *month" ///
				"Country-by-year FE = *year*" ) ///
				drop(*country_share 0.*) 

global refcat 	refcat(1.cellfmp "\textit{Num. of FMPs Ref:. No FMP}" ///
				, label(" "))
						
global semitop 	cells(b(star fmt(3) vacant("\multicolumn{1}{c}{--}") ///
				label(" "))  se(fmt(3) par label(" "))) varwidth(35) ///
				starlevels(^{*} 0.1 ^{**} 0.05 ^{***} 0.01) ///
				eqlabels(none) collabels(none) mlabels(none) 
				
global semibottom 	s(N, fmt(%12.0fc) labels("Observations") ///
					layout(\multicolumn{1}{c}{@} @)) nonum style(tex)
						
global keep keep(lrsma*) dropped("\multicolumn{1}{c}{--}") 
	  			  
global order order(lrsma*)				   
				   				
global keep keep(1.clrsma* 3.clrsma*) dropped("\multicolumn{1}{c}{--}") 
	  			  
global order order(*clrsma*)				   
				   			
global rename rename(1.clrsmal1gs 1.clrsma ///
					 3.clrsmal1gs 3.clrsma ///
					 1.clrsma3gs 1.clrsma ///
					 3.clrsma3gs 3.clrsma ///
					 1.clrsma6gs 1.clrsma ///
					 3.clrsma6gs 3.clrsma ///
					 1.clrsma9gs 1.clrsma ///
					 3.clrsma9gs 3.clrsma ///
					 1.clrsma12gs 1.clrsma ///
					 3.clrsma12gs 3.clrsma )

global rename2 rename(1.clrsmal1 1.clrsma ///
					 3.clrsmal1 3.clrsma ///
					 1.clrsma3 1.clrsma ///
					 3.clrsma3 3.clrsma ///
					 1.clrsma6 1.clrsma ///
					 3.clrsma6 3.clrsma ///
					 1.clrsma9 1.clrsma ///
					 3.clrsma9 3.clrsma ///
					 1.clrsma12 1.clrsma ///
					 3.clrsma12 3.clrsma )
					 
local bor 	bor_cinter_clrsmal1gs bor_cinter_clrsma3gs bor_cinter_clrsma6gs ///
			bor_cinter_clrsma9gs bor_cinter_clrsma12gs
					 
estout 	`bor' using "output\tables\table_07a.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels

estout 	ppml_cinter_clrsma* using "output\tables\table_07c.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels  
		
local pw	pw_cinter_clrsmal1gs pw_cinter_clrsma3gs pw_cinter_clrsma6gs ///
			pw_cinter_clrsma9gs pw_cinter_clrsma12gs		
		
estout 	`pw' using "output\tables\table_07f.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 

local pq5	pq5_cinter_clrsmal1gs pq5_cinter_clrsma3gs pq5_cinter_clrsma6gs ///
			pq5_cinter_clrsma9gs pq5_cinter_clrsma12gs
			
estout 	`pq5' using "output\tables\table_07g.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 
		
********************************************************************************
* PANEL B
********************************************************************************

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_1by1_sample.dta", clear

*-------------------------------------------------------------------------------
* Globals
*-------------------------------------------------------------------------------

global control  cellfmp_bin fmpbuff200km /*i.growcrop*/
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

**number of migrants

foreach var in cinter {

	foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {

	*Panel B: Grid size 1x1
	xtnbreg `var' b2.`sma'  $control $fe if ///
	cropincell==1 & lrsma12gs!=., iter(20) fe difficult
	eststo rob_`var'_`sma'
	
	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

estout rob_cinter_clrsma* using "output\tables\table_07b.txt", ///
replace $rename $refcat $semitop $semibottom $keep $labels


********************************************************************************
* PANEL D
********************************************************************************

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample_rain.dta", clear

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

**number of migrants 

foreach var in cinter {

	foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {

	*Panel D: Current weather controls
	xtnbreg `var' b2.`sma' lntemp lnprec  $control $fe ///
	if cropincell==1 & lrsma12gs!=.,  iter(20) fe difficult
	eststo prectemp_`var'_`sma'
	
	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

estout prectemp_c* using "output\tables\table_07d.txt", ///
replace $rename $refcat $semitop $semibottom ///
keep(1.clrsma* 3.clrsma*) dropped("\multicolumn{1}{c}{--}")  $labels 
	
********************************************************************************
* PANEL E
********************************************************************************

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample_20ySMA.dta", clear

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

**number of migrants

foreach var in cinter {

	foreach sma in csmal1gs csma3gs csma6gs /*csma9gs*/ csma12gs {

	*Panel E: SMA based on past 20 years
	xtnbreg `var' b2.`sma' $control $fe if cropincell==1 & sma12gs!=., ///
	iter(20) fe difficult
	eststo twentySMA_`var'_`sma'
		
	}
	
}

foreach var in cinter {

	foreach sma in csma9gs {

	*Panel E: SMA based on past 20 years
	xtnbreg `var' b2.`sma' $control $fe if cropincell==1 & sma12gs!=., ///
	iter(13) fe difficult
	eststo twentySMA_`var'_`sma'
		
	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------
					 					 				
global labels20 varlabels(lrsma "SMA index" ///
				cellfmp_bin "FMP in cell" ///
				fmpbuff200km "FMP in 200km radius" ///
				smal1gs "SMA index\$,_{1 month}\$" ///
				sma3gs "SMA index\$,_{3 months}\$" ///
				sma6gs "SMA index\$,_{6 months}\$" ///
				sma12gs "SMA index\$,_{12 months}\$" ///
				1.csma "\hspace*{1em}Drier than normal" ///
				3.csma "\hspace*{1em}Wetter than normal" ///
				shshock12 "1 std. dev."   ///
				shshock12_2d "2 std. dev."  ///
				shshock12gs "1 std. dev. g.s." /// 
				shshock12gs_2d "2 std. dev. g.s." ///
				1.growcrop "Growing season" ///
				1.growcrop#c.lrsma "SMA x Growing season" ///
				_cons "Constant")
								
global keep20 keep(sma*) dropped("\multicolumn{1}{c}{--}") 
	  			  
global order order(sma*)				   
				   				
global keep20 keep(1.csma* 3.csma*) dropped("\multicolumn{1}{c}{--}") 
	  			  
global order order(*csma*)				   
				   			
global rename20 rename(1.csmal1gs 1.csma ///
					 3.csmal1gs 3.csma ///
					 1.csma3gs 1.csma ///
					 3.csma3gs 3.csma ///
					 1.csma6gs 1.csma ///
					 3.csma6gs 3.csma ///
					 1.csma9gs 1.csma ///
					 3.csma9gs 3.csma ///
					 1.csma12gs 1.csma ///
					 3.csma12gs 3.csma )

global rename220 rename(1.csmal1 1.csma ///
					 3.csmal1 3.csma ///
					 1.csma3 1.csma ///
					 3.csma3 3.csma ///
					 1.csma6 1.csma ///
					 3.csma6 3.csma ///
					 1.csma9 1.csma ///
					 3.csma9 3.csma ///
					 1.csma12 1.csma ///
					 3.csma12 3.csma )

local twentySMA 	twentySMA_cinter_csmal1gs twentySMA_cinter_csma3gs ///
					twentySMA_cinter_csma6gs twentySMA_cinter_csma9gs ///
					twentySMA_cinter_csma12gs
					
estout 	`twentySMA' using "output\tables\table_07e.txt", ///
		replace $rename20 $refcat $semitop $semibottom $keep20 $labels20 				 
