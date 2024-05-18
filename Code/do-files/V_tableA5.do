
*-------------------------------------------------------------------------------------------
* Table A5
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table A5

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use  "data/final_cell_5by5_yearly.dta", clear

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------

gen dsumshockgs=sumshockgs 
replace dsumshockgs=1 if dsumshockgs>=1 

gen catshmonths=0 if sumshmonths==0
replace  catshmonths=1 if sumshmonths>0 & sumshmonths<=.25
replace  catshmonths=2 if sumshmonths>.25 & sumshmonths<=.5
replace  catshmonths=3 if sumshmonths>.5 & sumshmonths<=.75
replace  catshmonths=4 if sumshmonths>.75 & sumshmonths<=1

tab  catshmonths, gen(dryper)		

gen dry25plus=dsumshockgs
replace dry25plus=0 if sumshmonths<=.25 

gen dry50plus=dsumshockgs
replace dry50plus=0 if sumshmonths<=.5 

gen dry75plus=dsumshockgs
replace dry75plus=0 if sumshmonths<=.75 

gen dry25pluslag=l1.dry25plus

*FMP binary variable

gen cellfmp_bin=.
replace cellfmp_bin=1 if cellfmp==1 | cellfmp==2
replace cellfmp_bin=0 if cellfmp==0
label var cellfmp_bin "FMP in cell"

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

xtset _ID year

*share of dry growing season months

**number of migrants

xtnbreg yinternational sumshmonths ///
		$control $fe if cropincell==1, iter(20) fe difficult
eststo 	shmonths1
		
xtnbreg yinternational sumshmonths l1.sumshmonths ///
		$control $fe if cropincell==1, iter(20) fe difficult
eststo 	shmonths2
		
xtnbreg yinternational sumshmonths l1.sumshmonths l2.sumshmonths ///
		$control $fe if cropincell==1, iter(20) fe difficult
eststo 	shmonths3
		
xtnbreg yinternational dry25plus ///
		$control $fe if cropincell==1, iter(20) fe difficult
eststo 	shockgs1_25

xtnbreg yinternational dry25plus l1.dry25plus ///
		$control $fe if cropincell==1, iter(20) fe difficult
eststo 	shockgs2_25
		
xtnbreg yinternational dry25plus l1.dry25plus l2.dry25plus ///
		$control $fe if cropincell==1, iter(20) fe difficult
eststo 	shockgs3_25

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

global semitop 	cells(b(star fmt(3) vacant("\multicolumn{1}{c}{--}") ///
				label(" "))  se(fmt(3) par label(" "))) varwidth(35) ///
				starlevels(^{*} 0.1 ^{**} 0.05 ^{***} 0.01) eqlabels(none) ///
				collabels(none) mlabels(none) 
				
global semibottom 	s(N, fmt(%12.0fc) labels("Observations") ///
					layout(\multicolumn{1}{c}{@} @)) nonum style(tex)
		
global rename rename(1.dry25plus dry25plus 1.dry25pluslag dry25pluslag)

global labels 	varlabels(sumshmonths "Share of dry g.s. months" ///
				L.sumshmonths "Share of dry g.s. months$ _{t-1}$" ///
				L2.sumshmonths "Share of dry g.s. months$ _{t-2}$" ///
				dry25plus "$+25\%$ dry g.s. months" ///
				L.dry25plus "$+25\%$ dry g.s months\$ _{t-1}$" ///
				L2.dry25plus "$+25\%$ dry g.s months\$ _{t-2}$" ///
				1.dry25plus#1.dry25pluslag "$+25\%$ dry g.s. $\times$ $25\%$ dry g.s.\$ _{t-1}$") 

estout 	shmonths1 shmonths2 shmonths3 shockgs1_* shockgs2_* shockgs3_*  ///
		using "output\tables\table_A5.txt", ///
		replace $refcat $semibottom $semitop $rename $labels /// 
		keep(*sumsh* *dry*) dropped("\multicolumn{1}{c}{--}") 
		