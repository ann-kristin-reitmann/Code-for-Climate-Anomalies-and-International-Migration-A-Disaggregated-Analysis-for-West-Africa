
*-------------------------------------------------------------------------------------------
* 3a. Data prep do-file: match FMS data to raster data 
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file merges all data at the .5x.5 degrees cell size

*-------------------------------------------------------------------------------------------
* I. Prepare FMS data by month 
*-------------------------------------------------------------------------------------------

*2017 dates to merge later 

clear 
set obs 12 
gen month=_n
gen year=2017
gen myear=ym(year, month)
keep myear
save "data\temp.dta", replace 

*Indicator for urban cells 

use "data\FMS_2018_2019_urban_5x5.dta", clear
	sort cellid myear 
	keep cellid 
	duplicates drop 
	gen urban=1
	rename cellid _ID 
save "data\urban_cell_5x5.dta", replace

use "data\FMS_2018_2019_cells_5x5.dta", clear

sort cellid myear

gen internal=1 if destination==1 
gen international=1 if destination!=1 & destination!=. 

gen intonmove=.
replace intonmove=1 if survey_country_code!=departure_country_code 

replace destination1=. if destination1==0 
replace destination2=. if destination2==0 
replace destination3=. if destination3==0 

*Collapse data to observe migrants by cell and month-year 

collapse (sum) migrant internal international intonmove destination1 destination2 destination3 destination4 (first) qyear, by(cellid myear)
sort 	cellid myear

sort myear cellid

*gen urban=0
*replace urban=1 if largecity>=1
*label var urban "Large city within cell"

append using "data\temp.dta" // append dates for 2017 

*Convert to panel 

tsset cellid myear
tsfill, full   // create missing for missing dates 
drop if cellid==.

by cellid: gen nyear=[_N] // check that all cells are observed 36 times
tab nyear

*Labels 

label var cellid 		"Cell ID for maps"
label var myear  		"Month-Year"
label var qyear 		"Quarter-Year"
label var migrant 		"Total migration"
label var internal		"Total internal migration"
label var international	"Total international migration"

drop destination1 // internal covers it
rename destination2  migafrica
rename destination3	 migeurope
rename destination4	 migother

label var migafrica 	"Total international migration within Africa"
label var migeurope 	"Total international migration to Europe"
label var migother	 	"Total international migration other"
label var intonmove	    "International: survey not in departure country"

gen year = year(dofm(myear))
gen month = month(dofm(myear))

label var year "Year"
label var month "Month"

sort cellid myear qyear migrant 

*-------------------------------------------------------------------------------------------
* II. Import all cells from shapefile  
*-------------------------------------------------------------------------------------------

/*import delimited "data/Rdata/.5x.5/raster_Africa.csv", clear
	rename id _ID
	sort _ID
	drop v1
save "data/raster_Africa_5x5.dta", replace*/

rename cellid _ID

merge m:1 _ID  using "data/raster_Africa_5x5.dta"

gen fmssample=1 if _merge==3
replace fmssample=0 if _merge==2

drop _merge

*Convert to panel 

replace myear=696 if myear==. & fmssample==0 // to fill in the data for all month-years

tsset _ID myear
tsfill, full   // create missing for missing dates 

*Replace fmssample for all cells

egen fmssamplemax=max(fmssample), by(_ID)
drop fmssample
rename fmssamplemax fmssample
label var fmssample "Cell is in FMS sample" 

tab myear // you should have the same num. of observations for all month-year 

label var year "Year"
label var month "Month"

merge m:1 _ID using "data\urban_cell_5x5.dta"

drop _merge 
replace urban=0 if urban==. 
label var urban "Large city in cell"

*-------------------------------------------------------------------------------------------
* III. SPEI database 
*-------------------------------------------------------------------------------------------

/*
EMPTY FOR NOW
*/

*-------------------------------------------------------------------------------------------
* IV. Soil moisture index
*-------------------------------------------------------------------------------------------

