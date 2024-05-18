
*-------------------------------------------------------------------------------------------
* Table 1
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table 1

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data/final_cell_5by5_month.dta", clear

*-------------------------------------------------------------------------------
* Globals
*-------------------------------------------------------------------------------

gen cellfmp_bin=.
replace cellfmp_bin=1 if cellfmp==1 | cellfmp==2
replace cellfmp_bin=0 if cellfmp==0
label var cellfmp_bin "FMP in cell"

global control  cellfmp_bin fmpbuff200km 
global fe		i.month i.year##i.country_share
global se   	vce(cluster _ID)

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------

eststo clear

*set fixed effects

xtset _ID myear

*set sample for summary statistics

gen lrsmal1=l1.lrsma if  _ID==_ID[_n-1]

rename dinternational dinter
rename cinternational cinter

foreach var in dinter cinter {
	
	foreach depvar in 	lrsmal1 lrsma2 lrsma3 lrsma4 lrsma5 lrsma6 ///
						lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 {
  
	areg `var' c.`depvar'  $control $fe, absorb(_ID) $se
	keep if e(sample)
		
	}
	
}

*prep for summary statistics table

egen minone=sum(dinter), by(_ID)

tab cellfmp, gen(cellfmpx)

replace pop_sum=pop_sum/1000

*-------------------------------------------------------------------------------
* Summary statistics
*-------------------------------------------------------------------------------

local variables dinter cinter lrsma cellfmp_bin fmpbuff200km growcrop pop_sum inf_mort

eststo stats_all: 		estpost sum `variables'

eststo stats_crop: 		estpost sum `variables' if cropincell==1 & lrsma12gs!=.

eststo stats_cropone: 	estpost sum `variables' if cropincell==1 & lrsma12gs!=. & minone>0

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

global refcat 	refcat(dinter "\textbf{Dependent variables}" lrsma  ///
				"\textbf{Independent variables}" ///
				occlevel1 "\textit{Occupation}" ///
				country1 "\textit{Country of origin}", label(" ")) style(tex)
		 
global top 		eqlabels(none) collabels(none) mlabels(none) nonum
		
global cell 	cell((mean(fmt(%9.3fc) label("mean") vacant("\multicolumn{1}{c}{--}")) ///
				sd(fmt(%9.3fc) label("s.d.") vacant("\multicolumn{1}{c}{--}")))) ///
				stats(N, fmt(%9.0fc) labels("Observations") ///
				layout(\multicolumn{1}{c}{@})) prefoot("\midrule") 
				
global labels 	varlabels(	dinter "At least one migrant" ///
							cinter "Number of migrants" ///
							lrsma "SMA index" ///
							cellfmp_bin "FMP in cell" ///
							fmpbuff200km "FMP in 200km radius" ///
							growcrop "Growing season" ///
							inf_mort "Child mortality rate" ///
							pop_sum "Population (in thousands)") 
				
estout stats_all stats_crop stats_cropone  using "output\tables\table_01.txt", replace /// 
$labels $refcat $cell $top 
