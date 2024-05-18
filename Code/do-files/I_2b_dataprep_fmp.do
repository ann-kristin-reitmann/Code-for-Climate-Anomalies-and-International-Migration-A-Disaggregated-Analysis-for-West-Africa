
*-------------------------------------------------------------------------------------------
* 2b. Data prep do-file: FMP data
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file creates a panel of cells indicating closest distance to FMPs and buffers 
*The info is partially obtained by geocoding the fmp locations and obtaining distances 
*Using the africa grid provided by La Ferrara (see corresponding R file DistanceToFMP to generate)

*-------------------------------------------------------------------------------------------
* I. Geocode FMP points
*-------------------------------------------------------------------------------------------

/*

*Geocode FMP points 

use "data\FMS_WCA_2018_clean.dta", clear

collapse (sum) migrant, by(fmp_point survey_country_code s_month)
decode survey_country_code, gen(surcountry)

gen address=fmp_point+","+surcountry
	opencagegeo , fulladdr(address) key(a85c2ac9814e4b5c99d058e83e01951b)

replace g_lat="" if g_quality==1
replace g_lon="" if g_quality==1

replace g_lat="11.651420" if address=="Nafadji,Guinea"
replace g_lon="-8.852198" if address=="Nafadji,Guinea"

rename g_lat fmp_lat 
rename g_lon fmp_lon 

keep survey_country_code fmp_point fmp_lat fmp_lon 
save  "data\fmp_geocodes.dta", replace 

use "data\FMS_2018_2019_clean.dta", clear

collapse (sum) migrant, by(fmp_point survey_country_code myear)
decode survey_country_code, gen(surcountry)

egen firstmonth=min(myear), by(survey_country_code fmp_point)
format firstmonth %tm 

egen lastmonth=max(myear), by(survey_country_code fmp_point)
format lastmonth %tm 

collapse (first) firstmonth lastmonth, by(fmp_point survey_country_code)

sort survey_country_code fmp_point 

gen fmp_lat=""
gen fmp_lon=""

*Geocodes provided by the IOM see original excel file sent by Damiene

replace fmp_lat=	"12.054764"	 	if fmp_point==	"Faramana"
replace fmp_lat=	"12.54915"	 	if fmp_point==	"Kantchari"
replace fmp_lat=	"12.371428"	 	if fmp_point==	"Ouagadougou"
replace fmp_lat=	"14.027369"	 	if fmp_point==	"Seytenga"
replace fmp_lat=	"10.2"	 	 	if fmp_point==	"Yendere"
replace fmp_lat=	"15.8342"	 	if fmp_point==	"Kalait"
replace fmp_lat=	"14.246357"	 	if fmp_point==	"Rig Rig"
replace fmp_lat=	"9.140911667"	if fmp_point==	"Sarh"
replace fmp_lat=	"20.41908"	 	if fmp_point==	"Zouarke"
replace fmp_lat=	"12.66748"	 	if fmp_point==	"Boundoufourdou"
replace fmp_lat=	"11.95335"	 	if fmp_point==	"Kouremale"
replace fmp_lat=	"11.6031836"	if fmp_point==	"Nafadji"
replace fmp_lat=	"12.636354"	 	if fmp_point==	"Bamako"
replace fmp_lat=	"13.151516"	 	if fmp_point==	"Benena"
replace fmp_lat=	"15.686537"	 	if fmp_point==	"Gogui"
replace fmp_lat=	"11.119503"	 	if fmp_point==	"Heremakono"
replace fmp_lat=	"15.922472"	 	if fmp_point==	"Menaka"
replace fmp_lat=	"16.273133"	 	if fmp_point==	"Place Kidal"
replace fmp_lat=	"14.524102"	 	if fmp_point==	"Sevare"
replace fmp_lat=	"16.759474"	 	if fmp_point==	"Tombouctou"
replace fmp_lat=	"16.187783"	 	if fmp_point==	"Wabaria"
replace fmp_lat=	"18.7390029"	if fmp_point==	"Arlit"
replace fmp_lat=	"13.197917"	 	if fmp_point==	"Dan Barto"
replace fmp_lat=	"13.133472"	 	if fmp_point==	"Dan Issa"
replace fmp_lat=	"13.004333"	 	if fmp_point==	"Magaria"
replace fmp_lat=	"20.2"	 	 	if fmp_point==	"Seguedine"
replace fmp_lat=	"14.887639"	 	if fmp_point==	"Tahoua"
replace fmp_lat=	"12.016628"	 	if fmp_point==	"Kano"
replace fmp_lat=	"12.937426"	 	if fmp_point==	"Sokoto"
replace fmp_lat=	"12.932145"	 	if fmp_point==	"Kedougou"
replace fmp_lat=	"14.45622304"	if fmp_point==	"Kidira"
replace fmp_lat=	"13.772589"	 	if fmp_point==	"Tambacounda"
replace fmp_lat=	"17.9228"		if fmp_point==	"Faya"	

replace fmp_lon=	"-4.66905"	 	if fmp_point==	"Faramana"
replace fmp_lon=	"1.514948"		if fmp_point==	"Kantchari"
replace fmp_lon=	"-1.51966"	 	if fmp_point==	"Ouagadougou"
replace fmp_lon=	"-0.030607"	 	if fmp_point==	"Seytenga"
replace fmp_lon=	"-4.96667"	 	if fmp_point==	"Yendere"
replace fmp_lon=	"20.8949"	 	if fmp_point==	"Kalait"
replace fmp_lon=	"14.346561"		if fmp_point==	"Rig Rig"
replace fmp_lon=	"18.38496667"	if fmp_point==	"Sarh"
replace fmp_lon=	"16.22687"	 	if fmp_point==	"Zouarke"
replace fmp_lon=	"-13.55818"	 	if fmp_point==	"Boundoufourdou"
replace fmp_lon=	"-8.78291"	 	if fmp_point==	"Kouremale"
replace fmp_lon=	"-8.775030393"	if fmp_point==	"Nafadji"
replace fmp_lon=	"-8.00324"	 	if fmp_point==	"Bamako"
replace fmp_lon=	"-4.38306"	 	if fmp_point==	"Benena"
replace fmp_lon=	"-9.32986"	 	if fmp_point==	"Gogui"
replace fmp_lon=	"-5.33151"	 	if fmp_point==	"Heremakono"
replace fmp_lon=	"2.426391"	 	if fmp_point==	"Menaka"
replace fmp_lon=	"0.025767"	 	if fmp_point==	"Place Kidal"
replace fmp_lon=	"-4.0951"		if fmp_point==	"Sevare"
replace fmp_lon=	"-2.99786"		if fmp_point==	"Tombouctou"
replace fmp_lon=	"-0.03725"	 	if fmp_point==	"Wabaria"
replace fmp_lon=	"7.3894772"		if fmp_point==	"Arlit"
replace fmp_lon=	"8.320917"	 	if fmp_point==	"Dan Barto"
replace fmp_lon=	"7.258083"	 	if fmp_point==	"Dan Issa"
replace fmp_lon=	"8.912667"	 	if fmp_point==	"Magaria"
replace fmp_lon=	"12.9833333"	if fmp_point==	"Seguedine"
replace fmp_lon=	"5.282417"	 	if fmp_point==	"Tahoua"
replace fmp_lon=	"8.588784"	 	if fmp_point==	"Kano"
replace fmp_lon=	"5.226667"	 	if fmp_point==	"Sokoto"
replace fmp_lon=	"-11.38103667"	if fmp_point==	"Kedougou"
replace fmp_lon=	"-12.2174345"	if fmp_point==	"Kidira"
replace fmp_lon=	"-13.671006" 	if fmp_point==	"Tambacounda"
replace fmp_lon=	"19.09628"		if fmp_point==	"Faya"

*Self inputed latitudes and longitudes 

replace fmp_lat=	"14.487524"		if fmp_point==	"Mopti"	
replace fmp_lon=	"-4.197228"	 	if fmp_point==	"Mopti"

replace fmp_lat=	"16.974215"		if fmp_point==	"Agadez"	
replace fmp_lon=	"7.987198"	 	if fmp_point==	"Agadez"

replace fmp_lat=	"21.935416"		if fmp_point==	"Madama"	
replace fmp_lon=	"13.625868"	 	if fmp_point==	"Madama"

replace fmp_lat=	"13.421284"		if fmp_point==	"Matameye"	
replace fmp_lon=	"8.476338"	 	if fmp_point==	"Matameye"

replace fmp_lat=	"18.450586"		if fmp_point==	"Kidal"	
replace fmp_lon=	"1.409972"	 	if fmp_point==	"Kidal"

order fmp_point survey_country_code fmp_lat fmp_lon firstmonth lastmonth 
sort survey_country_code  fmp_point 

drop if fmp_lat=="" // one observation is missing so drop it
save  "data\fmp_geocodes_month.dta", replace 

export delimited "data\fmp_geocodes.csv", replace

*/

