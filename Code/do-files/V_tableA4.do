
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

*continuous lrsma measure all cells

**number of migrants

foreach var in cinter {
  
	foreach sma in 	lrsmal1 lrsma3 lrsma6 lrsma9 lrsma12 {	
					
	xtnbreg `var' c.`sma'  $control $fe, iter(20) fe difficult
	eststo all_`var'_`sma'
	
	}	
	
}

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

global refcat 	refcat(1.cellfmp "\textit{Num. of FMPs Ref:. No FMP}" ///
				, label(" "))
		
global top 		cells(b(star fmt(3) vacant("\multicolumn{1}{c}{--}") label(" ")) ///
				se(fmt(3) par label(" "))) varwidth(35) ///
				starlevels(^{*} 0.1 ^{**} 0.05 ^{***} 0.01) ///
				eqlabels(none) collabels(none) mlabels(none) ///
				drop(*country_share *.month *.year) 
			
global bottom 	s(N r2, fmt(%12.0fc %-9.3fc) labels("Observations" "R$^{2}$") ///
				layout(\multicolumn{1}{c}{@} @)) nonum ///
				prefoot(\addlinespace  Cell FE  			&\multicolumn{1}{c}{yes} ///
							&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
							&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
									\\ Month FE   			&\multicolumn{1}{c}{yes} ///
							&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
							&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
									\\ Country-by-year FE   &\multicolumn{1}{c}{yes} ///
							&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
							&\multicolumn{1}{c}{yes} &\multicolumn{1}{c}{yes} ///
							\\  \midrule) ///
				postfoot(\bottomrule) style(tex)		
							
global labels 	varlabels(	lrsma "SMA index" ///
							cellfmp_bin "FMP in cell" ///
							fmpbuff200km "FMP in 200km radius" ///
							lrsmal1 "SMA index\$,_{1 month}\$" ///
							lrsma3 "SMA index\$,_{3 months}\$" ///
							lrsma6 "SMA index\$,_{6 months}\$" ///
							lrsma9 "SMA index\$,_{9 months}\$" ///
							lrsma12 "SMA index\$,_{12 months}\$" ///
							_cons "Constant")
				
global format  cells(b(star fmt(3)) se(fmt(3) par)) s(N r2, fmt(%12.0fc %-9.3fc)) ///
				varwidth(35) indicate (/*"Cell FE = *_ID"*/ ///
				"Month FE = *month" "Country-by-year FE = *year*" ) ///
				drop(*country_share 0.*) 
			   
global rename rename(	lrsmal1 lrsma ///
						lrsma3 lrsma ///
						lrsma6 lrsma ///
						lrsma9 lrsma ///
						lrsma12 lrsma)
					 	
estout 	all_cinter_lrsmal1 all_cinter_lrsma3 all_cinter_lrsma6 ///
		all_cinter_lrsma9 all_cinter_lrsma12 ///
		using "output\tables\table_A4.txt", ///
replace $refcat $top $bottom $rename $labels order(lrsma*)