merge 1:1 _ID myear using "data/smi_sma_cells_monthly_5x5.dta" 

drop year month
gen year = year(dofm(myear))
gen month = month(dofm(myear))

bys year : tab _merge 
drop _merge

*-------------------------------------------------------------------------------------------
* V. Crop calendar 
*-------------------------------------------------------------------------------------------

sort _ID myear 
merge 1:1 _ID myear using "data/crop_cal_month_cells_5x5.dta"

replace cropstr=	"No crop" if _merge==1 // areas without crops not listed in MICRA data (see documentation)
replace maincrop=	"No crop" if _merge==1
drop _merge

*-------------------------------------------------------------------------------------------
* VI. Merge distance to closest FMP and more control variables
*-------------------------------------------------------------------------------------------

sort _ID myear 

merge 1:1 _ID myear using "data/fmp_cells_5x5.dta"

drop if _ID==.
bys year : tab _merge // merge=1 should only happen for 2017
drop _merge 

*-------------------------------------------------------------------------------------------
* VII. Merge database from Harari and La Ferrara 
*-------------------------------------------------------------------------------------------

/*
merge m:1 _ID using "data\_orig\harari_laferrara_2011.dta"
drop _merge

sort _ID myear

drop cell tax_gdp polity2 *SPEI* W_ctry* ctry_* ACTOR* W_* BATTLE_ACLED RIOT_ACLED CIVILIAN_ACLED OTHER_REBEL_ACT_ACLED ANY_EVENT_ACLED
*/

*-------------------------------------------------------------------------------------------
* VIII. Data prep 
*-------------------------------------------------------------------------------------------

sort _ID myear
drop if _ID==.

order _ID myear year month 

/*
label var lat "Latitude"
label var lon "Longitude"
label var spei03 "SPEI 3-months"

foreach var in spei01 spei03 spei06 {

	gen l1_`var'=`var'[_n-12] if _ID==_ID[_n-1] & year>=2018
	label var l1_`var' "`var' (t-12)"

	gen l2_`var'=`var'[_n-24] if _ID==_ID[_n-1] & year>=2018
	label var l2_`var' "`var' (t-24)"

	}
*/

replace growcrop=0 if cropstr=="No crop"
replace maingrowcrop=0 if cropstr=="No crop"

gen nogrowcrop=1 if growcrop==0
replace nogrowcrop=0 if growcrop==1
label var nogrowcrop "No growing crop month"

/*	
foreach var in spei01 spei03 spei06 {

	gen g_`var'=`var' if growcrop==1
	label var g_`var' "`var' x growing season"
	
	gen gl1_`var'=l1_`var' if growcrop==1
	label var gl1_`var' "`var' (t-12) x growing season"

	gen gl2_`var'=l2_`var' if growcrop==1
	label var gl2_`var' "`var' (t-24) x growing season"

	gen ng_`var'=`var' if growcrop==0
	label var ng_`var' "`var' x not growing season"
	
	gen ngl1_`var'=l1_`var' if growcrop==0
	label var gl1_`var' "`var' (t-12) x not growing season"

	gen ngl2_`var'=l2_`var' if growcrop==0
	label var gl2_`var' "`var' (t-24) x not growing season"
	
	}
*/

*Quarter

gen 	quarter=1 	if month>=1 & month<=3 & !mi(month)
replace quarter=2 	if month>=4 & month<=6 & !mi(month)
replace quarter=3 	if month>=7 & month<=9 & !mi(month)
replace quarter=4 	if month>=10 & month<=12 & !mi(month)
label var quarter "Quarter"

*Urban cell 

egen durban=max(urban), by(_ID)
drop urban 
rename durban urban
label var urban "Large city within cell"

save "data\cells_5by5_all.dta", replace

*-------------------------------------------------------------------------------------------
* IX. Import additional data files
*-------------------------------------------------------------------------------------------