/* 
Read the csv file in R and match the FMP points to a CELL id. 
The name of the R script is DistanceToFMP.
*/

*-------------------------------------------------------------------------------------------
* II. Assign points to a cell 
*-------------------------------------------------------------------------------------------

local 1by1 data/Rdata/  // big cells 
local 5by5 data/Rdata/.5x.5/ // small cells

foreach path in `1by1' `5by5' {

*1. Create database that includes start month and end month 

import delimited "`path'/fmp_cell_id.csv", clear
	
	if "`path'"== "data/Rdata/.5x.5/" {
	drop v1
	rename id cellid 
	}
	
	keep fmpid firstmonth lastmonth cellid fmp_point survey_country_code
	rename fmpid fmp_id
	rename cellid fmpcellid
	sort fmp_id 

save "data/temp.dta", replace 

*2. Create database indicating the cells that have an active fmp 

import delimited "`path'/fmp_cell_id.csv", clear

	if "`path'"== "data/Rdata/.5x.5/" {
	drop v1
	rename id cellid 
	}
	
	keep fmpid firstmonth lastmonth cellid fmp_point survey_country_code
	rename fmpid fmp_id
	rename cellid fmpcellid
	sort fmp_id
	
*****************************************************************************************
	gen opening=""
	replace opening="2018m1" if fmp_point=="Ouagadougou" | ///
								fmp_point=="Boundoufourdou" | ///
								fmp_point=="Kouremale" | ///
								fmp_point=="Nafadji" | ///
								fmp_point=="Bamako" | ///
								fmp_point=="Benena" | ///
								fmp_point=="Gogui" | ///
								fmp_point=="Heremakono" | ///
								fmp_point=="Menaka" | ///
								fmp_point=="Mopti" | ///
								fmp_point=="Place Kidal" | ///
								fmp_point=="Sevare" | ///
								fmp_point=="Tombouctou" | ///
								fmp_point=="Wabaria" | ///
								fmp_point=="Arlit" | ///
								fmp_point=="Seguedine" | ///
								fmp_point=="Kano" | ///
								fmp_point=="Sokoto" | ///
								fmp_point=="Tambacounda"
	replace opening="2018m2" if fmp_point=="Kantchari" | ///
								fmp_point=="Seytenga"		
	replace opening="2018m3" if fmp_point=="Faya" | ///
								fmp_point=="Kalait"	| ///
								fmp_point=="Zouarke" | ///
								fmp_point=="Agadez" 
	replace opening="2018m4" if fmp_point=="Faramana" | ///
								fmp_point=="Yendere"
	replace opening="2018m8" if fmp_point=="Dan Barto" | ///
								fmp_point=="Madama"	| ///
								fmp_point=="Magaria" | ///
								fmp_point=="Tahoua" 
	replace opening="2018m9" if fmp_point=="Dan Issa"
	replace opening="2019m4" if fmp_point=="Rig Rig" | ///
								fmp_point=="Sarh"	| ///
								fmp_point=="Kedougou" | ///
								fmp_point=="Kidira" 	
	replace opening="2018m9" if fmp_point=="Matameye"
	
	gen closing=""
	replace closing="2019m12" if fmp_point=="Faramana" | ///
								fmp_point=="Kantchari" | ///
								fmp_point=="Ouagadougou" | ///
								fmp_point=="Seytenga" | ///
								fmp_point=="Yendere" | ///
								fmp_point=="Faya" | ///
								fmp_point=="Rig Rig" | ///
								fmp_point=="Sarh" | ///
								fmp_point=="Zouarke" | ///
								fmp_point=="Boundoufourdou" | ///
								fmp_point=="Kouremale" | ///
								fmp_point=="Nafadji" | ///
								fmp_point=="Bamako" | ///
								fmp_point=="Benena" | ///
								fmp_point=="Gogui" | ///
								fmp_point=="Heremakono" | ///
								fmp_point=="Menaka" | ///
								fmp_point=="Mopti" | ///
								fmp_point=="Place Kidal" | ///
								fmp_point=="Sevare" | ///
								fmp_point=="Tombouctou" | ///
								fmp_point=="Wabaria" | ///
								fmp_point=="Arlit" | ///
								fmp_point=="Dan Barto" | ///
								fmp_point=="Dan Issa" | ///
								fmp_point=="Magaria" | ///
								fmp_point=="Matameye" | ///
								fmp_point=="Seguedine" | ///
								fmp_point=="Tahoua" | ///
								fmp_point=="Kano" | ///
								fmp_point=="Sokoto" | ///
								fmp_point=="Kedougou" | ///
								fmp_point=="Kidira" | ///
							    fmp_point=="Madama"
	replace closing="2019m6" if fmp_point=="Kalait"								
	replace closing="2019m3" if fmp_point=="Tambacounda"
	replace closing="2018m3" if fmp_point=="Agadez"
	
	drop if fmp_point=="Madama" //Madama same as Seguedine 
	drop if fmp_point=="Agadez" //Agadez is the region where Segudeine and Arlit lie

