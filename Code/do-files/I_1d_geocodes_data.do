
*-------------------------------------------------------------------------------------------
* 1d. Data prep do-file: create geocode locations of FMS data   
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file creates the geocodes for the towns and cities reported in the FMS data 
*Note: Most of the do-file is commented out.
*We save geocodes and then proceed to clean the data to avoid running the opencage geo multiple times and update the key every time.

*-------------------------------------------------------------------------------------------
* I. Geocode towns from 2018 and 2019
*-------------------------------------------------------------------------------------------
 		
/*
use "data\FMS_2018_2019_clean.dta", clear

*Collapse data to get one observation per town 

collapse (sum) migrant, by(departure_location depcountry)
sort depcountry departure_location 

*Generate a string with town and country 

gen address=departure_location+","+depcountry

drop if depcountry==""
drop if departure_location==""

keep departure_location depcountry address

opencagegeo , fulladdr(address) key(df4318bdf7f34d23a30e89cca63d99cb)
save "data\geocode_2018_2019.dta", replace
	
keep if g_quality==.

drop g_lat g_lon g_country g_state g_county g_city g_postcode g_street g_number g_confidence g_formatted g_quality

opencagegeo , fulladdr(address) key(6abf1a0264a3494396f471bd354d5876)
save "data\geocode_2018_2019_part2.dta", replace

use "data\geocode_2018_2019.dta", clear

merge 1:1 departure_location depcountry using "data\geocode_2018_2019_part2.dta" , update

save "data\geo_data_town2019.dta", replace 
*/

*-------------------------------------------------------------------------------------------
* II. Clean town data
*-------------------------------------------------------------------------------------------

