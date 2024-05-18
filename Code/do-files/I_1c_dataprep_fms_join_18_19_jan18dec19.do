
*-------------------------------------------------------------------------------------------
* 1c. Data prep do-file: join FMS 2018 and 2019 (robustness Jan 18 - Dec 19)
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file joins FMS data for 2018 and 2019 (robustness Jan 18 - Dec 19)
*Note: This data is for running the robustness check "FMPs open Jan 2018 - Dec 2019"

*-------------------------------------------------------------------------------------------
* I. Append data 
*-------------------------------------------------------------------------------------------

use "data\FMS_WCA_2018_clean.dta", clear
append using "data\FMS_WCA_2019_clean.dta"

replace departure_location=strltrim(departure_location)

*Identify migrants in the database

gen migrant=1 
replace migrant=0 if journey_reason=="Attend family event" | journey_reason=="Religious event" | journey_reason=="Tourism" // exclude those attending family events, religious events, or tourists 
replace migrant=0 if journey_reason=="Economic reasons" & (economic_reason==2 | economic_reason==3) // exclude those in business trips and commuting 
replace migrant=1 if return_when==3 // Migrant plans to return within the week
label var migrant "Individual is a migrant"

*Drop duplicates 

duplicates list
duplicates drop //799 observations deleted

gen id_ind=_n 
label var id_ind "Individual count"

*-------------------------------------------------------------------------------------------
* II. Create additional variables 
*-------------------------------------------------------------------------------------------

*Restrict sample to migrants
 
keep if migrant==1 //21,083 observations deleted
 
*Restrict sample to migrants from Central and Western Africa
 
tab departure_country_code

merge m:1 departure_country_code using "data\region_country.dta"
drop if _merge==2 
drop _merge

bys region : tab departure_country_code 
 
drop if region!="Africa" //982 observations deleted
drop if intermediateregioncode==.   // keep only Central and Western Africa, 9,619 observations deleted)
 
*Generate year 

gen s_month=month(survey_date)
label var s_month "Survey month"

gen year=year(survey_date)
label var year "Survey year"

*Create quarter-year variable for panel --> Here you can change the timing !

gen 	quarter=1 if s_month==1  | s_month==2  | s_month==3
replace quarter=2 if s_month==4  | s_month==5  | s_month==6
replace quarter=3 if s_month==7  | s_month==8  | s_month==9
replace quarter=4 if s_month==10 | s_month==11 | s_month==12
label var quarter "Suvey quarter"

gen 	qyear=yq(year, quarter)
format	qyear %tq
label var qyear "Suvey date quarterly"

gen myear=ym(year, s_month)
format myear %tm 
label var myear "Suvery date monthly"

decode final_destination_code, gen(final_destination_str)

gen destination=. 

replace destination=1 if departure_country==final_destination & departure_country!="" & final_destination!=""
replace destination=2 if departure_country!=final_destination & departure_country!="" & final_destination!=""

replace destination=3 if final_destination_str=="Belgium"
replace destination=3 if final_destination_str=="Bulgaria"
replace destination=3 if final_destination_str=="Croatia"
replace destination=3 if final_destination_str=="Cyprus"
replace destination=3 if final_destination_str=="Denmark"
replace destination=3 if final_destination_str=="Finland"
replace destination=3 if final_destination_str=="France"
replace destination=3 if final_destination_str=="Germany"
replace destination=3 if final_destination_str=="Greece"
replace destination=3 if final_destination_str=="Hungary"
replace destination=3 if final_destination_str=="Iceland"
replace destination=3 if final_destination_str=="Ireland"
replace destination=3 if final_destination_str=="Italy"
replace destination=3 if final_destination_str=="Netherlands"
replace destination=3 if final_destination_str=="Norway"
replace destination=3 if final_destination_str=="Poland"
replace destination=3 if final_destination_str=="Portugal"
replace destination=3 if final_destination_str=="Romania"
replace destination=3 if final_destination_str=="Serbia"
replace destination=3 if final_destination_str=="Spain"
replace destination=3 if final_destination_str=="Sweden"
replace destination=3 if final_destination_str=="Switzerland"
replace destination=3 if final_destination_str=="Ukraine"
replace destination=3 if final_destination_str=="United Kingdom"
replace destination=3 if final_destination=="EU"
replace destination=3 if final_destination=="EUROPE"