*****************************************************************************************
	gen startdate = monthly(opening, "YM")
	format startdate %tm

	gen enddate = monthly(closing, "YM")
	format enddate %tm
*****************************************************************************************

* 669 is the code for 2018m1 and so on... 

*Create 1s for the growing months (for crops that grow over two years)
	
	foreach i in 696 697 698 699 700 701 702 703 704 705 706 707 ///
				 708 709 710 711 712 713 714 715 716 717 718 719 {

	generate d_`i'=1 if `i'>=startdate & `i'<=enddate 
	replace d_`i'=0 if d_`i'==. & startdate!=. & enddate!=. 
}

*****************************************************************************************
	replace d_706=0 if fmp_point=="Zouarke"
	replace d_707=0 if fmp_point=="Zouarke"
	replace d_708=0 if fmp_point=="Zouarke"
	replace d_709=0 if fmp_point=="Zouarke"
	replace d_710=0 if fmp_point=="Zouarke"
	replace d_711=0 if fmp_point=="Zouarke"
	replace d_712=0 if fmp_point=="Zouarke"
	replace d_713=0 if fmp_point=="Zouarke"
*****************************************************************************************

	sort fmpcellid 
	
	reshape long d_, i(fmp_id) j(myear)
	
*****************************************************************************************
	drop firstmonth lastmonth startdate enddate opening closing
