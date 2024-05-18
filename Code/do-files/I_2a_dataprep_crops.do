
*-------------------------------------------------------------------------------------------
* 2a. Data prep do-file: crop calendar data 
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-files prepares the crop calendar data 

*-------------------------------------------------------------------------------------------
* I. Prepare data for spatial match 
*-------------------------------------------------------------------------------------------

/*
*First step: import database, collapse by cell id, generate csv for spatial match 

import delimited "data\_orig\CELL_SPECIFIC_CROPPING_CALENDARS_30MN.TXT", clear 

order lat lon

*Collapse cell centroids to plot them in QGIS

collapse (first) lat lon, by(cell_id)
export delimited "data\QGIS\cell_crops_coord.csv", replace

THE DATABASE WAS MERGED WITH THE SHAPE FILE IN R AND STORED AS A CSV FILE CALLED
CROP_CELLID.CSV WHICH IS LOADED NEXT 
*/

*-------------------------------------------------------------------------------------------
* II. Clean matched data 
*-------------------------------------------------------------------------------------------

*Second step: Import CSV file generated in R 	

import delimited "data\Rdata\crop_cellid.csv", clear 
	keep cellid cell_id 
	label var cellid "Raster ID"
	label var cell_id "Crop cell ID"
	drop if cell_id=="NA"
	destring cell_id, replace 
save "data\file_temp.dta", replace 

import delimited "data\Rdata\.5x.5\crop_cellid.csv", clear 
	rename id cellid
	keep cellid cell_id 
	label var cellid "Raster ID .5x.5"
	label var cell_id "Crop cell ID"
	drop if cell_id=="NA"
	destring cell_id, replace 
save "data\file_temp5by5.dta", replace 

*Third step: import MICRA data and merge the corresponding cell_ids 

foreach data in temp temp5by5 {

import delimited "data\_orig\CELL_SPECIFIC_CROPPING_CALENDARS_30MN.TXT", clear 
sort cell_id
merge m:1 cell_id using "data\file_`data'.dta" 

keep if _merge==3 // keep only the cells contained in the shape file 
drop _merge 
erase "data\file_`data'.dta"

order cell_id cellid 

*Rename variables 

rename cell_id 	micracell
rename row 		micrarow
rename column 	micracolumn 
rename lat		micralat
rename lon		micralon

label var micracell 	"MICRA cell id"
label var cellid 	"Raster ID (maps)"

sort cellid

gen rainfed=.
replace rainfed=1 if crop>=27 & crop<=52
replace rainfed=0 if crop>=1 & crop<=26
label var rainfed "Crop is rainfed"
label def rainfed 1 "Crop is rainfed" 0 "Crop is irrigated"

*Generate a string for rainfed and irrigated crops 

gen cropstr=""
replace cropstr="Wheat"	 				if crop==1 	| crop==27
replace cropstr="Maize" 				if crop==2 	| crop==28
replace cropstr="Rice" 					if crop==3 	| crop==29
replace cropstr="Barley" 				if crop==4	| crop==30
replace cropstr="Rye" 					if crop==5 	| crop==31
replace cropstr="Millet" 				if crop==6 	| crop==32
replace cropstr="Sorghum" 				if crop==7 	| crop==33
replace cropstr="Soybeans" 				if crop==8 	| crop==34
replace cropstr="Sunflower" 			if crop==9 	| crop==35
replace cropstr="Potatoes" 				if crop==10 | crop==36
replace cropstr="Cassava" 				if crop==11 | crop==37
replace cropstr="Sugar cane" 			if crop==12 | crop==38
replace cropstr="Sugar beet" 			if crop==13 | crop==39
replace cropstr="Oil palm" 				if crop==14 | crop==40
replace cropstr="Rapeseed Canola" 		if crop==15 | crop==41
replace cropstr="Groundnuts Peanuts" 	if crop==16 | crop==42
replace cropstr="Pulses" 				if crop==17 | crop==43
replace cropstr="Citrus" 				if crop==18 | crop==44
replace cropstr="Date palm" 			if crop==19 | crop==45
replace cropstr="Grapes Vine" 			if crop==20 | crop==46
replace cropstr="Cotton" 				if crop==21 | crop==47
replace cropstr="Cocoa" 				if crop==22 | crop==48
replace cropstr="Coffee" 				if crop==23 | crop==49
replace cropstr="Others perennial" 		if crop==24 | crop==50
replace cropstr="Fodder grasses" 		if crop==25 | crop==51
replace cropstr="Others annual." 		if crop==26 | crop==52

*Generate indicator if a crop grows over two years 

gen overyear=1 if end<start 
replace overyear=0 if end>start

gen startyear=2017 
gen endyear=.
replace endyear=2017 if overyear==0 
replace endyear=2018 if overyear==1

*Create 1s for the growing months (during the same year)
	
	foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {

	generate month_`i'=1 if `i'>=start & `i'<=end & overyear==0 

	}

*Create 1s for the growing months (for crops that grow over two years)
	
	foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {

	replace month_`i'=1 if  `i'<=end & overyear==1
	replace month_`i'=1 if  `i'>=start & overyear==1

	}

*Replace zeros (for all cells where start and end is known)
	
	foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {
	replace month_`i'=0 if month_`i'==. & start!=. & end!=.

	}

	local path `data'
	 
	if  "`path'" == "temp" {
	save "data/clean_crops.dta", replace 
	}

	if  "`path'" == "temp5by5" {
	save "data/clean_crops_5x5.dta", replace 
	}

}

