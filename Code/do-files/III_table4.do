
*-------------------------------------------------------------------------------------------
* Table 4
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table 4

********************************************************************************
* PANELS A - E
********************************************************************************

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample.dta", clear

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------

*indicator for cells in countries with at least one FMP

gen onlyfmp=1 if 	country_share==5 | country_share==9 | country_share==19 | ///
					country_share==28 | country_share==33 | country_share==34 | ///
					country_share==37 

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

foreach var in dmove {

	foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
	
	*Panel A: On the move
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo rob_`var'_`sma'
	
	}
	
}

foreach var in dinter {

	foreach sma in clrsmal1gs clrsma3gs clrsma6gs clrsma9gs clrsma12gs {
	
	*Panel B: No FMP in a 200 km buffer
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& fmpbuff200km==0, absorb(_ID) $se
	eststo nofmp_`var'_`sma'
		
	*Panel C: Only countries with an FMP
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& onlyfmp==1, absorb(_ID) $se
	eststo onlyfmp_`var'_`sma'
	
	*Panel D: Excluding countries with likely data limitations
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& (country_share!=7 & country_share!=19 & country_share!=38), absorb(_ID) $se
	eststo neg_`var'_`sma'
	
	*Panel E: Excluding Nigeria
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. ///
	& country_share!=34, absorb(_ID) $se
	eststo nonig_`var'_`sma'
	
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
					 					 
estout 	rob_dmove_clrsma* using "output\tables\table_04a.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 

estout 	nofmp_dinter_clrsma* using "output\tables\table_04b.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 

estout 	onlyfmp_dinter_clrsma* using "output\tables\table_04c.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels  

estout 	neg_dinter_clrsma* using "output\tables\table_04d.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 
		
estout 	nonig_dinter_clrsma* using "output\tables\table_04e.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels  
						
********************************************************************************
* PANEL F
********************************************************************************

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample_50percent.dta", clear

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
	
	*Panel F: FMPs with best coverage of departure location information
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo percent_`var'_`sma'
	
	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------
			 					 
estout 	percent_dinter_clrsma* using "output\tables\table_04f.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 
		
********************************************************************************
* PANEL G
********************************************************************************

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month_sample_jan18dec19.dta", clear

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
	
	*Panel G: FMPs open Jan 2018 - Dec 2019
	areg `var' b2.`sma'  $control $fe if cropincell==1 & lrsma12gs!=. , ///
	absorb(_ID) $se
	eststo jandec_`var'_`sma'
	
	}
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------
			 					 
estout 	jandec_dinter_clrsma* using "output\tables\table_04g.txt", ///
		replace $rename $refcat $semitop $semibottom $keep $labels 