*****************************************************************************************
	
	rename d_ cellfmp 
	label var cellfmp "Cell has active FMP"
	
	rename fmpcellid _ID
	
	sort fmp_id myear // continue here 
	format myear %tm 

	egen minfmp=min(fmp_id), by(_ID)
	egen maxfmp=max(fmp_id), by(_ID)
	gen fmpnum=1
	replace fmpnum=2 if minfmp!=maxfmp
	
	collapse (sum) cellfmp (first)minfmp maxfmp fmpnum, by(_ID myear)
	keep myear _ID cellfmp // check if we need fmp id as well 
	
save "data/temp_month.dta", replace 

*3. Create final database containing distance to FMPs

import delimited "`path'/fmp_cell_distance.csv", clear
drop v1

*Rename variables for large cells 
	
	if "`path'" == "data/Rdata/" {
		
		local i = 4     					// because the variables are called v5, v6, v7 (we add 1, 2, 3 and so on)

			foreach num of numlist 1/37 {
			local j = `i' + `num' 
			rename v`j' fmp`num'    		// rename v5, v6, v7 as fmp1, fmp2, fmp3 ... 
			}
		}
		
*Rename variables for small cells
	
	if "`path'" == "data/Rdata/.5x.5/" {
		rename id cellid   					//only in the small cells file 
		drop left top right bottom admin  	// only in the small cells file 
		local i = 8     					 // because the variables are called v9, v10, v11 (we add 1, 2, 3 and so on)

			foreach num of numlist 1/37 {
			local j = `i' + `num' 
			rename v`j' fmp`num'   			 // rename v5, v6, v7 as fmp1, fmp2, fmp3 ... 
			}
		}	