/*
* 1. Import largest country share 

import delimited "data/QGIS/largest_area_country_5x5.csv", clear
duplicates drop 
keep id admin_2 area
sort id area admin_2

rename id _ID
egen rank=rank(-area), by(_ID) 

replace rank=0 if rank==.

sort _ID rank

egen minrank=min(rank), by(_ID)

gen country_share=admin_2 if rank==minrank
drop minrank

egen countid=group(_ID)  // number of cells 10,624

drop if country_share==""

egen countidcheck=group(_ID)  // number of cells 10,624

keep _ID country_share

save "data/country_share_5x5.dta", replace
*/

/*
*Import population data 
import delimited "data/Rdata/.5x.5/pop18_cells.csv", clear
drop v1
rename id _ID 
keep _ID pop_sum
save "data/pop18_cells_5x5.dta", replace
*/

*Imported from QGIS from the table of properties of the grid shapefile for WA 

/*
*All Africa (shapefile merged with raster for Africa)
import delimited "data/Rdata/.5x.5/raster_Africa.csv", clear
rename id _ID
drop v1
save "data/Africa_5by5_cells.dta", replace 
*/

/*
*Import poverty data 

import delimited "data/Rdata/.5x.5/infmort_cells.csv", clear
drop v1 
rename id _ID 
replace inf_mort="" if inf_mort=="NA"
destring inf_mort, replace
keep _ID inf_mort
save "data/infmort_cells_5x5.dta", replace
*/

*-------------------------------------------------------------------------------------------
* X. Merge country for each cell and population data 
*-------------------------------------------------------------------------------------------

use "data\cells_5by5_all.dta", clear
	
merge m:1 _ID using "data/pop18_cells_5x5.dta"
drop _merge 

merge m:1 _ID using "data/country_share_5x5.dta"
drop _merge 

rename country_share country_largest_share 

*Merge poverty data 

merge m:1 _ID using  "data/infmort_cells_5x5.dta"

/*
*Merge border data

import delimited "data/borders_shape_5x5", clear

rename id_2 _ID
keep id admin _ID

bysort id: gen howmany=_N 
drop if _ID==.

gen border=.
replace border=0 if howmany==1
replace border=1 if howmany!=1 & !mi(howmany)

keep _ID border
egen border2=max(border), by(_ID)
drop border 
rename border2 border 
duplicates drop 
save "data/border_cells_5x5.dta", replace 
*/

drop _merge
merge m:1 _ID using "data/border_cells_5x5.dta"

*-------------------------------------------------------------------------------------------
* XI. Restrict to Western Africa
*-------------------------------------------------------------------------------------------

*keep if year==2018
drop qyear

*Replace country largest share including the borders of the country they belong to 
*For this exercise I use the shapefile 1x1 created in QGIS which assigns the cell to the shapefile data 
*because the merge is not done by the area, but it gives the first match. 
*I also double-checked them visually in QGIS 

/*
replace country_largest_share=admin if country_largest_share=="Algeria"
replace country_largest_share=admin if country_largest_share=="Cameroon"
replace country_largest_share=admin if country_largest_share=="Chad"
replace country_largest_share=admin if country_largest_share=="Libyan Arab Jamahiriya"
replace country_largest_share=admin if country_largest_share=="Western Sahara"
replace country_largest_share=admin if country_largest_share=="Sudan"
replace country_largest_share=admin if country_largest_share=="Central African Republic"
*/

encode country_largest_share, gen(country_share) 
*tab _ID, gen(id)
*tab month, gen(mon)
*tab country_share, gen(shcountry)

replace west="" if west=="NA"
destring west, replace
egen maxwest=max(west), by(_ID)
replace maxwest=0 if maxwest==.
drop west
rename maxwest west

drop if year<1980

*-------------------------------------------------------------------------------------------
* XII. Save data
*-------------------------------------------------------------------------------------------

save "data\cells_5by5_all.dta", replace
