
*-------------------------------------------------------------------------------------------
* 3b. Data prep do-file: match FMS data to raster data 
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file merges all data at the 1x1 degrees cell size

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

use "data\FMS_2018_2019_urban.dta", clear
	sort cellid myear 
	keep cellid 
	duplicates drop 
	gen urban=1
	rename cellid _ID 
save "data\urban_cell.dta", replace

use "data\FMS_2018_2019_cells.dta", clear

sort cellid myear

gen internal=1 if destination==1 
gen international=1 if destination!=1 & destination!=. 

gen intonmove=.
replace intonmove=1 if survey_country_code!=departure_country_code 

replace destination1=. if destination1==0 
replace destination2=. if destination2==0 
replace destination3=. if destination3==0 

*Collapse data to observe migrants by cell and month-year 

collapse (sum) migrant internal international intonmove destination1 destination2 destination3 destination4 (first) qyear lat_cellc lon_cellc, by(cellid myear)
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

egen lat_c=max(lat_cellc), by(cellid)
egen lon_c=max(lon_cellc), by(cellid)
 
drop lat_cellc lon_cellc nyear 

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
label var lat_c 		"Latitude cell centroid"
label var lon_c 		"Longitude cell centroid"
label var intonmove	    "International: survey not in departure country"

gen year = year(dofm(myear))
gen month = month(dofm(myear))

label var year "Year"
label var month "Month"

sort cellid myear qyear lat_c lon_c migrant 

*-------------------------------------------------------------------------------------------
* II. Import all cells from shapefile  
*-------------------------------------------------------------------------------------------

/*
import delimited "data/Rdata/raster_Africa.csv", clear
	keep cellid
	rename cellid _ID
	sort _ID
save "data/raster_Africa.dta", replace
*/

rename cellid _ID

merge m:1 _ID  using "data/raster_Africa.dta"

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

merge m:1 _ID using "data\urban_cell.dta"

drop _merge 
replace urban=0 if urban==. 
label var urban "Large city in cell"

*-------------------------------------------------------------------------------------------
* III. SPEI database 
*-------------------------------------------------------------------------------------------

/*
sort _ID myear 
merge 1:1 _ID myear using "data/spei03_month_cells.dta"

tab year if _merge==1 // should only be 2019
tab year if _merge==2 // should only be 2016

drop _merge 

merge 1:1 _ID myear using "data/spei01_month_cells.dta"
tab year if _merge==1 // should only be 2019
tab year if _merge==2 // should only be 2016

drop _merge 


merge 1:1 _ID myear using "data/spei06_month_cells.dta"
tab year if _merge==1 // should only be 2019
tab year if _merge==2 // should only be 2016

drop _merge
*/

*-------------------------------------------------------------------------------------------
* IV. Soil moisture index
*-------------------------------------------------------------------------------------------

merge 1:1 _ID myear using "data/smi_sma_cells_monthly.dta" 
drop _merge

drop year month
gen year = year(dofm(myear))
gen month = month(dofm(myear))

*-------------------------------------------------------------------------------------------
* V. Crop calendar 
*-------------------------------------------------------------------------------------------

sort _ID myear 
merge 1:1 _ID myear using "data/crop_cal_month_cells.dta"

replace cropstr=	"No crop" if _merge==1 // areas without crops not listed in MICRA data (see documentation)
replace maincrop=	"No crop" if _merge==1
drop _merge

*-------------------------------------------------------------------------------------------
* VI. Merge distance to closest FMP and more control variables
*-------------------------------------------------------------------------------------------

sort _ID myear 

merge 1:1 _ID myear using "data/fmp_cells.dta"

drop if _ID==.
bys year : tab _merge // merge=1 should only happen for 2017
drop _merge 

*-------------------------------------------------------------------------------------------
* VII. Merge database from Harari and La Ferrara 
*-------------------------------------------------------------------------------------------

merge m:1 _ID using "data\_orig\harari_laferrara_2011.dta"
drop _merge

sort _ID myear

drop cell tax_gdp polity2 *SPEI* W_ctry* ctry_* ACTOR* W_* BATTLE_ACLED RIOT_ACLED CIVILIAN_ACLED OTHER_REBEL_ACT_ACLED ANY_EVENT_ACLED

*-------------------------------------------------------------------------------------------
* VIII. Data prep 
*-------------------------------------------------------------------------------------------

drop lat lat_c lon lon_c

sort _ID myear
drop if _ID==.

egen lat=max(latitude_m), by(_ID)
egen lon=max(longitude_), by(_ID)

drop latitude_m longitude_

order _ID myear year month lat lon

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

save "data\cells_1by1_all.dta", replace

*-------------------------------------------------------------------------------------------
* IX. Import additional data files
*-------------------------------------------------------------------------------------------

/*
import delimited "data/Rdata/country_cells_centroids.csv", clear
drop v1
replace country="" if country=="NA"
keep cellid country
rename cellid _ID 
save "data/country_cells_centroids.dta", replace
*/

/*
*Import population data 

import delimited "data/Rdata/pop18_cells.csv", clear
drop v1
rename cellid _ID 
keep _ID pop_sum
save "data/pop18_cells.dta", replace
*/

*Imported from QGIS from the table of properties of the grid shapefile for WA 

/*
*Only WA Africa 
import delimited "data/shapefiles/Africa/WA_cell_id_1x1.csv", clear
rename cellid _ID
keep _ID admin income_grp region_wb

gen west=1
save "data/WA_1by1_cells.dta", replace 

*All Africa (shapefile merged with raster for Africa)
import delimited "data/shapefiles/Africa/Africa_cell_id_1x1.csv", clear
rename cellid _ID
keep _ID admin income_grp subregion
save "data/Africa_1by1_cells.dta", replace 
*/

/*
*Import poverty data 

import delimited "data/Rdata/infmort_cells.csv", clear
drop v1 
rename cellid _ID 
replace inf_mort="" if inf_mort=="NA"
destring inf_mort, replace
keep _ID inf_mort
save "data/infmort_cells_1x1.dta", replace
*/

*-------------------------------------------------------------------------------------------
* X. Merge country for each cell and population data 
*-------------------------------------------------------------------------------------------

use "data\cells_1by1_all.dta", clear

*drop west
	merge m:1 _ID using "data/WA_1by1_cells.dta"
	replace admin="Côte d'Ivoire" if admin=="Ivory Coast"
	replace west=0 if west==.
	drop _merge 
	
merge m:1 _ID using "data/pop18_cells.dta"
*replace country_largest_share=country if country_largest_share==""
drop _merge 

*Merge poverty data 

merge m:1 _ID using "data/infmort_cells_1x1.dta"
drop _merge 

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

*-------------------------------------------------------------------------------------------
* XII. Save data
*-------------------------------------------------------------------------------------------

save "data\cells_1by1_all.dta", replace 