reshape long fmp, i(cellid) j(fmp_id)

rename cellid _ID 
rename fmp distance

sort fmp_id 
merge m:1 fmp_id using "data\temp.dta"
drop _merge 

sort _ID fmp_id
replace fmpcellid=. if fmpcellid!=_ID

*****************************************************************************************
	gen opening=""
	replace opening="2018m1" if fmp_point=="Ouagadougou" | ///
								fmp_point=="Boundoufourdou" | ///
								fmp_point=="Kouremale" | ///
								fmp_point=="Nafadji" | ///
								fmp_point=="Bamako" | ///
								fmp_point=="Benena" | ///
								fmp_point=="Gogui" | ///
								fmp_point=="Heremakono" | ///
								fmp_point=="Menaka" | ///
								fmp_point=="Mopti" | ///
								fmp_point=="Place Kidal" | ///
								fmp_point=="Sevare" | ///
								fmp_point=="Tombouctou" | ///
								fmp_point=="Wabaria" | ///
								fmp_point=="Arlit" | ///
								fmp_point=="Seguedine" | ///
								fmp_point=="Kano" | ///
								fmp_point=="Sokoto" | ///
								fmp_point=="Tambacounda"
	replace opening="2018m2" if fmp_point=="Kantchari" | ///
								fmp_point=="Seytenga"		
	replace opening="2018m3" if fmp_point=="Faya" | ///
								fmp_point=="Kalait"	| ///
								fmp_point=="Zouarke" | ///
								fmp_point=="Agadez" 
	replace opening="2018m4" if fmp_point=="Faramana" | ///
								fmp_point=="Yendere"
	replace opening="2018m8" if fmp_point=="Dan Barto" | ///
								fmp_point=="Madama"	| ///
								fmp_point=="Magaria" | ///
								fmp_point=="Tahoua" 
	replace opening="2018m9" if fmp_point=="Dan Issa"
	replace opening="2019m4" if fmp_point=="Rig Rig" | ///
								fmp_point=="Sarh"	| ///
								fmp_point=="Kedougou" | ///
								fmp_point=="Kidira" 	
	replace opening="2018m9" if fmp_point=="Matameye"
	
	gen closing=""
	replace closing="2019m12" if fmp_point=="Faramana" | ///
								fmp_point=="Kantchari" | ///
								fmp_point=="Ouagadougou" | ///
								fmp_point=="Seytenga" | ///
								fmp_point=="Yendere" | ///
								fmp_point=="Faya" | ///
								fmp_point=="Rig Rig" | ///
								fmp_point=="Sarh" | ///
								fmp_point=="Zouarke" | ///
								fmp_point=="Boundoufourdou" | ///
								fmp_point=="Kouremale" | ///
								fmp_point=="Nafadji" | ///
								fmp_point=="Bamako" | ///
								fmp_point=="Benena" | ///
								fmp_point=="Gogui" | ///
								fmp_point=="Heremakono" | ///
								fmp_point=="Menaka" | ///
								fmp_point=="Mopti" | ///
								fmp_point=="Place Kidal" | ///
								fmp_point=="Sevare" | ///
								fmp_point=="Tombouctou" | ///
								fmp_point=="Wabaria" | ///
								fmp_point=="Arlit" | ///
								fmp_point=="Dan Barto" | ///
								fmp_point=="Dan Issa" | ///
								fmp_point=="Magaria" | ///
								fmp_point=="Matameye" | ///
								fmp_point=="Seguedine" | ///
								fmp_point=="Tahoua" | ///
								fmp_point=="Kano" | ///
								fmp_point=="Sokoto" | ///
								fmp_point=="Kedougou" | ///
								fmp_point=="Kidira" | ///
							    fmp_point=="Madama"
	replace closing="2019m6" if fmp_point=="Kalait"								
	replace closing="2019m3" if fmp_point=="Tambacounda"
	replace closing="2018m3" if fmp_point=="Agadez"
	
	drop if fmp_point=="Madama" //Madama same as Seguedine 
	drop if fmp_point=="Agadez" //Agadez is the region where Segudeine and Arlit lie

