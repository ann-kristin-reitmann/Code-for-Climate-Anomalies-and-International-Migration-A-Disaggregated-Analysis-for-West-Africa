
*-------------------------------------------------------------------------------------------
* Table 2
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table 2

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_quarter.dta", clear

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------

gen cellfmp_bin=.
replace cellfmp_bin=1 if cellfmp==1 | cellfmp==2
replace cellfmp_bin=0 if cellfmp==0
label var cellfmp_bin "FMP in cell"

*-------------------------------------------------------------------------------
* Globals
*-------------------------------------------------------------------------------

global control  cellfmp_bin fmpbuff200km
global fe		i.quarter i.year##i.country_share
global se   	vce(cluster _ID)

*-------------------------------------------------------------------------------
* Regressions
*-------------------------------------------------------------------------------

eststo clear

*set fixed effects

xtset _ID yq

*categorical climate anolamies only for cells with crops

**probability to migrate

local lag0  b2.cqlrsma 
local lag1  b2.cqlrsma  	l1b2.cqlrsma 
local lag2  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 
local lag3  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma  
local lag4  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma ///
			l4b2.cqlrsma
local lag5  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma ///
			l4b2.cqlrsma	l5b2.cqlrsma	
local lag6  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma ///
			l4b2.cqlrsma	l5b2.cqlrsma	l6b2.cqlrsma
local lag7  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma /// 	
			l4b2.cqlrsma	l5b2.cqlrsma	l6b2.cqlrsma	l7b2.cqlrsma
local lag8  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma ///	
			l4b2.cqlrsma	l5b2.cqlrsma	l6b2.cqlrsma	l7b2.cqlrsma ///
			l8b2.cqlrsma

***indicator to restrict sample 

	forvalues i=0(1)8 {
  
  	areg qdinternational `lag`i''  $control $fe if cropincell==1, ///
	absorb(_ID) $se
	gen flag`i'=1 if e(sample)

	}

	forvalues i=0(1)3 {
  
  	areg qdinternational `lag`i''  $control $fe if cropincell==1 & flag3==1, ///
	absorb(_ID) $se
	eststo qcat_lag`i'_crop
	
	}

**number of migrants
	
local lag0  b2.cqlrsma 
local lag1  b2.cqlrsma  	l1b2.cqlrsma 
local lag2  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 
local lag3  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma  
local lag4  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma /// 	
			l4b2.cqlrsma
local lag5  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma /// 	
			l4b2.cqlrsma	l5b2.cqlrsma	
local lag6  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma /// 	
			l4b2.cqlrsma	l5b2.cqlrsma	l6b2.cqlrsma
local lag7  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma /// 	
			l4b2.cqlrsma	l5b2.cqlrsma	l6b2.cqlrsma	l7b2.cqlrsma
local lag8  b2.cqlrsma  	l1b2.cqlrsma  	l2b2.cqlrsma 	l3b2.cqlrsma ///	
			l4b2.cqlrsma	l5b2.cqlrsma	l6b2.cqlrsma	l7b2.cqlrsma ///	
			l8b2.cqlrsma

***indicator to restrict sample  
 	
	forvalues i=0(1)8 {
 
	xtnbreg   qinternational `lag`i''  $control $fe if cropincell==1, ///
	iter(20) fe difficult
 	gen xflag`i'=1 if e(sample)
  
	}	

	forvalues i=0(1)3 {

	xtnbreg   qinternational `lag`i''  $control $fe if cropincell==1 & xflag8==1, /// 
	iter(20) fe difficult
	eststo  xqreg_lag`i'_crop
  
	}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

global 	semitop 	cells(b(star fmt(3) vacant("\multicolumn{1}{c}{--}") ///
					label(" ")) se(fmt(3) par label(" "))) varwidth(35) ///
					starlevels(^{*} 0.1 ^{**} 0.05 ^{***} 0.01) ///
					eqlabels(none) collabels(none) mlabels(none) 
				
global 	semibottom 	s(N, fmt(%12.0fc) labels("Observations") ///
					layout(\multicolumn{1}{c}{@} @)) nonum ///
					style(tex)
		
global 	labels 		varlabels (1.cqlrsma "\hspace*{1em}Drier conditions" ///
					3.cqlrsma "\hspace*{1em}Wetter conditions" ///
					1L.cqlrsma "\hspace*{1em}Drier conditions$ _{q-1}$" ///
					3L.cqlrsma "\hspace*{1em}Wetter conditions$ _{q-1}$" ///
					1L2.cqlrsma "\hspace*{1em}Drier conditions$ _{q-2}$" ///
					3L2.cqlrsma "\hspace*{1em}Wetter conditions$ _{q-2}$" ///
					1L3.cqlrsma "\hspace*{1em}Drier conditions$ _{q-3}$" ///
					3L3.cqlrsma "\hspace*{1em}Wetter conditions$ _{q-3}$") 
	
global 	refcat 		refcat(1.cqlrsma "\textit{SMA Ref:. Normal conditions}" ///
					1L.cqlrsma "\textit{SMA Ref:. Normal conditions\$ _{q-1}$}" ///
					1L2.cqlrsma "\textit{SMA Ref:. Normal conditions\$ _{q-2}$}" ///
					1L3.cqlrsma  "\textit{SMA Ref:. Normal conditions\$ _{q-3}$}" ///
					, label(" "))
	
estout 	qcat_lag0_crop qcat_lag1_crop qcat_lag2_crop qcat_lag3_crop ///
		using "output\tables\table_02a.txt", ///
		replace $rename $refcat $semitop $semibottom keep(*lrsma) drop(2*) $labels

estout 	xqreg_lag0_crop  xqreg_lag1_crop  xqreg_lag2_crop  xqreg_lag3_crop ///
		using "output\tables\table_02b.txt", ///
		replace $rename $refcat $semitop $semibottom keep(*lrsma) drop(2*) $labels 