/*
use "data\geo_data_town2019.dta", clear

drop if departure_location==""

replace departure_location=strltrim(departure_location)

*Replace as missing all coordinates indicating only country

foreach var in g_lat g_lon {
replace `var'="" if g_quality==1
}

*Replace as missing all coordinates where country does not match 

replace g_country="Gambia" 				if g_country=="The Gambia"
replace g_country="Côte d'Ivoire" 		if g_country=="Ivory Coast"
replace g_country="Congo (Brazzaville)" if g_country=="Congo-Brazzaville"

gen flag=1 		if depcountry!=g_country 
replace flag=. 	if g_country==""
sort flag

foreach var in g_lat g_lon {
replace `var'="" if flag==1
}

drop flag

*Merge with other geocodes to compare

keep departure_location depcountry g_lat g_lon g_quality

rename g_lat 		latitude
rename g_lon 		longitude
rename g_quality 	quality 

sort departure_location depcountry 

drop if quality==.

duplicates list
duplicates drop 

merge 1:1 departure_location depcountry using "data\geocodes\geocodes_final.dta"

tostring g_lat, replace
tostring g_lon, replace 

drop if depcountry==""

keep departure_location depcountry latitude longitude g_lat g_lon 

label var longitude 	"longitude"
label var g_lat 		"latitude vdom"
label var g_lon 		"latitude vdom"

*Add missing coordinates 

replace latitude=	"13.325316"		if departure_location==	"Congoussi"			& depcountry==	"Burkina Faso"
replace latitude=	"12.060282"		if departure_location==	"Fada"				& depcountry==	"Burkina Faso"
replace latitude=	"12.820726"		if departure_location==	"Korssimoro"		& depcountry==	"Burkina Faso"
replace latitude=	"13.102763"		if departure_location==	"Takabangou"		& depcountry==	"Burkina Faso"
replace latitude=	"13.566879"		if departure_location==	"Wadougouya"		& depcountry==	"Burkina Faso"
replace latitude=	"13.566796"		if departure_location==	"Wagouya"			& depcountry==	"Burkina Faso"
replace latitude=	"12.586184"		if departure_location==	"Ziniore"			& depcountry==	"Burkina Faso"
replace latitude=	"12.586184"		if departure_location==	"Ziyare"			& depcountry==	"Burkina Faso"
replace latitude=	"13.615766"		if departure_location==	"Center River"		& depcountry==	"Gambia"
replace latitude=	"13.267516"		if departure_location==	"San Yang"			& depcountry==	"Gambia"
replace latitude=	"13.311223"		if departure_location==	"Santa"				& depcountry==	"Gambia"
replace latitude=	"4.901494"		if departure_location==	"Takouraded"		& depcountry==	"Ghana"
replace latitude=	"10.181174"		if departure_location==	"Bofli"				& depcountry==	"Guinea"
replace latitude=	"9.272894"		if departure_location==	"Kerewane"			& depcountry==	"Guinea"
replace latitude=	"7.679871"		if departure_location==	"Zoo"				& depcountry==	"Guinea"
replace latitude=	"24.32297"		if departure_location==	"Kouffra"			& depcountry==	"Libya"
replace latitude=	"32.532448"		if departure_location==	"Tukra"				& depcountry==	"Libya"
replace latitude=	"14.436932"		if departure_location==	"Kayedie"			& depcountry==	"Mali"
replace latitude=	"11.98843"		if departure_location==	"Welessebougou"		& depcountry==	"Mali"
replace latitude=	"14.866791"		if departure_location==	"Kalhou"			& depcountry==	"Niger"
replace latitude=	"13.950475"		if departure_location==	"Mahayi"			& depcountry==	"Niger"
replace latitude=	"6.221173"		if departure_location==	"Akwa Southy"		& depcountry==	"Nigeria"
replace latitude=	"6.101123"		if departure_location==	"Anoacha"			& depcountry==	"Nigeria"
replace latitude=	"4.976156"		if departure_location==	"Calaver"			& depcountry==	"Nigeria"
replace latitude=	"6.654794"		if departure_location==	"Egoja"				& depcountry==	"Nigeria"
replace latitude=	"6.548901"		if departure_location==	"Egueben"			& depcountry==	"Nigeria"
replace latitude=	"6.010486"		if departure_location==	"Ennewi"			& depcountry==	"Nigeria"
replace latitude=	"7.058545"		if departure_location==	"Igalamela Odulu"	& depcountry==	"Nigeria"
replace latitude=	"6.69344"		if departure_location==	"Igbo Ititi"		& depcountry==	"Nigeria"
replace latitude=	"5.809434"		if departure_location==	"Isuikwato"			& depcountry==	"Nigeria"
replace latitude=	"4.9945"		if departure_location==	"Kakukoma Opukoma"	& depcountry==	"Nigeria"
replace latitude=	"8.506271"		if departure_location==	"Lafiyar Barebare"	& depcountry==	"Nigeria"
replace latitude=	"7.731809"		if departure_location==	"Makodi"			& depcountry==	"Nigeria"
replace latitude=	"7.47909"		if departure_location==	"Mangongo"			& depcountry==	"Nigeria"
replace latitude=	"4.866897"		if departure_location==	"Obia Apor"			& depcountry==	"Nigeria"
replace latitude=	"5.488366"		if departure_location==	"Opke"				& depcountry==	"Nigeria"
replace latitude=	"4.991761"		if departure_location==	"Opukuma"			& depcountry==	"Nigeria"
replace latitude=	"6.954935"		if departure_location==	"Owekoro"			& depcountry==	"Nigeria"
replace latitude=	"11.705651"		if departure_location==	"Pataskum"			& depcountry==	"Nigeria"
replace latitude=	"5.463517"		if departure_location==	"Pkokwu"			& depcountry==	"Nigeria"
replace latitude=	"6.085393"		if departure_location==	"Ububra"			& depcountry==	"Nigeria"
replace latitude=	"6.129007"		if departure_location==	"Region Martine"	& depcountry==	"Togo"

replace longitude=	"-1.526391"		if departure_location==	"Congoussi"			& depcountry==	"Burkina Faso"
replace longitude=	"0.367752"		if departure_location==	"Fada"				& depcountry==	"Burkina Faso"
replace longitude=	"-1.073226"		if departure_location==	"Korssimoro"		& depcountry==	"Burkina Faso"
replace longitude=	"0.735404"		if departure_location==	"Takabangou"		& depcountry==	"Burkina Faso"
replace longitude=	"-2.411435"		if departure_location==	"Wadougouya"		& depcountry==	"Burkina Faso"
replace longitude=	"-2.410061"		if departure_location==	"Wagouya"			& depcountry==	"Burkina Faso"
replace longitude=	"-1.299048"		if departure_location==	"Ziniore"			& depcountry==	"Burkina Faso"
replace longitude=	"-1.299048"		if departure_location==	"Ziyare"			& depcountry==	"Burkina Faso"
replace longitude=	"-14.938966"	if departure_location==	"Center River"		& depcountry==	"Gambia"
replace longitude=	"-16.760387"	if departure_location==	"San Yang"			& depcountry==	"Gambia"
replace longitude=	"-14.220064"	if departure_location==	"Santa"				& depcountry==	"Gambia"
replace longitude=	"-1.783176"		if departure_location==	"Takouraded"		& depcountry==	"Ghana"
replace longitude=	"-14.039283"	if departure_location==	"Bofli"				& depcountry==	"Guinea"
replace longitude=	"-9.023366"		if departure_location==	"Kerewane"			& depcountry==	"Guinea"
replace longitude=	"-8.311193"		if departure_location==	"Zoo"				& depcountry==	"Guinea"
replace longitude=	"22.076328"		if departure_location==	"Kouffra"			& depcountry==	"Libya"
replace longitude=	"20.582886"		if departure_location==	"Tukra"				& depcountry==	"Libya"
replace longitude=	"-11.444344"	if departure_location==	"Kayedie"			& depcountry==	"Mali"
replace longitude=	"-7.908778"		if departure_location==	"Welessebougou"		& depcountry==	"Mali"
replace longitude=	"5.51671"		if departure_location==	"Kalhou"			& depcountry==	"Niger"
replace longitude=	"7.671236"		if departure_location==	"Mahayi"			& depcountry==	"Niger"
replace longitude=	"7.081275"		if departure_location==	"Akwa Southy"		& depcountry==	"Nigeria"
replace longitude=	"7.015162"		if departure_location==	"Anoacha"			& depcountry==	"Nigeria"
replace longitude=	"8.342614"		if departure_location==	"Calaver"			& depcountry==	"Nigeria"
replace longitude=	"8.798056"		if departure_location==	"Egoja"				& depcountry==	"Nigeria"
replace longitude=	"6.225815"		if departure_location==	"Egueben"			& depcountry==	"Nigeria"
replace longitude=	"6.910681"		if departure_location==	"Ennewi"			& depcountry==	"Nigeria"
replace longitude=	"7.036003"		if departure_location==	"Igalamela Odulu"	& depcountry==	"Nigeria"
replace longitude=	"7.412083"		if departure_location==	"Igbo Ititi"		& depcountry==	"Nigeria"
replace longitude=	"7.472626"		if departure_location==	"Isuikwato"			& depcountry==	"Nigeria"
replace longitude=	"6.179111"		if departure_location==	"Kakukoma Opukoma"	& depcountry==	"Nigeria"
replace longitude=	"8.523288"		if departure_location==	"Lafiyar Barebare"	& depcountry==	"Nigeria"
replace longitude=	"8.543051"		if departure_location==	"Makodi"			& depcountry==	"Nigeria"
replace longitude=	"6.156429"		if departure_location==	"Mangongo"			& depcountry==	"Nigeria"
replace longitude=	"7.009045"		if departure_location==	"Obia Apor"			& depcountry==	"Nigeria"
replace longitude=	"6.326596"		if departure_location==	"Opke"				& depcountry==	"Nigeria"
replace longitude=	"6.187349"		if departure_location==	"Opukuma"			& depcountry==	"Nigeria"
replace longitude=	"3.17437"		if departure_location==	"Owekoro"			& depcountry==	"Nigeria"
replace longitude=	"11.082571"		if departure_location==	"Pataskum"			& depcountry==	"Nigeria"
replace longitude=	"7.497036"		if departure_location==	"Pkokwu"			& depcountry==	"Nigeria"
replace longitude=	"8.329152"		if departure_location==	"Ububra"			& depcountry==	"Nigeria"
replace longitude=	"1.214893"		if departure_location==	"Region Martine"	& depcountry==	"Togo"

*Replace missing values 

replace g_lat="" 		if g_lat=="."
replace g_lon="" 		if g_lon=="."

replace latitude=g_lat 	if latitude==""
replace longitude=g_lon if longitude==""

replace g_lat=latitude 	if g_lat==""
replace g_lon=longitude if g_lon==""

sort latitude longitude

gen notfound=1 if latitude=="" & longitude==""

replace notfound=0 if latitude!="" & longitude!=""

*Correct the towns that have slightly different spellings

replace latitude="32.485855"  	if departure_location==	"Ghardia"	& depcountry==	"Algeria"
replace longitude="3.677104"  	if departure_location==	"Ghardia"	& depcountry==	"Algeria"

replace latitude="10.53446000"   if departure_location=="Baguero"	& depcountry==	"Burkina Faso" // Town found: Baguera
replace longitude="-5.41898700"  if departure_location=="Baguero"	& depcountry==	"Burkina Faso"

replace latitude="12.69645580"   if departure_location=="Diere"	& depcountry==	"Burkina Faso"
replace longitude="-3.01757120"  if departure_location=="Diere"	& depcountry==	"Burkina Faso"

replace latitude="12.0570943"   if departure_location=="Fadama Gurma City"	& depcountry==	"Burkina Faso"
replace longitude="0.3593297"   if departure_location=="Fadama Gurma City"	& depcountry==	"Burkina Faso"

replace latitude="11.43000000"   if departure_location=="Gombousgou"	& depcountry==	"Burkina Faso" // Town found: Gomboussougou
replace longitude="-0.77000000"   if departure_location=="Gombousgou"	& depcountry==	"Burkina Faso"

replace latitude="11.843044"   if departure_location=="Gwarango"	& depcountry==	"Burkina Faso" // Town found: Gomboussougou
replace longitude="-0.5805564"   if departure_location=="Gwarango"	& depcountry==	"Burkina Faso"

replace latitude="13.1723624"   if departure_location=="Kalissaka"	& depcountry==	"Burkina Faso" // Town found: Kalsaka
replace longitude="-1.982973"   if departure_location=="Kalissaka"	& depcountry==	"Burkina Faso"

replace latitude="11.13204470"   if departure_location=="Karangasso Sangla"	& depcountry==	"Burkina Faso" // Town found: Karankasso Sangla
replace longitude="-4.23333550"   if departure_location=="Karangasso Sangla"	& depcountry==	"Burkina Faso"

replace latitude="12.603759"   if departure_location=="Katango"		& depcountry==	"Burkina Faso" // Town found: Katanga
replace longitude="-1.404896"   if departure_location=="Katango"	& depcountry==	"Burkina Faso"

replace latitude="11.786753"   if departure_location=="Kenkodogo"	& depcountry==	"Burkina Faso" // Town found: Tenkodogo
replace longitude="-0.370869"   if departure_location=="Kenkodogo"	& depcountry==	"Burkina Faso"

replace latitude="12.24970720"   if departure_location=="Madiga"	& depcountry==	"Burkina Faso" // Town found: Mahadaga
replace longitude="1.67606910"   if departure_location=="Madiga"	& depcountry==	"Burkina Faso"

replace latitude="12.889154"   if departure_location=="Sakoinsse"	& depcountry==	"Burkina Faso" // Town found: Sakoensé
replace longitude="-1.974395"   if departure_location=="Sakoinsse"	& depcountry==	"Burkina Faso"

replace latitude="11.4506751"   if departure_location=="Samadeni"	& depcountry==	"Burkina Faso" // Town found: Samandeni
replace longitude="-4.4473882"   if departure_location=="Samadeni"	& depcountry==	"Burkina Faso"

replace latitude="11.786753"   if departure_location=="Tchinkodogo"	& depcountry==	"Burkina Faso" // Town found: Tenkodogo
replace longitude="-0.370869"   if departure_location=="Tchinkodogo"	& depcountry==	"Burkina Faso"

replace latitude="11.786753"   if departure_location=="Tchinkolodo"	& depcountry==	"Burkina Faso" // Town found: Tenkodogo
replace longitude="-0.370869"   if departure_location=="Tchinkolodo"	& depcountry==	"Burkina Faso"

replace latitude="13.927036"   if departure_location=="Thou"	& depcountry==	"Burkina Faso" // Town found: Tou
replace longitude="-2.771765"   if departure_location=="Thou"	& depcountry==	"Burkina Faso"
 
replace latitude="13.588066"   if departure_location=="Yalago"	& depcountry==	"Burkina Faso" // Town found: Yalgo
replace longitude="-0.2653784"   if departure_location=="Yalago"	& depcountry==	"Burkina Faso"
 
replace latitude="11.541372"   if departure_location=="Zoundweogo"	& depcountry==	"Burkina Faso" // Town found: Yalgo
replace longitude="-1.002185"   if departure_location=="Zoundweogo"	& depcountry==	"Burkina Faso"
 
replace latitude="4.75103200"   if departure_location=="Bafia"	& depcountry==	"Cameroon" // Town found: Bafia
replace longitude="11.23084000"   if departure_location=="Bafia"	& depcountry==	"Cameroon"

replace latitude="13.831958"   if departure_location=="Abache"	& depcountry==	"Chad" // Town found: Abeche
replace longitude="20.831570"   if departure_location=="Abache"	& depcountry==	"Chad"
 
replace latitude="13.831958"   if departure_location=="Abech"	& depcountry==	"Chad" // Town found: Abeche
replace longitude="20.831570"   if departure_location=="Abech"	& depcountry==	"Chad"
 
replace latitude="13.50886"   if departure_location=="Djeda"	& depcountry==	"Chad" // Town found: Djeda
replace longitude="18.58968"   if departure_location=="Djeda"	& depcountry==	"Chad"
 
replace latitude="13.50886"   if departure_location=="Djedda"	& depcountry==	"Chad" // Town found: Djeda
replace longitude="18.58968"   if departure_location=="Djedda"	& depcountry==	"Chad"
   
replace latitude="13.46667"   if departure_location=="Farchana Chetete"	& depcountry==	"Chad" // Town found: Djeda
replace longitude="22.2"   if departure_location=="Farchana Chetete"	& depcountry==	"Chad"
  
replace latitude="15.82"   if departure_location=="Kanou"	& depcountry==	"Chad" // Town found: Djeda
replace longitude="22.60"  	 if departure_location=="Kanou"	& depcountry==	"Chad"
     
replace latitude="12.365648"   if departure_location=="Mangalmi"	& depcountry==	"Chad" // Town found: Mangalme
replace longitude="19.615227"  	 if departure_location=="Mangalmi"	& depcountry==	"Chad"
     
replace latitude="12.1191543"   if departure_location=="Ndjamena Boulala"	& depcountry==	"Chad" // Town found: Ndjamena
replace longitude="15.0502758"  	 if departure_location=="Ndjamena Boulala"	& depcountry==	"Chad"
   
replace latitude="1.946652"   if departure_location=="Bolama"	& depcountry==	"Congo (Brazzaville)" // Town found: Bolama
replace longitude="22.978196"  	 if departure_location=="Bolama"	& depcountry==	"Congo (Brazzaville)"
     
replace latitude="6.667663"   if departure_location=="Abingourou"	& depcountry==	"Côte d'Ivoire" // Town found: Abengourou
replace longitude="-3.5107449"  	 if departure_location=="Abingourou"	& depcountry==	"Côte d'Ivoire"
    
replace latitude="5.3531211"   if departure_location=="Adiame"	& depcountry==	"Côte d'Ivoire" // Town found: Adjame
replace longitude="-4.0222008"  	 if departure_location=="Adiame"	& depcountry==	"Côte d'Ivoire"

replace latitude="6.716347"   if departure_location=="Bengourou"	& depcountry==	"Côte d'Ivoire" // Town found: Abengourou
replace longitude="-3.489704"  	 if departure_location=="Bengourou"	& depcountry==	"Côte d'Ivoire"

replace latitude="5.350097"   if departure_location=="Benjeville"	& depcountry==	"Côte d'Ivoire" // Town found: Bingerville
replace longitude="-3.877880"  	 if departure_location=="Benjeville"	& depcountry==	"Côte d'Ivoire"

replace latitude="7.690333"   if departure_location=="Boake"	& depcountry==	"Côte d'Ivoire" // Town found: Buoake
replace longitude="-5.037297"  	 if departure_location=="Boake"	& depcountry==	"Côte d'Ivoire"

replace latitude="5.357367"   if departure_location=="Cocodi"	& depcountry==	"Côte d'Ivoire" // Town found: Cocody
replace longitude="-3.994934"  	 if departure_location=="Cocodi"	& depcountry==	"Côte d'Ivoire"

replace latitude="6.8766904"   if departure_location=="Daloua"	& depcountry==	"Côte d'Ivoire" // Town found: Daloa
replace longitude="-6.4516096"  	 if departure_location=="Daloua"	& depcountry==	"Côte d'Ivoire"

replace latitude="6.8766904"   if departure_location=="Dalwa"	& depcountry==	"Côte d'Ivoire" // Town found: Daloa
replace longitude="-6.4516096"  	 if departure_location=="Dalwa"	& depcountry==	"Côte d'Ivoire"

replace latitude="6.746866"   if departure_location=="Deukoue"	& depcountry==	"Côte d'Ivoire" // Town found: Deukoue
replace longitude="-7.356849"  	 if departure_location=="Deukoue"	& depcountry==	"Côte d'Ivoire"

replace latitude="6.6494254"   if departure_location=="Dimokro"	& depcountry==	"Côte d'Ivoire" // Town found: Dimbokro
replace longitude="-4.7040555"  	 if departure_location=="Dimokro"	& depcountry==	"Côte d'Ivoire"

replace latitude="9.334143"   if departure_location=="Foula Cete Fleuve Guinee"	& depcountry==	"Côte d'Ivoire" // Town found: Foula
replace longitude="-7.783338"  	 if departure_location=="Foula Cete Fleuve Guinee"	& depcountry==	"Côte d'Ivoire"

replace latitude="6.1329749"   if departure_location=="Gagnouwa"	& depcountry==	"Côte d'Ivoire" // Town found: Gagnoa
replace longitude="-5.9517697"   if departure_location=="Gagnouwa"	& depcountry==	"Côte d'Ivoire"

replace latitude="9.4574719"   if departure_location=="Korogho"	& depcountry==	"Côte d'Ivoire" // Town found: Korhogo
replace longitude="-5.6342471"   if departure_location=="Korogho"	& depcountry==	"Côte d'Ivoire"

replace latitude="4.757864"   if departure_location=="Kpote Sanpedro"	& depcountry==	"Côte d'Ivoire" // Town found: San Pedro
replace longitude="-6.642522"   if departure_location=="Kpote Sanpedro"	& depcountry==	"Côte d'Ivoire"

replace latitude="5.302972"   if departure_location=="Kumassi"	& depcountry==	"Côte d'Ivoire" // Town found: San Pedro
replace longitude="-3.942531"   if departure_location=="Kumassi"	& depcountry==	"Côte d'Ivoire"

replace latitude="5.084273"   if departure_location=="Lobakouya Sassandra"	& depcountry==	"Côte d'Ivoire" // Town found: Lobakouya
replace longitude="-6.350257"   if departure_location=="Lobakouya Sassandra"	& depcountry==	"Côte d'Ivoire"

replace latitude="9.466384"   if departure_location=="N Benguebou Korogho"	& depcountry==	"Côte d'Ivoire" // Town found: Korogho
replace longitude="-5.613569"   if departure_location=="N Benguebou Korogho"	& depcountry==	"Côte d'Ivoire"

replace latitude="4.951320"   if departure_location=="Sansadra"	& depcountry==	"Côte d'Ivoire" // Town found: Sassandra
replace longitude="-6.091704"   if departure_location=="Sansadra"	& depcountry==	"Côte d'Ivoire"

replace latitude="5.7852673"   if departure_location=="Soubret"	& depcountry==	"Côte d'Ivoire" // Town found: Soubre
replace longitude="-6.5928329"   if departure_location=="Soubret"	& depcountry==	"Côte d'Ivoire"

replace latitude="4.757864"   if departure_location=="Taki Sanpedro"	& depcountry==	"Côte d'Ivoire" // Town found: San Pedro
replace longitude="-6.642522"   if departure_location=="Taki Sanpedro"	& depcountry==	"Côte d'Ivoire"

replace latitude="9.466384"   if departure_location=="Tangafla Korogho"	& depcountry==	"Côte d'Ivoire" // Town found: Korogho
replace longitude="-5.613569"   if departure_location=="Tangafla Korogho"	& depcountry==	"Côte d'Ivoire"

replace latitude="9.466384"   if departure_location=="Tape Korogho"	& depcountry==	"Côte d'Ivoire" // Town found: Korogho
replace longitude="-5.613569"   if departure_location=="Tape Korogho"	& depcountry==	"Côte d'Ivoire"

replace latitude="5.336164"   if departure_location=="Tekoube"	& depcountry==	"Côte d'Ivoire" // Town found: Attekoube
replace longitude="-4.041482"   if departure_location=="Tekoube"	& depcountry==	"Côte d'Ivoire"

replace latitude="6.555232"   if departure_location=="Toumoudi"	& depcountry==	"Côte d'Ivoire" // Town found: Tomoudi
replace longitude="-5.014552"   if departure_location=="Toumoudi"	& depcountry==	"Côte d'Ivoire"

replace latitude="5.3060059"   if departure_location=="Treize Ville"	& depcountry==	"Côte d'Ivoire" // Town found: Attekoube
replace longitude="-4.0081093"   if departure_location=="Treize Ville"	& depcountry==	"Côte d'Ivoire"

replace latitude="-1.620395"   if departure_location=="France Ville"	& depcountry==	"Gabon" // Town found: France Ville
replace longitude="13.599789"   if departure_location=="France Ville"	& depcountry==	"Gabon"

replace latitude="13.238248"   if departure_location=="Gambisara"	& depcountry==	"Gambia" // Town found: Gambissara
replace longitude="-14.310814"   if departure_location=="Gambisara"	& depcountry==	"Gambia"

replace latitude="6.675753"   if departure_location=="Coumassi"	& depcountry==	"Ghana" // Town found: Kumasi
replace longitude="-1.613361"   if departure_location=="Coumassi"	& depcountry==	"Ghana"

replace latitude="9.539050"   if departure_location=="Madina Quartier"	& depcountry==	"Guinea" // Town found: Madina
replace longitude="-13.667757"   if departure_location=="Madina Quartier"	& depcountry==	"Guinea"

replace latitude="6.328034"   if departure_location=="Monoria"	& depcountry==	"Liberia" // Town found: Monrovia
replace longitude="-10.797788"   if departure_location=="Monoria"	& depcountry==	"Liberia"

replace latitude="6.328034"   if departure_location=="Morovia"	& depcountry==	"Liberia" // Town found: Monrovia
replace longitude="-10.797788"   if departure_location=="Morovia"	& depcountry==	"Liberia"
			
replace latitude="32.7661001"   if departure_location=="Dierma"	& depcountry==	"Libya" // Town found: Derna
replace longitude="22.623984"   if departure_location=="Dierma"	& depcountry==	"Libya"
			
replace latitude="32.428473"   if departure_location=="Tarhounah"	& depcountry==	"Libya" // Town found: Tarhuna
replace longitude="13.641221"   if departure_location=="Tarhounah"	& depcountry==	"Libya"
		
replace latitude="12.649319"   if departure_location=="Bamakoh City"	& depcountry==	"Mali" // Town found: Bamako 
replace longitude="-8.000337"   if departure_location=="Bamakoh City"	& depcountry==	"Mali"
		
replace latitude="13.0435507"   if departure_location=="Barlawilli"	& depcountry==	"Mali" // Town found: Baraoueli
replace longitude="-6.6286552"   if departure_location=="Barlawilli"	& depcountry==	"Mali"

replace latitude="17.0598"   if departure_location=="Azal"	& depcountry==	"Niger" // Town found: Azel
replace longitude="8.0608"   if departure_location=="Azal"	& depcountry==	"Niger"

replace latitude="14.5817017"   if departure_location=="Bada Guichiri"	& depcountry==	"Niger" // Town found: Badaguichiri
replace longitude="5.8829725"   if departure_location=="Bada Guichiri"	& depcountry==	"Niger"

replace latitude="14.582696"   if departure_location=="Bankillare"	& depcountry==	"Niger" // Town found: Bankilare
replace longitude="0.726793"   if departure_location=="Bankillare"	& depcountry==	"Niger"

replace latitude="7.09389"   if departure_location=="Dan Batta"	& depcountry==	"Nigeria" // Town found: Dan Bata
replace longitude="9.073"   if departure_location=="Dan Batta"	& depcountry==	"Nigeria"

replace latitude="5.537932"   if departure_location=="Deslta"	& depcountry==	"Nigeria" // Town found: Delta
replace longitude="5.782259"   if departure_location=="Deslta"	& depcountry==	"Nigeria"

replace latitude="6.7778023"   if departure_location=="Egbabo"	& depcountry==	"Nigeria" // Town found: Egbado
replace longitude="2.9583573"   if departure_location=="Egbabo"	& depcountry==	"Nigeria"

replace latitude="7.3528421"   if departure_location=="Ifedoro"	& depcountry==	"Nigeria" // Town found: Ifedore
replace longitude="5.1103681"   if departure_location=="Ifedoro"	& depcountry==	"Nigeria"

replace latitude="7.4256189"   if departure_location=="Irewolo"	& depcountry==	"Nigeria" // Town found: Irewole
replace longitude="4.218468"   if departure_location=="Irewolo"	& depcountry==	"Nigeria"

replace latitude="12.6538218"   if departure_location=="Kazaoure"	& depcountry==	"Nigeria" // Town found: Kazaure
replace longitude="8.4148078"   if departure_location=="Kazaoure"	& depcountry==	"Nigeria"

replace latitude="10.267607"   if departure_location=="Moubi"	& depcountry==	"Nigeria" // Town found: Mubi
replace longitude="13.264359"   if departure_location=="Moubi"	& depcountry==	"Nigeria"

replace latitude="5.1522715"   if departure_location=="Obingwa"	& depcountry==	"Nigeria" // Town found: Obi Ngwa
replace longitude="7.4478142"   if departure_location=="Obingwa"	& depcountry==	"Nigeria"

replace latitude="6.018614"   if departure_location=="Ogbai"	& depcountry==	"Nigeria" // Town found: Ogboji
replace longitude="7.149879"   if departure_location=="Ogbai"	& depcountry==	"Nigeria"

replace latitude="6.794463"   if departure_location=="Onatcha"	& depcountry==	"Nigeria" // Town found: Onitscha
replace longitude="6.131888"   if departure_location=="Onatcha"	& depcountry==	"Nigeria"

replace latitude="6.713708"   if departure_location=="Oromi"	& depcountry==	"Nigeria" // Town found: Uromi
replace longitude="6.327546"   if departure_location=="Oromi"	& depcountry==	"Nigeria"

replace latitude="12.821936"   if departure_location=="Casamence"	& depcountry==	"Senegal" // Town found: Casamance
replace longitude="-15.0658232"   if departure_location=="Casamence"	& depcountry==	"Senegal"

replace latitude="8.479004"   if departure_location=="Fritawonn"	& depcountry==	"Sierra Leone" // Town found: Free Town
replace longitude="-13.26795"   if departure_location=="Fritawonn"	& depcountry==	"Sierra Leone"

replace latitude="15.648363"   if departure_location=="Am Dourmane"	& depcountry==	"Sudan" // Town found: Umm Durman
replace longitude="32.478157"   if departure_location=="Am Dourmane"	& depcountry==	"Sudan"

replace latitude="15.513439"   if departure_location=="Cartoum"	& depcountry==	"Sudan" // Town found: Khurtum 
replace longitude="32.552342"   if departure_location=="Cartoum"	& depcountry==	"Sudan" 

replace latitude="12.1226814"   if departure_location=="Darafoul"	& depcountry==	"Sudan" // Town found: Darfour
replace longitude="23.3470491"   if departure_location=="Darafoul"	& depcountry==	"Sudan" 

save "data\geo_data_final.dta", replace
*/ 
 