*****************************************************************************************
gen startdate = monthly(opening, "YM")
format startdate %tm

gen enddate = monthly(closing, "YM")
format enddate %tm
*****************************************************************************************

* 669 is the code for 2018m1 and so on... 
	
*Create 1s for the growing months (for crops that grow over two years)
	
	foreach i in 696 697 698 699 700 701 702 703 704 705 706 707 ///
				 708 709 710 711 712 713 714 715 716 717 718 719 {
					 
	generate d_`i'=1 if `i'>=startdate & `i'<=enddate 
	replace d_`i'=0 if d_`i'==. & startdate!=. & enddate!=.
	}
	
*****************************************************************************************
	replace d_706=0 if fmp_point=="Zouarke"
	replace d_707=0 if fmp_point=="Zouarke"
	replace d_708=0 if fmp_point=="Zouarke"
	replace d_709=0 if fmp_point=="Zouarke"
	replace d_710=0 if fmp_point=="Zouarke"
	replace d_711=0 if fmp_point=="Zouarke"
	replace d_712=0 if fmp_point=="Zouarke"
	replace d_713=0 if fmp_point=="Zouarke"
*****************************************************************************************	
	
*4. Reshape to obtain database by month

sort _ID fmp_id 
gen u_id=_n

reshape long d_, i(u_id) j(myear)
drop u_id 

sort myear _ID fmp_id
format myear %tm

rename d_ activefmp 
label var activefmp "FMP active at time myear"

sort fmpcellid

sort _ID myear fmp_id fmpcellid 

*5. Distances, active FMPs and buffers

gen activedistance= distance if activefmp==1

gen activefmpbuff50km=0
gen activefmpbuff100km=0
gen activefmpbuff150km=0
gen activefmpbuff200km=0

replace activefmpbuff50km=1 if activedistance<=50
replace activefmpbuff100km=1 if activedistance<=100
replace activefmpbuff150km=1 if activedistance<=150
replace activefmpbuff200km=1 if activedistance<=200

by _ID myear: egen numberactivefmpbuff50km = total(activefmpbuff50km)
by _ID myear: egen numberactivefmpbuff100km = total(activefmpbuff100km)
by _ID myear: egen numberactivefmpbuff150km = total(activefmpbuff150km)
by _ID myear: egen numberactivefmpbuff200km = total(activefmpbuff200km)

egen mindistance=min(activedistance), by(myear _ID)
label var mindistance "Distance to closest active FMP"

gen fmpbuff50km=0
gen fmpbuff100km=0 
gen fmpbuff150km=0 
gen fmpbuff200km=0 

replace fmpbuff50km=1 if mindistance<=50 
replace fmpbuff100km=1 if mindistance<=100 
replace fmpbuff150km=1 if mindistance<=150 
replace fmpbuff200km=1 if mindistance<=200 

keep if fmp_id==1 // keep only one line (same as collapse in this case) - CAREFUL HERE WITH OTHER TIME FRAMES!
drop fmp_id 
keep myear _ID mindistance fmpbuff* numberactivefmpbuff*

merge 1:1 myear _ID using "data/temp_month.dta"
drop _merge 
 
label var fmpbuff50km "FMP within a radius of 50 km"
label var fmpbuff100km "FMP within a radius of 100 km"
label var fmpbuff150km "FMP within a radius of 150 km"
label var fmpbuff200km "FMP within a radius of 200 km"

label var numberactivefmpbuff50km "No. of FMP within a radius of 50 km"
label var numberactivefmpbuff100km "No. of FMP within a radius of 100 km"
label var numberactivefmpbuff150km "No. of FMP within a radius of 150 km"
label var numberactivefmpbuff200km "No. of FMP within a radius of 200 km"

label var cellfmp "Number of FMPs in the cell"

label var mindistance "Distance to nearest FMP (in km)"

replace cellfmp=0 if cellfmp==. // missing means NO fmp in the cell 

*-------------------------------------------------------------------------------------------
* III. Save data
*-------------------------------------------------------------------------------------------

	if  "`path'" == "data/Rdata/" {
	save "data/fmp_cells.dta", replace
	}

	if  "`path'" == "data/Rdata/.5x.5/" {
	save "data/fmp_cells_5x5.dta", replace 
	}

}