replace destination=4 if final_destination_str=="Australia"
replace destination=4 if final_destination_str=="Brazil"
replace destination=4 if final_destination_str=="Canada"
replace destination=4 if final_destination_str=="China"
replace destination=4 if final_destination_str=="Korea, Republic of"
replace destination=4 if final_destination_str=="Lebanon"
replace destination=4 if final_destination_str=="Mexico"
replace destination=4 if final_destination_str=="Qatar"
replace destination=4 if final_destination_str=="Russian Federation" 
replace destination=4 if final_destination_str=="Saudi Arabia" 
replace destination=4 if final_destination_str=="Thailand" 
replace destination=4 if final_destination_str=="United Arab Emirates" 
replace destination=4 if final_destination_str=="United States of America" 
replace destination=4 if final_destination_str=="India"
replace destination=4 if final_destination_str=="Iran, Islamic Republic of"
replace destination=4 if final_destination_str=="Iraq"
replace destination=4 if final_destination_str=="Turkey"

label def destination ///
	1 "Internal migrant" ///
	2 "International: within Africa" ///
	3 "International: Europe" ///
	4 "International: other", replace 
label val destination destination 
label var destination "Destination categorical"

replace final_destination_str="" if final_destination_code==.

*Destination 

tab destination, gen(destination)

*Generate the list of towns/cities

decode departure_country_code, gen(depcountry)
 
*Correct departure country 

replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Alger" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Annaba" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Batna" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Bechar" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Bejaia" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Birtouta" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Birtouta" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Biskra" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Blida" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Bou Saada" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Bousaada" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Constantine" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Djelfa" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Draria" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="El Menia" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Ghardia" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Jijel" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Laghouat" 
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Mascara"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Medea"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Msila"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Oran"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Ouargla"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Setif"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Tamanrasset"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Tiaret"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Tindouf"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Tizi Ouzou"
replace depcountry="Algeria" if depcountry=="Benin" & departure_location=="Tlemcen"
                                                                						 
replace departure_location="Djougou"  	if departure_location=="Djounjou" & depcountry=="Benin"
replace departure_location="Tanguieta"  if departure_location=="Tandjeta" & depcountry=="Benin"
 
replace departure_location="" 					if departure_location=="Autre" 			& depcountry=="Burkina Faso"		 
replace departure_location="Barsalogo"  		if departure_location=="Barsalaogo" 	& depcountry=="Burkina Faso"
replace departure_location="Beguedo"  			if departure_location=="Begda" 			& depcountry=="Burkina Faso"
replace departure_location="Bobo Dioulasso"  	if departure_location=="Bobodioulasso" 	& depcountry=="Burkina Faso"
replace departure_location="Guiba"  			if departure_location=="Guivo" 			& depcountry=="Burkina Faso"
 
replace departure_location="Bamenda"  if departure_location=="Baminga Town" & depcountry=="Cameroon"

replace departure_location="" 				if departure_location=="Autre" 			& depcountry=="Chad"		 
replace departure_location="Djere" 			if departure_location=="Djerere" 		& depcountry=="Chad"		 
replace departure_location="Doba" 			if departure_location=="Doboua" 		& depcountry=="Chad"		 
replace departure_location="Hadjar Hadid" 	if departure_location=="Hadjar Oubeid" 	& depcountry=="Chad"		 
replace departure_location="Hidjelidje" 	if departure_location=="Hile Djadid" 	& depcountry=="Chad"		 
replace departure_location="Kolon" 			if departure_location=="Konon" 			& depcountry=="Chad"		 
replace departure_location="Maro" 			if departure_location=="Maroud" 		& depcountry=="Chad"		 
replace departure_location="Oum Hadjar" 	if departure_location=="Oumouhajar" 	& depcountry=="Chad"		 

replace departure_location="Abengourou" 	if departure_location=="Abengou" 		& depcountry=="Côte d'Ivoire"		 
replace departure_location="Daloa" 			if departure_location=="Daloala" 		& depcountry=="Côte d'Ivoire"		 
replace departure_location="Daloa" 			if departure_location=="Daloua" 		& depcountry=="Côte d'Ivoire"		 
replace departure_location="Daloa" 			if departure_location=="Daola" 			& depcountry=="Côte d'Ivoire"		 
replace departure_location="Marcori" 		if departure_location=="Marcory" 		& depcountry=="Côte d'Ivoire"		 
replace departure_location="Sinematiali" 	if departure_location=="Sinimatiali" 	& depcountry=="Côte d'Ivoire"		                                                           
replace departure_location="Tai" 			if departure_location=="Taii" 			& depcountry=="Côte d'Ivoire"		 
replace departure_location="Tiassale" 		if departure_location=="Tiassale Frontiere" & depcountry=="Côte d'Ivoire"		 
replace departure_location="Tiassale" 		if departure_location=="Tiassale Frontiere Liberia" & depcountry=="Côte d'Ivoire"		 
replace departure_location="Yopougon" 		if departure_location=="Yopongon" 		& depcountry=="Côte d'Ivoire"		 
replace departure_location="Bolgatanga" 	if departure_location=="Bolgatenga" 	& depcountry=="Ghana"		 
                                                                          