*-------------------------------------------------------------------------------------------
* III. Export data as CSV to read it in QGIS (from Stata to R/QGIS)
*-------------------------------------------------------------------------------------------
 
*Export data as csv -> list of towns containing geocodes

use "data\geo_data_final.dta", clear 
drop g_lat g_lon
drop if latitude=="" & longitude==""
sum // 2,439 observations
export delimited using "data\geo_data_final.csv", replace

*Export data as csv -> List of towns containing geocodes (prepared by Dominik)

use "data\geo_data_final.dta", clear 
drop latitude longitude // 2,227 observations
export delimited using "data\geo_data_final_vdom.csv", replace

/*
READ THE CSV FILE IN R TO MATCH THE POINTS TO THE AFRICA SHAPEFILE WHICH CONTAINS THE CELLS 
THE R FILE IS CALLED TownsAfrica
*/

*-------------------------------------------------------------------------------------------
* IV. Import spatial-match to stata (from QGIS/R to Stata)
*-------------------------------------------------------------------------------------------
 
*Import matched data from R (the R file that matches the info is stored under TownsAfrica)

clear

*1. Start big cells 

import delimited using "data\Rdata\town_cellid.csv", clear
rename latitude_m lat_cellc
rename longitude_ lon_cellc
sum // 

label var latitude 		"Latitude town"
label var longitude 	"Longitude town"
label var lat_cellc 	"Latitude cell centroid"
label var lon_cellc 	"Longitude cell centroid"