*-------------------------------------------------------------------------------------------
* III. Prepare database (only main irrigated crop in the cell and respected calendar)
*-------------------------------------------------------------------------------------------

foreach data in crops crops_5x5 {

use "data/clean_`data'.dta", clear

*Keep only rainfed crops 

keep if rainfed==1
sort cellid area 

*Keep crop with the largest area in the cell 

egen croprank=rank(area), by(cellid) field
keep if croprank==1

*Reshape file to merge to main database 

reshape long month_, i(cellid) j(month)

keep cellid month cropstr overyear month_ area
gen year=2018 
gen myear=ym(year, month)
format myear %tm
drop month year 

rename cellid _ID 
order _ID myear

rename month_ growcrop
rename area areacrop
rename overyear overyearcrop

label var areacrop "Total area of crop (cell)"
label var cropstr "Crop (cell)"
label var overyearcrop "Crop grows over two years"
label var growcrop "Crop calendar rain-fed crop"

save "data/temp.dta", replace 

*-------------------------------------------------------------------------------------------
* IV. Prepare database (main crop in the cell and calendar of the one with largest area)
*-------------------------------------------------------------------------------------------

*Generate data for main crop in the cell 

use "data/clean_`data'.dta", clear

sort cellid cropstr 

*Generate sum of total area for one crop (rainfed + irrigated)

egen sumarea=sum(area), by(cellid cropstr)

sort cellid sumarea 

*Keep crop with the largest area in the cell 

egen croprank=rank(sumarea), by(cellid) field // field option: no correction for ties. 
keep if croprank==1

*Drop repeated crops

drop croprank 
sort cellid area 
egen croprank=rank(area), by(cellid) field 
keep if croprank==1

duplicates drop cellid area, force // keep only one crop per cell --> calendars might defer 

*Reshape file to merge to main database 

reshape long month_, i(cellid) j(month)

keep cellid month cropstr overyear month_ sumarea

gen year=2018 
gen myear=ym(year, month)
format myear %tm
drop month year 

rename cellid _ID 
order _ID myear

rename cropstr maincrop
rename month_ maingrowcrop
rename overyear mainoveryearcrop

label var sumarea "Total area of main crop rain-irrigated (cell)"
label var maincrop "Main crop rain-irrigated (cell)"
label var mainoveryearcrop "Crop grows over two years rain-irrigated"
label var maingrowcrop "Crop calendar rain-irrigated crop"

merge 1:1 _ID myear using "data/temp.dta"  // missing cells have no rainfed crops, but only irrigated 
drop _merge 
save "data/temp.dta", replace // data for 2018

replace myear=myear+12   // data for 2019
save "data/temp19.dta", replace 

use "data/temp.dta", clear 
replace myear=myear-12   // data for 2017 
save "data/temp17.dta", replace 

replace myear=myear-12   // data for 2016 
save "data/temp16.dta", replace 

replace myear=myear-12   // data for 2015
save "data/temp15.dta", replace 

replace myear=myear-12   // data for 2014
save "data/temp14.dta", replace 

replace myear=myear-12   // data for 2013
save "data/temp13.dta", replace 

replace myear=myear-12   // data for 2012
save "data/temp12.dta", replace 

replace myear=myear-12   // data for 2011
save "data/temp11.dta", replace 

replace myear=myear-12   // data for 2010
save "data/temp10.dta", replace 

replace myear=myear-12   // data for 2009
save "data/temp9.dta", replace 

replace myear=myear-12   // data for 2008
save "data/temp8.dta", replace 

replace myear=myear-12   // data for 2007
save "data/temp7.dta", replace 

replace myear=myear-12   // data for 2006
save "data/temp6.dta", replace 

replace myear=myear-12   // data for 2005
save "data/temp5.dta", replace 

replace myear=myear-12   // data for 2004
save "data/temp4.dta", replace 

replace myear=myear-12   // data for 2003
save "data/temp3.dta", replace 

replace myear=myear-12   // data for 2002
save "data/temp2.dta", replace 

replace myear=myear-12   // data for 2001
save "data/temp1.dta", replace 

replace myear=myear-12   // data for 2000
save "data/temp0.dta", replace 

replace myear=myear-12   // data for 1999
save "data/temp99.dta", replace 

replace myear=myear-12   // data for 1998
save "data/temp98.dta", replace 

replace myear=myear-12   // data for 1997
save "data/temp97.dta", replace 

use "data/temp.dta", clear
append using "data/temp97.dta"
append using "data/temp98.dta"
append using "data/temp99.dta"
append using "data/temp0.dta"
append using "data/temp1.dta"
append using "data/temp2.dta"
append using "data/temp3.dta"
append using "data/temp4.dta"
append using "data/temp5.dta"
append using "data/temp6.dta"
append using "data/temp7.dta"
append using "data/temp8.dta"
append using "data/temp9.dta"
append using "data/temp10.dta"
append using "data/temp11.dta"
append using "data/temp12.dta"
append using "data/temp13.dta"
append using "data/temp14.dta"
append using "data/temp15.dta"
append using "data/temp16.dta"
append using "data/temp17.dta"
append using "data/temp19.dta" 

*-------------------------------------------------------------------------------------------
* V. Save data
*-------------------------------------------------------------------------------------------

local path `data'
	 
	if  "`path'" == "crops" {
	save "data/crop_cal_month_cells.dta", replace 
	}

	if  "`path'" == "crops_5x5" {
	save "data/crop_cal_month_cells_5x5.dta", replace 
	}
	
}

erase "data/temp97.dta"
erase "data/temp98.dta"
erase "data/temp99.dta"
erase "data/temp0.dta"
erase "data/temp1.dta"
erase "data/temp2.dta"
erase "data/temp3.dta"
erase "data/temp4.dta"
erase "data/temp5.dta"
erase "data/temp6.dta"
erase "data/temp7.dta"
erase "data/temp8.dta"
erase "data/temp9.dta"
erase "data/temp10.dta"
erase "data/temp11.dta"
erase "data/temp12.dta"
erase "data/temp13.dta"
erase "data/temp14.dta"
erase "data/temp15.dta"
erase "data/temp16.dta"
erase "data/temp17.dta"
erase "data/temp19.dta" 