replace departure_location="Koronthie" 		if departure_location=="Koronthy" 		& depcountry=="Guinea"		 
replace departure_location="Lola" 			if departure_location=="Lolah" 			& depcountry=="Guinea"		 
 
replace departure_location="" 					if departure_location=="Autre" 				& depcountry=="Mali"		                                                                         
replace departure_location="Diankountey" 		if departure_location=="Diancounte Camara" 	& depcountry=="Mali"		                                                                         
replace departure_location="Kalabancoro" 		if departure_location=="Kalabancoura" 		& depcountry=="Mali"		                                                                           
replace departure_location="Kati Koko" 			if departure_location=="Kati Kokoplateau" 	& depcountry=="Mali"		                                                                                      
replace departure_location="Kounda" 			if departure_location=="Koundan" 			& depcountry=="Mali"		                                                                         
replace departure_location="Menaka" 			if departure_location=="Menega" 			& depcountry=="Mali"		                                                                         
replace departure_location="Ouelesse Bougou" 	if departure_location=="Ouelessoubougou" 	& depcountry=="Mali"		                                                                                                         
replace departure_location="Pelengana" 			if departure_location=="Pelenga" 			& depcountry=="Mali"		                                                                         

replace departure_location="Teyaret" 			if departure_location=="Theyarid" 			& depcountry=="Mauritania"		                                                                         
                                  
replace departure_location=""				 if departure_location=="Autre" 		& depcountry=="Niger"		                                                                         
replace departure_location="Tera"			 if departure_location=="Terra" 		& depcountry=="Niger"		                                                                         
replace departure_location="" 				 if departure_location=="Autre" 		& depcountry=="Nigeria"		                                                                                                           
replace departure_location="Guedam" 		 if departure_location=="Guedem" 		& depcountry=="Nigeria"		                                                                         
replace departure_location="Ilejemeje" 		 if departure_location=="Ilemeji" 		& depcountry=="Nigeria"		                                                                         
replace departure_location="Ini" 			 if departure_location=="Ini Ltu" 		& depcountry=="Nigeria"		                                                                         
replace departure_location="Llorin" 		 if departure_location=="Llori" 		& depcountry=="Nigeria"		                                                                         
replace departure_location="Maiduguri" 		 if departure_location=="Maidougouri" 	& depcountry=="Nigeria"		                                                                         
replace departure_location="Velingara" 		 if departure_location=="Velangra" 		& depcountry=="Senegal"		                                                                         
replace departure_location="Freetown" 		 if departure_location=="Freetawn" 		& depcountry=="Sierra Leone"		                                                                         
replace departure_location="Cinkasse" 		 if departure_location=="Cinkasse Sud" 	& depcountry=="Togo"		                                                                         
replace departure_location="Palime" 		 if departure_location=="Paleme" 		& depcountry=="Togo"
		                                                                         
*-------------------------------------------------------------------------------------------
* III. Correct FMP_point
*------------------------------------------------------------------------------------------- 

replace fmp_point="Seguedine" 	if fmp_point=="Madama" //Madama same as Seguedine 
replace fmp_point="Seguedine" 	if fmp_point=="Agadez" & (nationality=="SEN" | nationality=="NGA") //Agadez is the region where Segudeine and Arlit lie
replace fmp_point="Arlit" 		if fmp_point=="Agadez" & (nationality!="SEN" & nationality!="NGA") //about half of Agadez migrants allocated to Seguedine and the other half to Arlit

*-------------------------------------------------------------------------------------------
* IV. Drop migrants coming from FMPs that were not open Jan 2018 to December 2019
*------------------------------------------------------------------------------------------- 

*only keep migrants from FMPs that were open Jan 2018 to December 2019

keep if 	fmp_point=="Ouagadougou" | ///
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
| fmp_point=="Sokoto"
                                                           
*-------------------------------------------------------------------------------------------
* V. Save data
*-------------------------------------------------------------------------------------------
															   
save "data\FMS_2018_2019_clean_jan18dec19.dta", replace

