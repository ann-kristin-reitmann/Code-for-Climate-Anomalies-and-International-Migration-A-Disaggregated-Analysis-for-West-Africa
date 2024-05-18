
*-------------------------------------------------------------------------------------------
* Table 5
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table 5

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

*indicator to exclude cells with only zeros
					
egen sum=sum(cinter), by(_ID) 

gen log_pop_sum=ln(pop_sum) if pop_sum!=0

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
	
	*Panel A: Excluding cells with a border
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& border==0 , absorb(_ID) $se
	eststo bor_`var'_`sma'
	
	*Panel F: Population weights
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	[aw=pop_sum], absorb(_ID) $se
	eststo pw_`var'_`sma'
	
	*Panel G: Top 20% populated cells
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& popxtile5==5, absorb(_ID) $se
	eststo pq5_`var'_`sma'
		
	}
	
}

 foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
 
	sort _ID myear 
	set seed 1234567
	
	*Panel C: Logit model
	xtlogit dinter  b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& sum!=0 , fe vce(boot)
	eststo log_dinter_`sma'
	eststo me_dinter_`sma': margins, dydx(`sma') vsquish noestimcheck post
	
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
					 					 				
estout 	bor_dinter_clrsma* using "output\tables\table_05a.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 
		
estout 	me_dinter_clrsma* using "output\tables\table_05c.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels  

estout 	pw_dinter_clrsma* using "output\tables\table_05f.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 

estout 	pq5_dinter_clrsma* using "output\tables\table_05g.txt", ///
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

global control  cellfmp_bin fmpbuff200km
global fe		i.month i.year##i.country_share
global se   	vce(cluster _ID)

*-------------------------------------------------------------------------------
* Regressions
*-------------------------------------------------------------------------------

eststo clear

*set fixed effects

xtset _ID /*myear*/

*categorical climate anolamies only for cells with crops

**probability to migrate

foreach var in dinter {

  foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
  
	sort _ID myear 
	set seed 1234567
	
	*Panel B: Grid size 1x1
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo rob_`var'_`sma'
	
	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------
					 					 
estout rob_dinter_clrsma* using "output\tables\table_05b.txt", ///
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

**probability to migrate

foreach var in dinter {

	foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
	
	*Panel D: Current weather controls
	areg `var' b2.`sma' lntemp lnprec  $control $fe if ///
	cropincell==1 & lrsma12gs!=. , absorb(_ID) $se
	eststo prectemp_`var'_`sma'

	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

estout prectemp_d* using "output\tables\table_05d.txt", ///
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

**probability to migrate

foreach var in dinter {

	foreach sma in csmal1gs csma3gs csma6gs csma9gs csma12gs {

	*Panel E: SMA based on past 20 years 
	areg `var' b2.`sma'  $control $fe if cropincell==1 & sma12gs!=. ///
	, absorb(_ID) $se
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
	
estout 	twentySMA_dinter_csma* using "output\tables\table_05e.txt", ///
		replace $rename20 $refcat $semitop $semibottom $keep20 $labels20 

********************************************************************************
* PANEL H
********************************************************************************

*run regressions taking into account spatial correlation 

*-------------------------------------------------------------------------------
* Data (prep)
*-------------------------------------------------------------------------------

*import centroids for the cells 

import delimited using "data/shapefiles/Africa5x5/id_centroids.csv", clear
rename id _ID 
save "data/id_centroids.dta", replace 

*load data 

use "data/final_cell_5by5_month_sample.dta", clear
merge m:1 _ID using "data/id_centroids.dta"
drop if _merge==2
drop _merge 

eststo clear

xtset _ID 

capture noisily do "do-files/ado/reg2hdfespatial-id1id2.ado" 
capture noisily do "do-files/ado/ols_spatial_HAC.ado" 

*you need to update the path after runing the ado files
 
 if  "`c(username)'" == "" {

 cd ""
}

 else if "`c(username)'" == "" {
 cd ""

 }

*generate control variables because the command does not accept i. 
  
tab cellfmp, gen(dcellfmp)
egen countryby=group(year country_share)
tab countryby, gen(dcby)

*-------------------------------------------------------------------------------
* Globals
*-------------------------------------------------------------------------------

global control  cellfmp_bin fmpbuff200km
global fe		dcby*

*-------------------------------------------------------------------------------
* Regressions
*-------------------------------------------------------------------------------

eststo clear

*set fixed effects

xtset _ID 

*categorical climate anolamies only for cells with crops

**probability to migrate

foreach var in 	clrsmal1gs clrsma2gs clrsma3gs clrsma4gs clrsma5gs ///
				clrsma6gs clrsma7gs clrsma8gs clrsma9gs clrsma10gs ///
				clrsma11gs clrsma12gs {
				
	tab `var', gen(d`var')
	
	}

***200 km spatial correlation 

foreach sma in clrsmal1gs  clrsma3gs  clrsma6gs clrsma9gs  clrsma12gs {
	
	*Panel H: Spatial correlation
	reg2hdfespatial dinter d`sma'1 d`sma'3 $control $fe if ///
	cropincell==1 & lrsma12gs!=., timevar(month) panelvar(_ID) ///
	lat(ycoord) lon(xcoord) distcutoff(200) lagcutoff(12)
	eststo spa_`sma'_200

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
				
global 	semibottom s(N, fmt(%12.0fc) labels("Observations") ///
		layout(\multicolumn{1}{c}{@} @)) nonum style(tex)
						
global keep keep(lrsma*) dropped("\multicolumn{1}{c}{--}") 
	  			  
global order order(lrsma*)				   
				   		
global keep keep(1.clrsma* 3.clrsma*) dropped("\multicolumn{1}{c}{--}") 
	  			  
global order order(*clrsma*)				   
				   					
global labels 	varlabels(lrsma "SMA index" ///
							cellfmp_bin "FMP in cell" ///
							fmpbuff200km "FMP in 200km radius" ///
							lrsmal1 "SMA index\$,_{1 month}\$" ///
							lrsma3 "SMA index\$,_{3 months}\$" ///
							lrsma6 "SMA index\$,_{6 months}\$" ///
							lrsma12 "SMA index\$,_{12 months}\$" ///
							lrsma12gs "SMA index\$,_{12 months g.s.}\$" ///
							1.clrsma "\hspace*{1em}Drier than normal" ///
							3.clrsma "\hspace*{1em}Wetter than normal" ///
							shshock12 "1 std. dev."   ///
							shshock12_2d "2 std. dev."  ///
							shshock12gs "1 std. dev. g.s." /// 
							shshock12gs_2d "2 std. dev. g.s." ///
							1.growcrop "Growing season" ///
							1.growcrop#c.lrsma "SMA x Growing season" ///
							_cons "Constant")
							
global rename rename(dclrsmal1gs1 1.clrsma ///
					 dclrsmal1gs3 3.clrsma ///
					 dclrsma3gs1 1.clrsma ///
					 dclrsma3gs3 3.clrsma ///
					 dclrsma6gs1 1.clrsma ///
					 dclrsma6gs3 3.clrsma ///
					 dclrsma9gs1 1.clrsma ///
					 dclrsma9gs3 3.clrsma ///
					 dclrsma12gs1 1.clrsma ///
					 dclrsma12gs3 3.clrsma )
					 
estout spa_*_200 using "output\tables\table_05h.txt", ///
replace $rename $refcat $semitop $semibottom $keep $labels 