drop v1

drop if departure_location==""
replace depcountry="Côte d'Ivoire" if depcountry=="CÃ´te d'Ivoire"

save "data\geo_data_final_matched.dta", replace

* 2. Now small cells 

import delimited using "data\Rdata\.5x.5\town_cellid.csv", clear

sum // 

label var latitude 		"Latitude town"
label var longitude 	"Longitude town"

drop v1 notfound 

drop if departure_location==""
replace depcountry="Côte d'Ivoire" if depcountry=="CÃ´te d'Ivoire"

order id
rename id cellid 

save "data\geo_data_final_matched_5x5.dta", replace

*-------------------------------------------------------------------------------------------
* V. ALTERNATIVE WAY OF MATCHING
*-------------------------------------------------------------------------------------------

*Import the data generated from the spatial match in QGIS 
*This way is visually easier but it is harder to replicate!

/* For matching in QGIS load Harari & La Ferrara shape file (gridded Africa)
then load the vector of geolocations stored as "geo_data_final.csv
then perfom the match input layer: the vector, join layer: the grid
On the joined map, you should be able to see the dots of the towns.*/

/* QGIS MATCH !!! 

clear

import delimited using "data\QGIS\spatial_match.csv"

rename latitude_m lat_cellc
rename longitude_ lon_cellc

sum // 2000 should be matched, for 227 not enough information

label var latitude 		"Latitude town"
label var longitude 	"Longitude town"
label var lat_cellc 	"Latitude cell centroid"
label var lon_cellc 	"Longitude cell centroid"

drop if departure_location==""

replace depcountry="Côte d'Ivoire" if depcountry=="CÃ´te d'Ivoire"

save "data\geo_data_final_matched.dta", replace

*/
