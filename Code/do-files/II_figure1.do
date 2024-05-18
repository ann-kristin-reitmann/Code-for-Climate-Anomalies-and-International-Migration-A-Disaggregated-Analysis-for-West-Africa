
*-------------------------------------------------------------------------------------------
* Figure 1
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Figure 1

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data\smi_sma_cells_monthly_5x5_1948.dta", clear

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------

eststo clear

gen name=admin
replace name="Congo" if name=="Republic of the Congo"
replace name="Congo (Democratic Republic of the)" if name=="Democratic Republic of the Congo" 
replace name="Côte d'Ivoire" if name=="Ivory Coast"
replace name="Tanzania, United Republic of" if name=="United Republic of Tanzania"
replace name="Eswatini" if name=="eSwatini"

merge m:1 name using "data\region_country.dta"
drop if _merge==2 
drop _merge

keep if intermediateregion=="Western Africa" | intermediateregion=="Middle Africa" 

sort name _ID myear

format myear %10.0g

gen date = dofm(myear)
format date %d

gen month=month(date)

gen year=year(date)

drop if year==2020
drop if lrsma==.

format myear %tm 

sort _ID year month

drop if lrsma==.

//Indicator if month is drier than average 
gen negshock=0 if lrsma!=. 
replace negshock=1 if lrsma<-.999 & lrsma!=.
label var negshock "Month drier than average"

//Indicator if month is wetter than average 
gen posshock=0 if lrsma!=. 
replace posshock=1 if lrsma>.999 & lrsma!=.
label var posshock "Month wetter than average"

bys _ID year: egen negshockyear = total(negshock)
bys _ID year: egen posshockyear = total(posshock)

gen totalshockyear=negshockyear+posshockyear

keep if year>=1960

save "data\smi_sma_cells_monthly_5x5_1960_SHOCKS.dta", replace

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

use "data\smi_sma_cells_monthly_5x5_1960_SHOCKS.dta", clear

preserve 

keep if month==1

sort year

collapse (mean) negshockyear, by(year)

tsset  year, yearly

reg negshockyear year
predict trend

label var year "Year"
label var negshockyear "Cell-level average number of months that are drier than normal per year"
label var trend "Trend"

tsline negshockyear trend, ///
	ylabel(0(0.5)4, labsize(small) angle(0) labcolor(black) tlcolor(gs5)) yscale(lcolor(gs5)) ///
	xlabel(1960(10)2020, labsize(small) glcolor(gs12)) xtitle("") xscale(lcolor(gs5)) ///
	graphregion(color(white)) bgcolor(white) title("B. Drier conditions", size(medium) color(black)) ///
	lcolor(gs5 gs10) legend(col(1) size(small) label(1 "Cell-level average number of months" "that are drier than normal per year")) ///
	name(neg_shocks, replace)

restore

preserve

keep if month==1

*keep if west_new==1

sort year

collapse (mean) posshockyear, by(year)

tsset  year, yearly

reg posshockyear year
predict trend

label var year "Year"
label var posshockyear "Cell-level average number of months that are wetter than normal per year"
label var trend "Trend"

tsline posshockyear trend, ///
	ylabel(0(0.5)4, labsize(small) angle(0) labcolor(black) tlcolor(gs5)) yscale(lcolor(gs5)) ///
	xlabel(1960(10)2020, labsize(small) glcolor(gs12)) xtitle("") xscale(lcolor(gs5)) ///
	graphregion(color(white)) bgcolor(white) title("A. Wetter conditions", size(medium) color(black)) ///
	lcolor(gs5 gs10) legend(col(1) size(small) label(1 "Cell-level average number of months" "that are wetter than normal per year")) ///
	name(pos_shocks, replace)

restore

graph 	combine pos_shocks neg_shocks , ///
		col(2) graphregion(fcolor(white) lcolor(white)) imargin(medium)	  
graph export "output/figures/figure_01.pdf", replace 

