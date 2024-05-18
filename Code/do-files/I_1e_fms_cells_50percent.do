
*-------------------------------------------------------------------------------------------
* 1e. Data prep do-file: match FMS data to raster data (robustness 50%)
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file joins FMS data with the cell id (robustness 50%)
*Note: This data is for running the robustness check "FMPs with best coverage of departure location information"

*-------------------------------------------------------------------------------------------
* I. Append data 
*-------------------------------------------------------------------------------------------
 
foreach data in matched matched_5x5 { 

*Load original data

use "data\FMS_2018_2019_clean_50percent.dta", clear

*Merge cell id  

merge m:1 departure_location depcountry using "data\geo_data_final_`data'.dta", force
drop if _merge==2
drop _merge
 
egen cellcount=group(cellid)

drop if cellid==. // location not found (15 thousand)
drop if dest_why_returning==1 // drop return migrants  (7 thousand)

*-------------------------------------------------------------------------------------------
* II. Identify migrants coming from large cities
*-------------------------------------------------------------------------------------------

*Indicate if migrant comes from the capital: source http://worldpopulationreview.com/continents/cities-in-africa/

gen largecity=0 if departure_location!=""

*Benin: Largest cities: Cotonou, Abomey -- Capital: Porto Novo
	replace largecity=1 if departure_location=="Cotonou" & depcountry=="Benin" 
	replace largecity=1 if departure_location=="Abomey" & depcountry=="Benin" 

*Burkina Faso: Largest cities: Ouagadougou & Bobo, Capital: Ouagadougou
	replace largecity=1 if departure_location=="Ouagadougou" & depcountry=="Burkina Faso" 
	replace largecity=1 if (departure_location=="Bobo" | departure_location=="Bobo Dioulasso" ) & depcountry=="Burkina Faso" 

*Cameroon: Largest cities: Douala & Yaounde, Capital: Douala
	replace largecity=1 if departure_location=="Douala" & depcountry=="Cameroon" 
	replace largecity=1 if (departure_location=="Yaounde" | departure_location=="Yaounde") & depcountry=="Cameroon" 

*Chad: Largest city: N'Djamena & Moundou, Capital: N'Djamena
	replace largecity=1 if (departure_location=="Ndjamena" | departure_location=="Ndjamena Boulala" | departure_location=="Nidjamena") & depcountry=="Chad" 
	replace largecity=1 if (departure_location=="Moundou") & depcountry=="Chad" 

*Ivory Coast: Largest cities: Abidjan & Abobo Capital: Yamoussoukro
	replace largecity=1 if (departure_location=="Abidjan" | departure_location=="Abijan" ) & depcountry=="Côte d'Ivoire" 
	*replace largecity=1 if (departure_location=="Yamoussokro" | departure_location=="Yamoussoukro" | departure_location=="Yaokro Yamoussokro") & depcountry=="Côte d'Ivoire" 
	replace largecity=1 if departure_location=="Abobo" & depcountry=="Côte d'Ivoire" 

*Gabon: Largest cities: Libreville, Capital: Libreville (No one from second largest city Port Gentil)
	replace largecity=1 if (departure_location=="Libre Ville" | departure_location=="Libreville" | departure_location=="Libreville Centre" ) & depcountry=="Gabon" 

*Gambia: Largest cities: Serekunda & Birkama, Capital: Banjul
	replace largecity=1 if (departure_location=="Serekounda" | departure_location=="Serekunda") & depcountry=="Gambia" 
	replace largecity=1 if departure_location=="Birkama" & depcountry=="Gambia" 

*Ghana: Largest cities: Accra & Kumasi, Capital: Accra
	replace largecity=1 if departure_location=="Accra"  & depcountry=="Ghana" 
	replace largecity=1 if (departure_location=="Kumasi" | departure_location=="Kumassi" | departure_location=="Coumassi" ) & depcountry=="Ghana" 

*Guinea: Largest cities: Conakry & Nzerekore & Kankan, Capital: Conakry 
	replace largecity=1 if departure_location=="Conakry" & depcountry=="Guinea"
	replace largecity=1 if departure_location=="Nzerekore"  & depcountry=="Guinea" 
	replace largecity=1 if departure_location=="Kankan"  & depcountry=="Guinea" 
	
*Guinea-Bissau: Largest city: Bissau, Capital: Bissau (the second largest city is very small)
	tab departure_location if depcountry=="Guinea-Bissau" 
	replace largecity=1 if (departure_location=="Bissau")  & depcountry=="Guinea-Bissau" 

*Liberia: Largest cities: Monrovia, Capital: Monrovia 
	replace largecity=1 if (departure_location=="Monoria" | departure_location=="Monrovia" | departure_location=="Morovia")  & depcountry=="Liberia" 
	replace largecity=1 if (departure_location=="Gbarnga")  & depcountry=="Liberia" 

*Mali: Largest cities: Bamako and Sikasso, Capital: Bamako
	replace largecity=1 if departure_location=="Bamako" & depcountry=="Mali" 
	replace largecity=1 if departure_location=="Sikasso"  & depcountry=="Mali" 

*Mauritania: Largest cities:  Nouakchott & Nouadhibou, Capital:  Nouakchott
	replace largecity=1 if departure_location=="Nouakchott" & depcountry=="Mauritania" 
	replace largecity=1 if departure_location=="Nouadhibou"  & depcountry=="Mauritania" 

*Niger: Largest cities:  Niamey & Maradi, Capital:  Niamey
	replace largecity=1 if departure_location=="Niamey" & depcountry=="Niger" 
	replace largecity=1 if departure_location=="Maradi"  & depcountry=="Niger" 

*Nigeria: Largest cities:  Lagos, Capital:  Abuja (Lagos and Kano much larger than capital)
	replace largecity=1 if departure_location=="Lagos" & depcountry=="Nigeria" 
	replace largecity=1 if departure_location=="Kano"  & depcountry=="Nigeria" 
	*replace largecity=1 if departure_location=="Abuja"  & depcountry=="Nigeria" 

*Senegal: Largest cities:  Dakar, Capital:  Dakar (No one from the second largest city)
	tab departure_location if depcountry=="Senegal"
	replace largecity=1 if departure_location=="Dakar" & depcountry=="Senegal" 

*Sierra Leone: Largest city: Freetown, Capital:  Freetown
	replace largecity=1 if departure_location=="Freetown" & depcountry=="Sierra Leone" 
	replace largecity=1 if departure_location=="Fritawonn" & depcountry=="Sierra Leone" 
	replace largecity=1 if departure_location=="Bo" & depcountry=="Sierra Leone" 

*Togo: Largest city: Lomé, Capital: Lomé
	replace largecity=1 if departure_location=="Lome" & depcountry=="Togo" 
	replace largecity=1 if departure_location=="Sokode" & depcountry=="Togo" 

label var largecity "Migrant comes from capital or large city"
label define largecity 1 "Yes" 0 "No"
label val largecity largecity  

*-------------------------------------------------------------------------------------------
* III. Save data
*-------------------------------------------------------------------------------------------

local path `data' 

	if  "`path'" == "matched" {

	save "data\FMS_2018_2019_cells_50percent.dta", replace

	preserve 
	keep if largecity==1 // keep urban migration 
	save "data\FMS_2018_2019_urban_50percent.dta", replace
	restore 

	preserve
	keep if largecity==0 // keep rural migration 
	save "data\FMS_2018_2019_rural_50percent.dta", replace
	restore 
	}
	
	if  "`path'" == "matched_5x5" {

	save "data\FMS_2018_2019_cells_5x5_50percent.dta", replace

	preserve 
	keep if largecity==1 // keep urban migration 
	save "data\FMS_2018_2019_urban_5x5_50percent.dta", replace
	restore 

	preserve
	keep if largecity==0 // keep rural migration 
	save "data\FMS_2018_2019_rural_5x5_50percent.dta", replace
	restore 
	}
	
}
