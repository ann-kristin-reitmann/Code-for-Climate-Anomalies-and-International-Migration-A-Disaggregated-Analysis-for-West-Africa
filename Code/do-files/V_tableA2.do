
*-------------------------------------------------------------------------------------------
* Table A2
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates Table A2

*-------------------------------------------------------------------------------
* Data 
*-------------------------------------------------------------------------------

use "data\FMS_2018_2019_clean.dta", clear

*-------------------------------------------------------------------------------
* Data prep
*-------------------------------------------------------------------------------

*merge cell id  

merge m:1 departure_location depcountry using "data\geo_data_final_matched_5x5.dta", force
drop if _merge==2
drop _merge

*set sample for summary statistics
 
egen cellcount=group(cellid)

drop if dest_why_returning==1 // drop return migrants  (7 thousand)

drop if cellid==. // location not found (15 thousand)

keep if destination1==0

replace destination=3 if destination==4 // within region international

drop if departure_country=="GNQ" // only two observations 

*-------------------------------------------------------------------------------
* Summary statistics
*-------------------------------------------------------------------------------

bys destination: tab departure_country_code

tab destination

tab fmp_point 

dis 0.62 + 8.61 + 15.65 + 5.08 + 17.03 + 0.17 + 4.67 + 1.35 + 0.02 + 0.01 + ///
	0.05 + 3.23 + 2.34 + 0.05 + 6.81 + 1.63 + 11.34 + 1.68

/*fmp_point=="Ouagadougou" | ///
| fmp_point=="Boundoufourdou" | ///
| fmp_point=="Kouremale" | ///
| fmp_point=="Nafadji" | ///
| fmp_point=="Bamako" | ///
| fmp_point=="Benena" | ///
| fmp_point=="Gogui" | ///
| fmp_point=="Heremakono" | ///
| fmp_point=="Menaka" | ///
| fmp_point=="Mopti" | ///
| fmp_point=="Place Kidal" | ///
| fmp_point=="Sevare" | ///
| fmp_point=="Tombouctou" | ///
| fmp_point=="Wabaria" | ///
| fmp_point=="Arlit" | ///
| fmp_point=="Seguedine" | ///
| fmp_point=="Kano" | ///
| fmp_point=="Sokoto"*/

*-------------------------------------------------------------------------------
* Output
*-------------------------------------------------------------------------------

*final output created in Excel file
