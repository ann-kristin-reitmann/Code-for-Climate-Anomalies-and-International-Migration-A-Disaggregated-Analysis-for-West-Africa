
*-------------------------------------------------------------------------------------------
* 1b. Data prep do-file: FMS 2019
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file imports the original FMS data 

*-------------------------------------------------------------------------------------------
* I. Import original excel File
*-------------------------------------------------------------------------------------------

import excel using "data\_orig\FMS_WCA_DATA_2019.xlsx", clear firstrow
save "data\FMS_ALL_2019.dta", replace 

import excel using "data\_orig\Admin2_labels.xlsx", clear firstrow
save "data\Admin2_labels.dta", replace 

use "data\Admin2_labels.dta", clear
sort Rowcacode1 

gen departure_location=ADM2_NAME
gen departure_country=CNTRY_CODE

duplicates drop CNTRY_CODE ADM1_NAME ADM2_NAME CNTRY_NAME Rowcacode1 Rowcacode2 departure_location departure_country, force
duplicates drop  departure_country departure_location, force

save "data\Admin2_labels.dta", replace

*-------------------------------------------------------------------------------------------
* II. Rename variables
*-------------------------------------------------------------------------------------------

use "data\FMS_ALL_2019.dta", clear

rename *, lower

rename 	survey_date							survey_date
rename 	survey_country						survey_country
rename 	flow_monitoring_point_select		fmp_point
rename 	q2_1_nationality					nationality
*rename 	q2_1_nationality_oth				nationality_oth
rename 	q2_2_origin_birthq2_2_1_country		origin_birth_country
*rename 	l									origin_birth_country_oth
rename 	q2_2_origin_birthq2_2_2_admin1		origin_birth_admin1
*rename 	q2_2_origin_birthq2_2_2_admin1_		origin_birth_admin1_oth
rename 	q2_2_origin_birthq2_2_3_admin2		origin_birth_admin2
rename 	q2_2_origin_birthq2_2_4_lang_et		langue_ethny
rename 	q2_3_sex							sex
rename 	q2_4_age							age
rename 	q2_5_marital_status					marital_status
rename 	q2_6_education						education
rename 	q2_5_education_other				education_other
rename 	q2_7_employment_status				employment_status
rename 	q2_8_main_occup						main_occupation
*rename 	q2_8_main_occup_other				main_occupation_oth
rename 	q2_9_occup_description				description_occupation
rename 	q3_departureq3_0_1_country			departure_country
*rename 	q3_departureq3_0_1_country_oth		departure_country_oth
rename 	q3_departureq3_0_2_admin1			departure_admin1
rename 	q3_departureq3_0_2_admin1_oth		departure_admin1_oth
rename 	q3_departureq3_0_3_location			departure_location
rename 	q3_departureq3_0_3_location_oth		departure_location_oth
rename 	q3_2_leave_when						leave_when
rename 	q3_3_forcibly_displaced				forcibly_displaced
rename 	q3_4_attempt_migrate				attempt_migrate
rename 	q3_5_journey_reason					journey_reason
rename 	q3_5_journey_reason_oth				journey_reason_oth
rename 	q3_6_economic_list					economic_reason
rename 	q3_6_economic_list_oth				economic_reason_oth
rename 	q3_7_access_services_list			access_services_list
rename 	q3_7_access_services_list_oth		access_services_list_oth
rename 	q3_8_1_last_transit_y_n				last_transit
rename 	q3_8_2_last_transit_country			transit_country
*rename 	q3_8_2_last_transit_country_oth		transit_country_oth
rename 	q3_8_3_last_transit_admin1			last_transit_admin1
rename 	q3_8_3_last_transit_admin1_oth		last_transit_admin1_oth
rename 	q3_8_4_last_transit_admin2			q3_8_3_last_transit_admin12
rename 	q3_8_5_last_transit_location		last_transit_location
rename 	q3_9_last_transit_main_transpor		last_transit_main_transport
rename 	q3_10_travel_with					travel_with
rename 	q3_11_group_family					group_family
rename 	q3_12_number_ppl_group				number_indiv_group
rename 	q3_13_pay_travel					pay_travel
rename 	q4_1_intended_next_dest_int			next_destination
*rename 	q4_1_intended_next_dest_int_oth		next_destination_oth
rename 	q4_2_intended_final_dest_int_is		final_destination
rename 	q4_2_intended_final_dest_int_ot		final_destination_oth
rename 	q4_3_destination_why				destination_why
rename 	q4_4_staying_current_country_ho		how_long
rename 	q4_5_want_return					want_return
rename 	q4_6_return_when					return_when
rename 	referral							referral_mechanism
rename 	q5_1_difficulties_journey			difficulties_journey
rename 	q5_2_three_difficulties				three_difficulties
rename 	q5_3_need_info						need_info
rename 	q5_4_need_info_type					need_info_type
rename 	comments							comments
	
drop q4_2_intended_final_dest_int2

*-------------------------------------------------------------------------------------------
* III. Label variables
*-------------------------------------------------------------------------------------------

label var	survey_country			"Survey country"
label var	survey_date				"Survey date"
label var	fmp_point				"FMP name"
label var	nationality				"Nationality"
label var	origin_birth_country	"Country of birth"
label var	origin_birth_admin1		"Region of birth (admin 1)"
*label var	origin_birth_admin2		"Province of birth (admin 2)"
label var	langue_ethny			"Ethnicity or language"
label var	sex						"Sex"
label var	age						"Age"
label var	marital_status			"Marital status"
label var	education				"Highest education level"
label var	employment_status		"Employment status before migration"
label var	main_occupation			"Occupation (if employed or self-employed)"
label var	description_occupation	"Job descriptions"
label var	departure_country		"Country of departure"
label var	departure_admin1		"Region of departure (admin 1)"
label var	departure_location		"Village of departure"
label var	leave_when				"Period of departure"
label var	forcibly_displaced		"Forcibly displaced"
label var	attempt_migrate			"Previous attempt to migrate"
label var	journey_reason			"Journey reson"
label var	economic_reason			"Economic reason list "
label var	access_services_list	"Access to services list "
label var	last_transit			"Transit through other countries (binary)"
label var	transit_country			"Last transit country"
label var	last_transit_admin1		"Last transit region (admin 1)"
*label var	last_transit_admin2		"Last transit province (admin 2)"
label var	last_transit_location	"Last transit village"
label var	last_transit_main_transport		"Main transport"
label var	travel_with				"Travels in a group (binary)"
label var	group_family			"Travels with family members (class)"
label var	number_indiv_group		"Number of people in the group "
label var	pay_travel				"Means to finance the trip"
label var	next_destination		"Next destination country"
label var	final_destination		"Final destination country"
label var	destination_why			"Reason to choose destination"
label var	how_long				"Time planned to stay at destination"
label var	want_return				"Intends to return (binary)"
label var	return_when				"Intends to return: when"
label var   referral_mechanism		"Reference mechanism"
label var   difficulties_journey	"Journey difficulties"
label var	three_difficulties		"Main three difficulties"
label var	need_info				"Need information"
label var	need_info_type			"Type of information needed"
label var	comments				"Comments"

*-------------------------------------------------------------------------------------------
* IV. Recode variables
*-------------------------------------------------------------------------------------------

format survey_date %tc
gen date=dofc(survey_date)
format date %td
drop survey_date
rename date survey_date

*Create country codes for all country variables: survey_country origin_birth_country 
*departure_country transit_country next_destination final_destination nationality

label define iso_code ///
4	"Afghanistan"	///
248	"Aland Islands"	///
8	"Albania"	///
12	"Algeria"	///
16	"American Samoa"	///
20	"Andorra"	///
24	"Angola"	///
660	"Anguilla"	///
10	"Antarctica"	///
28	"Antigua and Barbuda"	///
32	"Argentina"	///
51	"Armenia"	///
533	"Aruba"	///
36	"Australia"	///
40	"Austria"	///
31	"Azerbaijan"	///
44	"Bahamas"	///
48	"Bahrain"	///
50	"Bangladesh"	///
52	"Barbados"	///
112	"Belarus"	///
56	"Belgium"	///
84	"Belize"	///
204	"Benin"	///
60	"Bermuda"	///
64	"Bhutan"	///
68	"Bolivia"	///
535	"Bonaire, Sint Eustatius and Saba"	///
70	"Bosnia and Herzegovina"	///
72	"Botswana"	///
74	"Bouvet Island"	///
76	"Brazil"	///
92	"British Virgin Islands"	///
86	"British Indian Ocean Territory"	///
96	"Brunei Darussalam"	///
100	"Bulgaria"	///
854	"Burkina Faso"	///
108	"Burundi"	///
116	"Cambodia"	///
120	"Cameroon"	///
124	"Canada"	///
132	"Cape Verde"	///
136	"Cayman Islands"	///
140	"Central African Republic"	///
148	"Chad"	///
152	"Chile"	///
156	"China"	///
344	"Hong Kong, Special Administrative Region of China"	///
446	"Macao, Special Administrative Region of China"	///
162	"Christmas Island"	///
166	"Cocos (Keeling) Islands"	///
170	"Colombia"	///
174	"Comoros"	///
178	"Congo (Brazzaville)"	///
180	"Congo, Democratic Republic of the"	///
184	"Cook Islands"	///
188	"Costa Rica"	///
384	"Côte d'Ivoire"	///
191	"Croatia"	///
192	"Cuba"	///
531	"Curaçao"	///
196	"Cyprus"	///
203	"Czech Republic"	///
208	"Denmark"	///
262	"Djibouti"	///
212	"Dominica"	///
214	"Dominican Republic"	///
218	"Ecuador"	///
818	"Egypt"	///
222	"El Salvador"	///
226	"Equatorial Guinea"	///
232	"Eritrea"	///
233	"Estonia"	///
231	"Ethiopia"	///
238	"Falkland Islands (Malvinas)"	///
234	"Faroe Islands"	///
242	"Fiji"	///
246	"Finland"	///
250	"France"	///
254	"French Guiana"	///
258	"French Polynesia"	///
260	"French Southern Territories"	///
266	"Gabon"	///
270	"Gambia"	///
268	"Georgia"	///
276	"Germany"	///
288	"Ghana"	///
292	"Gibraltar"	///
300	"Greece"	///
304	"Greenland"	///
308	"Grenada"	///
312	"Guadeloupe"	///
316	"Guam"	///
320	"Guatemala"	///
831	"Guernsey"	///
324	"Guinea"	///
624	"Guinea-Bissau"	///
328	"Guyana"	///
332	"Haiti"	///
334	"Heard Island and Mcdonald Islands"	///
336	"Holy See (Vatican City State)"	///
340	"Honduras"	///
348	"Hungary"	///
352	"Iceland"	///
356	"India"	///
360	"Indonesia"	///
364	"Iran, Islamic Republic of"	///
368	"Iraq"	///
372	"Ireland"	///
833	"Isle of Man"	///
376	"Israel"	///
380	"Italy"	///
388	"Jamaica"	///
392	"Japan"	///
832	"Jersey"	///
400	"Jordan"	///
398	"Kazakhstan"	///
404	"Kenya"	///
296	"Kiribati"	///
408	"Korea, Democratic People's Republic of"	///
410	"Korea, Republic of"	///
414	"Kuwait"	///
417	"Kyrgyzstan"	///
418	"Lao PDR"	///
428	"Latvia"	///
422	"Lebanon"	///
426	"Lesotho"	///
430	"Liberia"	///
434	"Libya"	///
438	"Liechtenstein"	///
440	"Lithuania"	///
442	"Luxembourg"	///
807	"Macedonia, Republic of"	///
450	"Madagascar"	///
454	"Malawi"	///
458	"Malaysia"	///
462	"Maldives"	///
466	"Mali"	///
470	"Malta"	///
584	"Marshall Islands"	///
474	"Martinique"	///
478	"Mauritania"	///
480	"Mauritius"	///
175	"Mayotte"	///
484	"Mexico"	///
583	"Micronesia, Federated States of"	///
498	"Moldova"	///
492	"Monaco"	///
496	"Mongolia"	///
499	"Montenegro"	///
500	"Montserrat"	///
504	"Morocco"	///
508	"Mozambique"	///
104	"Myanmar"	///
516	"Namibia"	///
520	"Nauru"	///
524	"Nepal"	///
528	"Netherlands"	///
530	"Netherlands Antilles"	///
540	"New Caledonia"	///
554	"New Zealand"	///
558	"Nicaragua"	///
562	"Niger"	///
566	"Nigeria"	///
570	"Niue"	///
574	"Norfolk Island"	///
580	"Northern Mariana Islands"	///
578	"Norway"	///
512	"Oman"	///
586	"Pakistan"	///
585	"Palau"	///
275	"Palestinian Territory, Occupied"	///
591	"Panama"	///
598	"Papua New Guinea"	///
600	"Paraguay"	///
604	"Peru"	///
608	"Philippines"	///
612	"Pitcairn"	///
616	"Poland"	///
620	"Portugal"	///
630	"Puerto Rico"	///
634	"Qatar"	///
638	"Réunion"	///
642	"Romania"	///
643	"Russian Federation"	///
646	"Rwanda"	///
652	"Saint-Barthélemy"	///
654	"Saint Helena"	///
659	"Saint Kitts and Nevis"	///
662	"Saint Lucia"	///
663	"Saint-Martin (French part)"	///
666	"Saint Pierre and Miquelon"	///
670	"Saint Vincent and Grenadines"	///
882	"Samoa"	///
674	"San Marino"	///
678	"Sao Tome and Principe"	///
682	"Saudi Arabia"	///
686	"Senegal"	///
688	"Serbia"	///
690	"Seychelles"	///
694	"Sierra Leone"	///
702	"Singapore"	///
534	"Sint Maarten (Dutch part)"	///
703	"Slovakia"	///
705	"Slovenia"	///
90	"Solomon Islands"	///
706	"Somalia"	///
710	"South Africa"	///
239	"South Georgia and the South Sandwich Islands"	///
728	"South Sudan"	///
724	"Spain"	///
144	"Sri Lanka"	///
729	"Sudan"	///
740	"Suriname"	///
744	"Svalbard and Jan Mayen Islands"	///
748	"Swaziland"	///
752	"Sweden"	///
756	"Switzerland"	///
760	"Syrian Arab Republic (Syria)"	///
158	"Taiwan"	///
762	"Tajikistan"	///
834	"Tanzania *, United Republic of"	///
764	"Thailand"	///
626	"Timor-Leste"	///
768	"Togo"	///
772	"Tokelau"	///
776	"Tonga"	///
780	"Trinidad and Tobago"	///
788	"Tunisia"	///
792	"Turkey"	///
795	"Turkmenistan"	///
796	"Turks and Caicos Islands"	///
798	"Tuvalu"	///
800	"Uganda"	///
804	"Ukraine"	///
784	"United Arab Emirates"	///
826	"United Kingdom"	///
840	"United States of America"	///
581	"United States Minor Outlying Islands"	///
858	"Uruguay"	///
860	"Uzbekistan"	///
548	"Vanuatu"	///
862	"Venezuela (Bolivarian Republic of)"	///
704	"Viet Nam"	///
850	"Virgin Islands, US"	///
876	"Wallis and Futuna Islands"	///
732	"Western Sahara"	///
887	"Yemen"	///
894	"Zambia"	///
716	"Zimbabwe", replace 

*Drop all "other" variables:

rename education_other education_oth

foreach var in  education ///
				departure_admin1 departure_location journey_reason ///
				economic_reason access_services_list /*transit_country*/ ///
				last_transit_admin1 final_destination {
				
				replace `var'=`var'_oth if `var'==""
				replace `var'="LBY" if `var'=="LYB" // replace code for Libia
				
				drop `var'_oth 
				
				}
				
*Recode Nationality 

replace origin_birth_country = subinstr(origin_birth_country," ","",.) 
				
*Replace next destination 

replace next_destination="" if next_destination=="NULL"
			
*Recode final destination 

replace final_destination = subinstr(final_destination," ","",.) 
replace final_destination = "FRA" if final_destination=="Fr"
														
local variables  	nationality survey_country origin_birth_country departure_country ///
					transit_country next_destination final_destination

foreach var of varlist `variables' { 

replace `var'=strrtrim(`var')
replace `var'="" if `var'=="NULL"
replace `var'="" if `var'=="NA"
replace `var'="" if `var'=="N/A"
*replace `var'="" if `var'=="Europe"
*replace `var'="" if `var'=="EU"   
replace `var'="" if `var'=="Vers un autre pays"
replace `var'="" if `var'=="Autre"
replace `var'="" if `var'=="other"
replace `var'="" if `var'=="ooo"

gen `var'_code=. 

replace `var'_code=	4	if `var'==	"AFG"
replace `var'_code=	248	if `var'==	"ALA"
replace `var'_code=	8	if `var'==	"ALB"
replace `var'_code=	12	if `var'==	"DZA"
replace `var'_code=	16	if `var'==	"ASM"
replace `var'_code=	20	if `var'==	"AND"
replace `var'_code=	24	if `var'==	"AGO"
replace `var'_code=	660	if `var'==	"AIA"
replace `var'_code=	10	if `var'==	"ATA"
replace `var'_code=	28	if `var'==	"ATG"
replace `var'_code=	32	if `var'==	"ARG"
replace `var'_code=	51	if `var'==	"ARM"
replace `var'_code=	533	if `var'==	"ABW"
replace `var'_code=	36	if `var'==	"AUS"
replace `var'_code=	40	if `var'==	"AUT"
replace `var'_code=	31	if `var'==	"AZE"
replace `var'_code=	44	if `var'==	"BHS"
replace `var'_code=	48	if `var'==	"BHR"
replace `var'_code=	50	if `var'==	"BGD"
replace `var'_code=	52	if `var'==	"BRB"
replace `var'_code=	112	if `var'==	"BLR"
replace `var'_code=	56	if `var'==	"BEL"
replace `var'_code=	84	if `var'==	"BLZ"
replace `var'_code=	204	if `var'==	"BEN"
replace `var'_code=	60	if `var'==	"BMU"
replace `var'_code=	64	if `var'==	"BTN"
replace `var'_code=	68	if `var'==	"BOL"
replace `var'_code=	535	if `var'==	"BES"
replace `var'_code=	70	if `var'==	"BIH"
replace `var'_code=	72	if `var'==	"BWA"
replace `var'_code=	74	if `var'==	"BVT"
replace `var'_code=	76	if `var'==	"BRA"
replace `var'_code=	92	if `var'==	"VGB"
replace `var'_code=	86	if `var'==	"IOT"
replace `var'_code=	96	if `var'==	"BRN"
replace `var'_code=	100	if `var'==	"BGR"
replace `var'_code=	854	if `var'==	"BFA"
replace `var'_code=	108	if `var'==	"BDI"
replace `var'_code=	116	if `var'==	"KHM"
replace `var'_code=	120	if `var'==	"CMR"
replace `var'_code=	124	if `var'==	"CAN"
replace `var'_code=	132	if `var'==	"CPV"
replace `var'_code=	136	if `var'==	"CYM"
replace `var'_code=	140	if `var'==	"CAF"
replace `var'_code=	148	if `var'==	"TCD"
replace `var'_code=	152	if `var'==	"CHL"
replace `var'_code=	156	if `var'==	"CHN"
replace `var'_code=	344	if `var'==	"HKG"
replace `var'_code=	446	if `var'==	"MAC"
replace `var'_code=	162	if `var'==	"CXR"
replace `var'_code=	166	if `var'==	"CCK"
replace `var'_code=	170	if `var'==	"COL"
replace `var'_code=	174	if `var'==	"COM"
replace `var'_code=	178	if `var'==	"COG"
replace `var'_code=	180	if `var'==	"COD"
replace `var'_code=	184	if `var'==	"COK"
replace `var'_code=	188	if `var'==	"CRI"
replace `var'_code=	384	if `var'==	"CIV"
replace `var'_code=	191	if `var'==	"HRV"
replace `var'_code=	192	if `var'==	"CUB"
replace `var'_code=	531	if `var'==	"CUW"
replace `var'_code=	196	if `var'==	"CYP"
replace `var'_code=	203	if `var'==	"CZE"
replace `var'_code=	208	if `var'==	"DNK"
replace `var'_code=	262	if `var'==	"DJI"
replace `var'_code=	212	if `var'==	"DMA"
replace `var'_code=	214	if `var'==	"DOM"
replace `var'_code=	218	if `var'==	"ECU"
replace `var'_code=	818	if `var'==	"EGY"
replace `var'_code=	222	if `var'==	"SLV"
replace `var'_code=	226	if `var'==	"GNQ"
replace `var'_code=	232	if `var'==	"ERI"
replace `var'_code=	233	if `var'==	"EST"
replace `var'_code=	231	if `var'==	"ETH"
replace `var'_code=	238	if `var'==	"FLK"
replace `var'_code=	234	if `var'==	"FRO"
replace `var'_code=	242	if `var'==	"FJI"
replace `var'_code=	246	if `var'==	"FIN"
replace `var'_code=	250	if `var'==	"FRA"
replace `var'_code=	254	if `var'==	"GUF"
replace `var'_code=	258	if `var'==	"PYF"
replace `var'_code=	260	if `var'==	"ATF"
replace `var'_code=	266	if `var'==	"GAB"
replace `var'_code=	270	if `var'==	"GMB"
replace `var'_code=	268	if `var'==	"GEO"
replace `var'_code=	276	if `var'==	"DEU"
replace `var'_code=	288	if `var'==	"GHA"
replace `var'_code=	292	if `var'==	"GIB"
replace `var'_code=	300	if `var'==	"GRC"
replace `var'_code=	304	if `var'==	"GRL"
replace `var'_code=	308	if `var'==	"GRD"
replace `var'_code=	312	if `var'==	"GLP"
replace `var'_code=	316	if `var'==	"GUM"
replace `var'_code=	320	if `var'==	"GTM"
replace `var'_code=	831	if `var'==	"GGY"
replace `var'_code=	324	if `var'==	"GIN"
replace `var'_code=	624	if `var'==	"GNB"
replace `var'_code=	328	if `var'==	"GUY"
replace `var'_code=	332	if `var'==	"HTI"
replace `var'_code=	334	if `var'==	"HMD"
replace `var'_code=	336	if `var'==	"VAT"
replace `var'_code=	340	if `var'==	"HND"
replace `var'_code=	348	if `var'==	"HUN"
replace `var'_code=	352	if `var'==	"ISL"
replace `var'_code=	356	if `var'==	"IND"
replace `var'_code=	360	if `var'==	"IDN"
replace `var'_code=	364	if `var'==	"IRN"
replace `var'_code=	368	if `var'==	"IRQ"
replace `var'_code=	372	if `var'==	"IRL"
replace `var'_code=	833	if `var'==	"IMN"
replace `var'_code=	376	if `var'==	"ISR"
replace `var'_code=	380	if `var'==	"ITA"
replace `var'_code=	388	if `var'==	"JAM"
replace `var'_code=	392	if `var'==	"JPN"
replace `var'_code=	832	if `var'==	"JEY"
replace `var'_code=	400	if `var'==	"JOR"
replace `var'_code=	398	if `var'==	"KAZ"
replace `var'_code=	404	if `var'==	"KEN"
replace `var'_code=	296	if `var'==	"KIR"
replace `var'_code=	408	if `var'==	"PRK"
replace `var'_code=	410	if `var'==	"KOR"
replace `var'_code=	414	if `var'==	"KWT"
replace `var'_code=	417	if `var'==	"KGZ"
replace `var'_code=	418	if `var'==	"LAO"
replace `var'_code=	428	if `var'==	"LVA"
replace `var'_code=	422	if `var'==	"LBN"
replace `var'_code=	426	if `var'==	"LSO"
replace `var'_code=	430	if `var'==	"LBR"
replace `var'_code=	434	if `var'==	"LBY"
replace `var'_code=	438	if `var'==	"LIE"
replace `var'_code=	440	if `var'==	"LTU"
replace `var'_code=	442	if `var'==	"LUX"
replace `var'_code=	807	if `var'==	"MKD"
replace `var'_code=	450	if `var'==	"MDG"
replace `var'_code=	454	if `var'==	"MWI"
replace `var'_code=	458	if `var'==	"MYS"
replace `var'_code=	462	if `var'==	"MDV"
replace `var'_code=	466	if `var'==	"MLI"
replace `var'_code=	470	if `var'==	"MLT"
replace `var'_code=	584	if `var'==	"MHL"
replace `var'_code=	474	if `var'==	"MTQ"
replace `var'_code=	478	if `var'==	"MRT"
replace `var'_code=	480	if `var'==	"MUS"
replace `var'_code=	175	if `var'==	"MYT"
replace `var'_code=	484	if `var'==	"MEX"
replace `var'_code=	583	if `var'==	"FSM"
replace `var'_code=	498	if `var'==	"MDA"
replace `var'_code=	492	if `var'==	"MCO"
replace `var'_code=	496	if `var'==	"MNG"
replace `var'_code=	499	if `var'==	"MNE"
replace `var'_code=	500	if `var'==	"MSR"
replace `var'_code=	504	if `var'==	"MAR"
replace `var'_code=	508	if `var'==	"MOZ"
replace `var'_code=	104	if `var'==	"MMR"
replace `var'_code=	516	if `var'==	"NAM"
replace `var'_code=	520	if `var'==	"NRU"
replace `var'_code=	524	if `var'==	"NPL"
replace `var'_code=	528	if `var'==	"NLD"
replace `var'_code=	530	if `var'==	"ANT"
replace `var'_code=	540	if `var'==	"NCL"
replace `var'_code=	554	if `var'==	"NZL"
replace `var'_code=	558	if `var'==	"NIC"
replace `var'_code=	562	if `var'==	"NER"
replace `var'_code=	566	if `var'==	"NGA"
replace `var'_code=	570	if `var'==	"NIU"
replace `var'_code=	574	if `var'==	"NFK"
replace `var'_code=	580	if `var'==	"MNP"
replace `var'_code=	578	if `var'==	"NOR"
replace `var'_code=	512	if `var'==	"OMN"
replace `var'_code=	586	if `var'==	"PAK"
replace `var'_code=	585	if `var'==	"PLW"
replace `var'_code=	275	if `var'==	"PSE"
replace `var'_code=	591	if `var'==	"PAN"
replace `var'_code=	598	if `var'==	"PNG"
replace `var'_code=	600	if `var'==	"PRY"
replace `var'_code=	604	if `var'==	"PER"
replace `var'_code=	608	if `var'==	"PHL"
replace `var'_code=	612	if `var'==	"PCN"
replace `var'_code=	616	if `var'==	"POL"
replace `var'_code=	620	if `var'==	"PRT"
replace `var'_code=	630	if `var'==	"PRI"
replace `var'_code=	634	if `var'==	"QAT"
replace `var'_code=	638	if `var'==	"REU"
replace `var'_code=	642	if `var'==	"ROU"
replace `var'_code=	643	if `var'==	"RUS"
replace `var'_code=	646	if `var'==	"RWA"
replace `var'_code=	652	if `var'==	"BLM"
replace `var'_code=	654	if `var'==	"SHN"
replace `var'_code=	659	if `var'==	"KNA"
replace `var'_code=	662	if `var'==	"LCA"
replace `var'_code=	663	if `var'==	"MAF"
replace `var'_code=	666	if `var'==	"SPM"
replace `var'_code=	670	if `var'==	"VCT"
replace `var'_code=	882	if `var'==	"WSM"
replace `var'_code=	674	if `var'==	"SMR"
replace `var'_code=	678	if `var'==	"STP"
replace `var'_code=	682	if `var'==	"SAU"
replace `var'_code=	686	if `var'==	"SEN"
replace `var'_code=	688	if `var'==	"SRB"
replace `var'_code=	690	if `var'==	"SYC"
replace `var'_code=	694	if `var'==	"SLE"
replace `var'_code=	702	if `var'==	"SGP"
replace `var'_code=	534	if `var'==	"SXM"
replace `var'_code=	703	if `var'==	"SVK"
replace `var'_code=	705	if `var'==	"SVN"
replace `var'_code=	90	if `var'==	"SLB"
replace `var'_code=	706	if `var'==	"SOM"
replace `var'_code=	710	if `var'==	"ZAF"
replace `var'_code=	239	if `var'==	"SGS"
replace `var'_code=	728	if `var'==	"SSD"
replace `var'_code=	724	if `var'==	"ESP"
replace `var'_code=	144	if `var'==	"LKA"
replace `var'_code=	729	if `var'==	"SDN"
replace `var'_code=	740	if `var'==	"SUR"
replace `var'_code=	744	if `var'==	"SJM"
replace `var'_code=	748	if `var'==	"SWZ"
replace `var'_code=	752	if `var'==	"SWE"
replace `var'_code=	756	if `var'==	"CHE"
replace `var'_code=	760	if `var'==	"SYR"
replace `var'_code=	158	if `var'==	"TWN"
replace `var'_code=	762	if `var'==	"TJK"
replace `var'_code=	834	if `var'==	"TZA"
replace `var'_code=	764	if `var'==	"THA"
replace `var'_code=	626	if `var'==	"TLS"
replace `var'_code=	768	if `var'==	"TGO"
replace `var'_code=	772	if `var'==	"TKL"
replace `var'_code=	776	if `var'==	"TON"
replace `var'_code=	780	if `var'==	"TTO"
replace `var'_code=	788	if `var'==	"TUN"
replace `var'_code=	792	if `var'==	"TUR"
replace `var'_code=	795	if `var'==	"TKM"
replace `var'_code=	796	if `var'==	"TCA"
replace `var'_code=	798	if `var'==	"TUV"
replace `var'_code=	800	if `var'==	"UGA"
replace `var'_code=	804	if `var'==	"UKR"
replace `var'_code=	784	if `var'==	"ARE"
replace `var'_code=	826	if `var'==	"GBR"
replace `var'_code=	840	if `var'==	"USA"
replace `var'_code=	581	if `var'==	"UMI"
replace `var'_code=	858	if `var'==	"URY"
replace `var'_code=	860	if `var'==	"UZB"
replace `var'_code=	548	if `var'==	"VUT"
replace `var'_code=	862	if `var'==	"VEN"
replace `var'_code=	704	if `var'==	"VNM"
replace `var'_code=	850	if `var'==	"VIR"
replace `var'_code=	876	if `var'==	"WLF"
replace `var'_code=	732	if `var'==	"ESH"
replace `var'_code=	887	if `var'==	"YEM"
replace `var'_code=	894	if `var'==	"ZMB"
replace `var'_code=	716	if `var'==	"ZWE"

label val `var'_code  iso_code 

}

label var survey_country_code 		"Survey country code"
label var nationality_code			"Nationality code"
label var origin_birth_country_code "Country of birth code"
label var departure_country_code 	"Country of departure code"
label var transit_country_code 		"Last transit country code"
label var next_destination_code 	"Next destination country code"
label var final_destination_code 	"Final destination country code"

*Encode variables 

replace main_occupation="Armed forces" 													if main_occupation=="armed_forces" | main_occupation=="Forces armées" 
replace main_occupation="Craft and related trade workers" 								if main_occupation== "craft_trade"
replace main_occupation="Managers, professionals, technician clerical support workers" 	if main_occupation=="manager_professionals" | main_occupation=="Gérant(e), professionnel(le), technicien(ne)"
replace main_occupation="Other" 														if main_occupation=="other" | main_occupation=="Autre" 
replace main_occupation="Plant and machine operators, and assemblers" 					if main_occupation=="plant_machine_operators" | main_occupation=="Travailleurs et assembleurs de machines/usine"
replace main_occupation="Service and sales workers" 									if main_occupation=="service_sales" | main_occupation=="Service et ventes"
replace main_occupation="Skilled manual (agriculture, fishery)" 						if main_occupation== "Skilled_manual_agric" |  main_occupation=="Professions élémentaires" | main_occupation=="Travail qualifié (agriculture, pêcherie)"
replace main_occupation="Skilled manual (craft, transport)" 							if main_occupation=="Skilled_manual_craft" | main_occupation=="Transport/Taxi" | main_occupation=="Travail qualifié (artisanat, transport)"
replace main_occupation="Unskilled manual" 												if main_occupation=="unckilled_manual"

replace main_occupation="" if main_occupation=="NULL"
tab main_occupation

*Journey reason

tab journey_reason

*Recode journey reason

tab journey_reason
replace journey_reason="Access to services" 		if journey_reason=="Access to services"
replace journey_reason="Attend family event" 		if journey_reason=="Attend family event" | journey_reason=="attend family event"
replace journey_reason="Economic reasons" 			if journey_reason=="Economic reasons"
replace journey_reason="Economic reasons" 			if journey_reason=="Business"
replace journey_reason="Natural disasters" 			if journey_reason=="Natural disasters"
replace journey_reason="Other" 						if journey_reason=="Other"
replace journey_reason="Other" 						if journey_reason=="Studies"
replace journey_reason="Re-join family" 			if journey_reason=="Re-join family"
replace journey_reason="Violence or persecution"	if journey_reason=="violence"
replace journey_reason="War or conflict" 			if journey_reason=="War/Conflict" | journey_reason=="War/conflict"  
replace journey_reason="Religious event" 			if journey_reason=="religious_event" | journey_reason=="religious event"
replace journey_reason="Tourism" 					if journey_reason=="tourism"

replace journey_reason="Attend Family Event (Wedding, Funeral, Etc.)" 			if journey_reason=="Attend Family Event"
replace journey_reason="Natural Disasters (Floods, Drought, Earthquake, Etc.)" 	if journey_reason=="Natural Disasters"
replace journey_reason="Religious_Event"   										if journey_reason=="Religious Event"
replace journey_reason="Targeted Violence Or Persecution" 						if journey_reason=="Violence"
replace journey_reason="Other" 													if journey_reason=="Studies"
replace journey_reason="Business"												if journey_reason=="Economic Reasons"
	
local variables main_occupation marital_status economic_reason ///
access_services_list 

foreach var of varlist `variables' { 

	replace `var'="" if `var'=="NULL"
	replace `var'="" if `var'=="ooo"
	replace `var'="" if `var'=="Don't want to answer"
	replace `var'=proper(`var')
   
	encode `var', gen(`var'new) 
	tab `var' 
	tab `var'new
	drop `var' 
	rename `var'new `var' 
	
}

foreach var of varlist  origin_birth_admin1 departure_admin1 last_transit_admin1 { 

replace `var'=strrtrim(`var')
replace `var'="" if `var'=="NULL"
replace `var'="" if `var'=="NA"
replace `var'="" if `var'=="ooo"
replace `var'="" if `var'=="Don't want to answer"
replace `var'="" if `var'=="Other"
	
replace `var'=	"Alibori"		if `var'==	"BEN001"
replace `var'=	"Atacora"		if `var'==	"BEN002"
replace `var'=	"Atlantique"	if `var'==	"BEN003"
replace `var'=	"Borgou"		if `var'==	"BEN004"
replace `var'=	"Collines"		if `var'==	"BEN005"
replace `var'=	"Couffo"		if `var'==	"BEN006"
replace `var'=	"Donga"			if `var'==	"BEN007"
replace `var'=	"Littoral"		if `var'==	"BEN008"
replace `var'=	"Mono"			if `var'==	"BEN009"
replace `var'=	"Oueme"			if `var'==	"BEN010"
replace `var'=	"Plateau"		if `var'==	"BEN011"
replace `var'=	"Zou"			if `var'==	"BEN012"
replace `var'=	"Centre"		if `var'==	"BFA013"
replace `var'=	"Boucle du Mouhoun"	if `var'==	"BFA046"
replace `var'=	"Cascades"		if `var'==	"BFA047"
replace `var'=	"Centre-Est"	if `var'==	"BFA048"
replace `var'=	"Centre-Nord"	if `var'==	"BFA049"
replace `var'=	"Centre-Ouest"	if `var'==	"BFA050"
replace `var'=	"Centre-Sud"	if `var'==	"BFA051"
replace `var'=	"Est"			if `var'==	"BFA052"
replace `var'=	"Haut-Bassins"	if `var'==	"BFA053"
replace `var'=	"Nord"			if `var'==	"BFA054"
replace `var'=	"Plateau-Central"	if `var'==	"BFA055"
replace `var'=	"Sahel"			if `var'==	"BFA056"
replace `var'=	"Sud-Ouest"		if `var'==	"BFA057"
replace `var'=	"Ombella MPoko"	if `var'==	"CAF011"
replace `var'=	"Lobaye"		if `var'==	"CAF012"
replace `var'=	"Mambere-Kadei"	if `var'==	"CAF021"
replace `var'=	"Nana-Mambere"	if `var'==	"CAF022"
replace `var'=	"Sangha-Mbaere"	if `var'==	"CAF023"
replace `var'=	"Ouham Pende"	if `var'==	"CAF031"
replace `var'=	"Ouham"			if `var'==	"CAF032"
replace `var'=	"Kemo"			if `var'==	"CAF041"
replace `var'=	"Nana-Gribizi"	if `var'==	"CAF042"
replace `var'=	"Ouaka"			if `var'==	"CAF043"
replace `var'=	"Bamingui-Bangoran"	if `var'==	"CAF051"
replace `var'=	"Haute-Kotto"	if `var'==	"CAF052"
replace `var'=	"Vakaga"		if `var'==	"CAF053"
replace `var'=	"Basse-Kotto"	if `var'==	"CAF061"
replace `var'=	"Mbomou"		if `var'==	"CAF062"
replace `var'=	"Haut-Mbomou"	if `var'==	"CAF063"
replace `var'=	"Bangui"		if `var'==	"CAF071"
replace `var'=	"Agneby"		if `var'==	"CIV002"
replace `var'=	"Bas-Sassandra"	if `var'==	"CIV003"
replace `var'=	"Denguele"		if `var'==	"CIV004"
replace `var'=	"Lacs"			if `var'==	"CIV006"
replace `var'=	"Lagunes"		if `var'==	"CIV007"
replace `var'=	"Moyen Comoe"	if `var'==	"CIV009"
replace `var'=	"NZi Comoe"		if `var'==	"CIV010"
replace `var'=	"Savanes"		if `var'==	"CIV011"
replace `var'=	"Sud-Bandama"	if `var'==	"CIV012"
replace `var'=	"Sud-Comoe"		if `var'==	"CIV013"
replace `var'=	"Vallee du Bandama"	if `var'==	"CIV014"
replace `var'=	"Zanzan"		if `var'==	"CIV016"
replace `var'=	"18 Montagnes"	if `var'==	"CIV017"
replace `var'=	"Fromager"		if `var'==	"CIV018"
replace `var'=	"Haut-Sassandra"	if `var'==	"CIV019"
replace `var'=	"Marahoue"		if `var'==	"CIV020"
replace `var'=	"Moyen-Cavally"	if `var'==	"CIV021"
replace `var'=	"Bafing"		if `var'==	"CIV022"
replace `var'=	"Worodougou"	if `var'==	"CIV023"
replace `var'=	"Adamaoua"		if `var'==	"CMR001"
replace `var'=	"Centre"		if `var'==	"CMR002"
replace `var'=	"Est"			if `var'==	"CMR003"
replace `var'=	"Extreme-Nord"	if `var'==	"CMR004"
replace `var'=	"Littoral"		if `var'==	"CMR005"
replace `var'=	"Nord"			if `var'==	"CMR006"
replace `var'=	"Nord-Ouest"	if `var'==	"CMR007"
replace `var'=	"Ouest"			if `var'==	"CMR008"
replace `var'=	"Sud"			if `var'==	"CMR009"
replace `var'=	"Sud-Ouest"		if `var'==	"CMR010"
replace `var'=	"Bouenza"		if `var'==	"COG001"
replace `var'=	"Cuvette-Ouest"	if `var'==	"COG002"
replace `var'=	"Cuvette"		if `var'==	"COG003"
replace `var'=	"Kouilou"		if `var'==	"COG004"
replace `var'=	"Lekoumou"		if `var'==	"COG005"
replace `var'=	"Likouala"		if `var'==	"COG006"
replace `var'=	"Niari"			if `var'==	"COG007"
replace `var'=	"Plateaux"		if `var'==	"COG008"
replace `var'=	"Pool"			if `var'==	"COG009"
replace `var'=	"Sangha"		if `var'==	"COG010"
replace `var'=	"Estuaire"		if `var'==	"GAB001"
replace `var'=	"Haut-Ogooue"	if `var'==	"GAB002"
replace `var'=	"Moyen-Ogooue"	if `var'==	"GAB003"
replace `var'=	"Ngounie"		if `var'==	"GAB004"
replace `var'=	"Nyanga"		if `var'==	"GAB005"
replace `var'=	"Ogooue-Ivindo"	if `var'==	"GAB006"
replace `var'=	"Ogooue-Lolo"	if `var'==	"GAB007"
replace `var'=	"Ogooue-Maritime"	if `var'==	"GAB008"
replace `var'=	"Woleu-Ntem"	if `var'==	"GAB009"
replace `var'=	"Ashanti"		if `var'==	"GHA024"
replace `var'=	"Brong Ahafo"	if `var'==	"GHA025"
replace `var'=	"Central"		if `var'==	"GHA026"
replace `var'=	"Eastern"		if `var'==	"GHA027"
replace `var'=	"Greater Accra"	if `var'==	"GHA028"
replace `var'=	"Northern"		if `var'==	"GHA029"
replace `var'=	"Upper East"	if `var'==	"GHA030"
replace `var'=	"Upper West"	if `var'==	"GHA031"
replace `var'=	"Volta"			if `var'==	"GHA032"
replace `var'=	"Western"		if `var'==	"GHA033"
replace `var'=	"Boké"			if `var'==	"GIN001"
replace `var'=	"Conakry"		if `var'==	"GIN002"
replace `var'=	"Faranah"		if `var'==	"GIN003"
replace `var'=	"Kankan"		if `var'==	"GIN004"
replace `var'=	"Kindia"		if `var'==	"GIN005"
replace `var'=	"Labé"			if `var'==	"GIN006"
replace `var'=	"Mamou"			if `var'==	"GIN007"
replace `var'=	"Nzérékoré"		if `var'==	"GIN008"
replace `var'=	"Banjul"		if `var'==	"GMB001"
replace `var'=	"Maccarthy Island"	if `var'==	"GMB002"  // also known as Central River
replace `var'=	"Lower River"	if `var'==	"GMB003"
replace `var'=	"North Bank"	if `var'==	"GMB004"
replace `var'=	"Upper River"	if `var'==	"GMB005"
replace `var'=	"Western"		if `var'==	"GMB006"
replace `var'=	"Bafata"		if `var'==	"GNB001"
replace `var'=	"Biombo"		if `var'==	"GNB002"
replace `var'=	"Bolama/Bijagos" if `var'==	"GNB003"
replace `var'=	"Cacheu"		if `var'==	"GNB004"
replace `var'=	"Gabu"			if `var'==	"GNB005"
replace `var'=	"Oio"			if `var'==	"GNB006"
replace `var'=	"Quinara"		if `var'==	"GNB007"
replace `var'=	"Bissau"		if `var'==	"GNB008"
replace `var'=	"Tombali"		if `var'==	"GNB009"
replace `var'=	"Bomi"			if `var'==	"LBR001"
replace `var'=	"Bong"			if `var'==	"LBR002"
replace `var'=	"Gbarpolu"		if `var'==	"LBR003"
replace `var'=	"Grand Bassa"	if `var'==	"LBR004"
replace `var'=	"Grand Cape Mount"	if `var'==	"LBR005"
replace `var'=	"Grand Gedeh"		if `var'==	"LBR006"
replace `var'=	"Grand Kru"		if `var'==	"LBR007"
replace `var'=	"Lofa"			if `var'==	"LBR008"
replace `var'=	"Margibi"		if `var'==	"LBR009"
replace `var'=	"Maryland"		if `var'==	"LBR010"
replace `var'=	"Montserrado"	if `var'==	"LBR011"
replace `var'=	"Nimba"			if `var'==	"LBR012"
replace `var'=	"River Gee"		if `var'==	"LBR013"
replace `var'=	"Rivercess"		if `var'==	"LBR014"
replace `var'=	"Sinoe"			if `var'==	"LBR015"
replace `var'=	"Kayes"			if `var'==	"MLI001"
replace `var'=	"Koulikoro"		if `var'==	"MLI002"
replace `var'=	"Sikasso"		if `var'==	"MLI003"
replace `var'=	"Ségou"			if `var'==	"MLI004"
replace `var'=	"Mopti"			if `var'==	"MLI005"
replace `var'=	"Timbuktu"		if `var'==	"MLI006"
replace `var'=	"Gao"			if `var'==	"MLI007"
replace `var'=	"Kidal"			if `var'==	"MLI008"
replace `var'=	"Bamako"		if `var'==	"MLI009"
replace `var'=	"Adrar"			if `var'==	"MRT001"
replace `var'=	"Assaba"		if `var'==	"MRT002"
replace `var'=	"Brakna"		if `var'==	"MRT003"
replace `var'=	"Dakhlet Nouadhibou"	if `var'==	"MRT004"
replace `var'=	"Gorgol"		if `var'==	"MRT005"
replace `var'=	"Guidimaka"		if `var'==	"MRT006"
replace `var'=	"Hodh ech Chargui"	if `var'==	"MRT007"
replace `var'=	"Hodh el Gharbi"	if `var'==	"MRT008"
replace `var'=	"Inchiri"		if `var'==	"MRT009"
replace `var'=	"Nouakchott"	if `var'==	"MRT010"
replace `var'=	"Tagant"		if `var'==	"MRT011"
replace `var'=	"Tiris Zemmour"	if `var'==	"MRT012"
replace `var'=	"Trarza"		if `var'==	"MRT013"
replace `var'=	"Agadez"		if `var'==	"NER001"
replace `var'=	"Diffa"			if `var'==	"NER002"
replace `var'=	"Dosso"			if `var'==	"NER003"
replace `var'=	"Maradi"		if `var'==	"NER004"
replace `var'=	"Tahoua"		if `var'==	"NER005"
replace `var'=	"Tillabéry"		if `var'==	"NER006"
replace `var'=	"Zinder"		if `var'==	"NER007"
replace `var'=	"Niamey"		if `var'==	"NER008"
replace `var'=	"Abia"			if `var'==	"NGA001"
replace `var'=	"Adamawa"		if `var'==	"NGA002"
replace `var'=	"Akwa Ibom"		if `var'==	"NGA003"
replace `var'=	"Anambra"		if `var'==	"NGA004"
replace `var'=	"Bauchi"		if `var'==	"NGA005"
replace `var'=	"Bayelsa"		if `var'==	"NGA006"
replace `var'=	"Benue"			if `var'==	"NGA007"
replace `var'=	"Borno"			if `var'==	"NGA008"
replace `var'=	"Cross River"	if `var'==	"NGA009"
replace `var'=	"Delta"			if `var'==	"NGA010"
replace `var'=	"Ebonyi"		if `var'==	"NGA011"
replace `var'=	"Edo"			if `var'==	"NGA012"
replace `var'=	"Ekiti"			if `var'==	"NGA013"
replace `var'=	"Enugu"			if `var'==	"NGA014"
replace `var'=	"Federal Capital Territory"	if `var'==	"NGA015"
replace `var'=	"Gombe"			if `var'==	"NGA016"
replace `var'=	"Imo"			if `var'==	"NGA017"
replace `var'=	"Jigawa"		if `var'==	"NGA018"
replace `var'=	"Kaduna"		if `var'==	"NGA019"
replace `var'=	"Kano"			if `var'==	"NGA020"
replace `var'=	"Katsina"		if `var'==	"NGA021"
replace `var'=	"Kebbi"			if `var'==	"NGA022"
replace `var'=	"Kogi"			if `var'==	"NGA023"
replace `var'=	"Kwara"			if `var'==	"NGA024"
replace `var'=	"Lagos"			if `var'==	"NGA025"
replace `var'=	"Nassarawa"		if `var'==	"NGA026"
replace `var'=	"Niger"			if `var'==	"NGA027"
replace `var'=	"Ogun"			if `var'==	"NGA028"
replace `var'=	"Ondo"			if `var'==	"NGA029"
replace `var'=	"Osun"			if `var'==	"NGA030"
replace `var'=	"Oyo"			if `var'==	"NGA031"
replace `var'=	"Plateau"		if `var'==	"NGA032"
replace `var'=	"Rivers"		if `var'==	"NGA033"
replace `var'=	"Sokoto"		if `var'==	"NGA034"
replace `var'=	"Taraba"		if `var'==	"NGA035"
replace `var'=	"Yobe"			if `var'==	"NGA036"
replace `var'=	"Zamfara"		if `var'==	"NGA037"
replace `var'=	"Dakar"			if `var'==	"SEN001"
replace `var'=	"Diourbel"		if `var'==	"SEN002"
replace `var'=	"Fatick"		if `var'==	"SEN003"
replace `var'=	"Kaffrine"		if `var'==	"SEN004"
replace `var'=	"Kaolack"		if `var'==	"SEN005"
replace `var'=	"Kédougou"		if `var'==	"SEN006"
replace `var'=	"Kolda"			if `var'==	"SEN007"
replace `var'=	"Louga"			if `var'==	"SEN008"
replace `var'=	"Matam"			if `var'==	"SEN009"
replace `var'=	"Saint-Louis"	if `var'==	"SEN010"
replace `var'=	"Sédhiou"		if `var'==	"SEN011"
replace `var'=	"Tambacounda"	if `var'==	"SEN012"
replace `var'=	"Thiès"			if `var'==	"SEN013"
replace `var'=	"Ziguinchor"	if `var'==	"SEN014"
replace `var'=	"Kailahun"		if `var'==	"SLE0101"
replace `var'=	"Kenema"		if `var'==	"SLE0102"
replace `var'=	"Kono"			if `var'==	"SLE0103"
replace `var'=	"Bombali"		if `var'==	"SLE0201"
replace `var'=	"Kambia"		if `var'==	"SLE0202"
replace `var'=	"Koinadugu"		if `var'==	"SLE0203"
replace `var'=	"Port Loko"		if `var'==	"SLE0204"
replace `var'=	"Tonkolili"		if `var'==	"SLE0205"
replace `var'=	"Bo"			if `var'==	"SLE0301"
replace `var'=	"Bonthe"		if `var'==	"SLE0302"
replace `var'=	"Moyamba"		if `var'==	"SLE0303"
replace `var'=	"Pujehun"		if `var'==	"SLE0304"
replace `var'=	"Western Area Rural"	if `var'==	"SLE0401"
replace `var'=	"Western Area Urban"	if `var'==	"SLE0402"
replace `var'=	"Kailahun"		if `var'==	"SLE001001"
replace `var'=	"Kenema"		if `var'==	"SLE001002"
replace `var'=	"Kono"			if `var'==	"SLE001003"
replace `var'=	"Bombali"		if `var'==	"SLE002001"
replace `var'=	"Kambia"		if `var'==	"SLE002002"
replace `var'=	"Koinadugu"		if `var'==	"SLE002003"
replace `var'=	"Port Loko"		if `var'==	"SLE002004"
replace `var'=	"Tonkolili"		if `var'==	"SLE002005"
replace `var'=	"Bo"			if `var'==	"SLE003001"
replace `var'=	"Bonthe"		if `var'==	"SLE003002"
replace `var'=	"Moyamba"		if `var'==	"SLE003003"
replace `var'=	"Pujehun"		if `var'==	"SLE003004"
replace `var'=	"Western Area Rural"	if `var'==	"SLE004001"
replace `var'=	"Western Area Urban"	if `var'==	"SLE004002"
replace `var'=	"Principe"		if `var'==	"STP001"
replace `var'=	"Sao Tome"		if `var'==	"STP002"
replace `var'=	"Batha"			if `var'==	"TCD001"
replace `var'=	"Borkou"		if `var'==	"TCD002"
replace `var'=	"Chari-Baguirmi"	if `var'==	"TCD003"
replace `var'=	"Guéra"			if `var'==	"TCD004"
replace `var'=	"Hadjer-Lamis"	if `var'==	"TCD005"
replace `var'=	"Kanem"			if `var'==	"TCD006"
replace `var'=	"Lac"			if `var'==	"TCD007"
replace `var'=	"Logone Occidental"	if `var'==	"TCD008"
replace `var'=	"Logone Oriental"	if `var'==	"TCD009"
replace `var'=	"Mandoul"		if `var'==	"TCD010"
replace `var'=	"Mayo-Kebbi Est"	if `var'==	"TCD011"
replace `var'=	"Mayo-Kebbi Ouest"	if `var'==	"TCD012"
replace `var'=	"Moyen-Chari"	if `var'==	"TCD013"
replace `var'=	"Ouaddaï"		if `var'==	"TCD014"
replace `var'=	"Salamat"		if `var'==	"TCD015"
replace `var'=	"Tandjilé"		if `var'==	"TCD016"
replace `var'=	"Wadi Fira"		if `var'==	"TCD017"
replace `var'=	"Ville de N'Djamena"		if `var'==	"TCD018"
replace `var'=	"Barh el Ghazel" if `var'==	"TCD019"
replace `var'=	"Ennedi Est"	if `var'==	"TCD020"
replace `var'=	"Sila"			if `var'==	"TCD021"
replace `var'=	"Tibesti"		if `var'==	"TCD022"
replace `var'=	"Ennedi Ouest"	if `var'==	"TCD023"
replace `var'=	"Centrale"		if `var'==	"TGO001"
replace `var'=	"Kara"			if `var'==	"TGO002"
replace `var'=	"Maritime"		if `var'==	"TGO003"
replace `var'=	"Plateaux"		if `var'==	"TGO004"
replace `var'=	"Savanes"		if `var'==	"TGO005"

*Corrections

replace `var'=	"Boké"		 if `var'==	"Boke"
replace `var'=	"Nzérékoré"  if `var'==	"Nzerekore"

replace `var'=	"Nassarawa"  if `var'==	"Nasarawa"
replace `var'=	"Tillabéry"  if `var'==	"Tillabery"
replace `var'=	"Timbuktu"  if `var'==	"Tombouctou"

replace `var'=	"Ségou"  if `var'==	"Segou"
replace `var'=	"Tandjilé"  if `var'==	"Tandjile"

replace `var'=  "Saint-Louis" if `var'==	"Saint Louis"
replace `var'=  "Thiès" if `var'==	"Thies"

replace `var'=	"Tambacounda"		if `var'==	"Tamabacounda"
replace `var'=	"Mayo-Kebbi Est"	if `var'==	"Mayo Kebbi Est"
replace `var'=	"Ville de N'Djamena" if `var'==	"NDjamena"
replace `var'=	"Ville de N'Djamena" if `var'==	"N'Djamena"

replace `var'= "Chari-Baguirmi"	 if `var'==	"Bousso" // city in Chari-Baguirimi
replace `var'= "Wadi Fira" 	 if `var'=="Kobé" // city in Chari-Baguirimi
replace `var'= "Wadi Fira" if `var'== "Kobé " // city in Chari-Baguirimi
replace `var'= "Ville de N'Djamena" if `var'=="Mossoro" // city in Valley  Ville de N'Djamena

replace `var'="Haut-Bassins" if `var'=="Hauts-Bassins"

}

*Replace missing values for last_transit_location from new variable 

replace last_transit_location=q3_8_3_last_transit_admin12 if last_transit_location==""
replace last_transit_location=strrtrim(last_transit_location)
drop q3_8_3_last_transit_admin12
	
loc s fmp_point /*origin_birth_admin2*/ langue_ethny departure_location /*last_transit_admin2*/ last_transit_location

foreach var of varlist `s' { 

		replace `var'="" if `var'=="NULL"
		replace `var'="" if `var'=="NA"
		replace `var'="" if `var'=="ooo"

        replace `var' = subinstr(`var', "Á", "a", .)
        replace `var' = subinstr(`var', "É", "e", .)
        replace `var' = subinstr(`var', "Í", "i", .)
        replace `var' = subinstr(`var', "Ó", "o", .)
        replace `var' = subinstr(`var', "Ú", "u", .)
        replace `var' = subinstr(`var', "á", "a", .)
        replace `var' = subinstr(`var', "é", "e", .)
        replace `var' = subinstr(`var', "í", "i", .)
        replace `var' = subinstr(`var', "ó", "o", .)
        replace `var' = subinstr(`var', "ú", "u", .)
        replace `var' = subinstr(`var', "À", "a", .)
        replace `var' = subinstr(`var', "È", "e", .)
        replace `var' = subinstr(`var', "Ì", "i", .)
        replace `var' = subinstr(`var', "Ò", "o", .)
        replace `var' = subinstr(`var', "Ù", "u", .)
        replace `var' = subinstr(`var', "à", "a", .)
        replace `var' = subinstr(`var', "è", "e", .)
        replace `var' = subinstr(`var', "ì", "i", .)
        replace `var' = subinstr(`var', "ò", "o", .)
        replace `var' = subinstr(`var', "ù", "u", .)
		replace `var' = subinstr(`var', "Î", "i", .)
		replace `var' = subinstr(`var', "(", "", .)
		replace `var' = subinstr(`var', ")", "", .)
		replace `var' = subinstr(`var', "-", " ", .)
		replace `var' = subinstr(`var', "_", " ", .)
		replace `var' = subinstr(`var', "/", " ", .)
		replace `var' = subinstr(`var', "'", "", .)
		replace `var' = subinstr(`var', ".", "", .)
		replace `var' = subinstr(`var', ",", "", .)
		replace `var' = subinstr(`var', "ï", "i", .)
		replace `var' = subinstr(`var', "â", "a", .)
		replace `var' = subinstr(`var', "ê", "e", .)
		replace `var' = subinstr(`var', "ô", "e", .)
		replace `var' = subinstr(`var', "ç", "c", .)
		replace `var' = subinstr(`var', "", "c", .)
		replace `var' = subinstr(`var', "", "", .)
		replace `var' = subinstr(`var', `"""', "", .)
		
		replace `var'=strrtrim(`var')
		replace `var'=stritrim(`var')
		replace `var'=strproper(`var')
 
}

*-------------------------------------------------------------------------------------------
* V. Create additional variables
*-------------------------------------------------------------------------------------------
 
* Sex 

replace sex=strproper(sex)
gen sexnew=.
replace sexnew=0 if sex=="Female"
replace sexnew=1 if sex=="Male"
label def sexnew 0 "Female" 1 "Male", replace
label val sexnew sexnew
tab sex sexnew 
drop sex
rename sexnew sex 
label var sex "Gender Male=1"

*Education
 
replace education=proper(education)

gen educationnew=.
replace educationnew=1 if education=="None"
replace educationnew=2 if education=="Primary"
replace educationnew=3 if education=="Secondary Lower"
replace educationnew=4 if education=="Secondary Upper"
replace educationnew=5 if education=="Tertiary"
replace educationnew=6 if education=="Post Graduate"
replace educationnew=7 if education=="Professional Training"
replace educationnew=8 if education=="Koranic School"
replace educationnew=9 if education=="Other"

drop education 
rename educationnew education 

label define education ///
	1 "None"             ///
	2 "Primary"            ///
	3 "Lower Secondary"    ///
	4 "Upper Secondary"    ///
	5 "Tertiary (Bachelors/Masters)"  ///
	6 "Postgraduate (PhD/PostDoc)"  ///
	7 "Professional training (more than 1 year)" /// 
	8 "Religious school: Islamic" /// 
	9 "Other" , replace 
label val education education 
label var education "Highest education level"

*Employment_status

replace employment_status=itrim(employment_status)
replace employment_status="" if employment_status=="No answer"
replace employment_status="" if employment_status=="Don't want answer"
replace employment_status="" if employment_status=="no answer"

gen employment_statusnew=.

replace employment_statusnew=1 if employment_status=="Employed"
replace employment_statusnew=2 if employment_status=="Self-employed"
replace employment_statusnew=3 if employment_status=="Unemployed - looking for a job"
replace employment_statusnew=4 if employment_status=="Unemployed - not looking for a job"
replace employment_statusnew=5 if employment_status=="Student" 
replace employment_statusnew=6 if employment_status=="Retired"

drop employment_status
rename employment_statusnew employment_status

label define employment_status ///
	1 "Employed"             ///
	2 "Self-employed"            ///
	3 "Unemployed looking for a job"    ///
	4 "Unemployed not looking for a job"    ///
	5 "Student"  ///
	6 "Retired" , replace 
label val employment_status employment_status
label var employment_status "Employment status before migration"

*Leave when 

gen leave_whennew=. 
replace leave_whennew=1 if leave_when=="Less than 2 weeks"
replace leave_whennew=2 if leave_when=="Between 2 weeks and 3 months ago"
replace leave_whennew=3 if leave_when=="Between 3 and 6 months ago"
replace leave_whennew=4 if leave_when=="More than 6 months ago"

label define leave_when ///
	1 "Today or less than 2 weeks ago" ///
	2 "Between 2 weeks and 3 months ago" ///
	3 "Between 3 and 6 months ago" ///
	4 "More than 6 months ago", replace
label val leave_whennew leave_when 
tab leave_when leave_whennew
drop leave_when
rename leave_whennew leave_when

label var leave_when "Period of departure"

*Forcibly displaced & attempt to migrate & referral 

foreach var of varlist forcibly_displaced attempt_migrate referral_mechanism ///
difficulties_journey {

replace `var'=strproper(`var')

gen `var'new=.
	replace `var'new=1 if `var'=="Yes"
	replace `var'new=0 if `var'=="No"

	label def yesno 0 "No" 1 "Yes", replace
	label val `var'new yesno
	tab `var' `var'new
	drop `var'
	rename `var'new `var'
}	

label var 	forcibly_displaced 		"Forcibly displaced" 	
label var 	attempt_migrate 			"Previous attempt to migrate" 	
label var 	referral_mechanism 		"Previous attempt to migrate" 	
label var   difficulties_journey	"Journey difficulties"
label var	need_info				"Need information"

*Last transit

gen last_transitnew=.
	replace last_transitnew=1 if last_transit=="transit"
	replace last_transitnew=0 if last_transit=="na"
	label def transit 0 "No, just started" 1 "Yes", replace
	label val last_transitnew transit 
	tab last_transit last_transitnew
	drop last_transit
	rename last_transitnew last_transit
	
label var last_transit "Transit through other countries (binary)"

*Travel with 

gen travel_withnew=.
	replace travel_withnew=1 if travel_with=="group"
	replace travel_withnew=0 if travel_with=="alone"
	label def travel_with 0 "Alone" 1 "Group", replace
	label val travel_withnew travel_with 
	tab travel_with travel_withnew
	drop travel_with
	rename travel_withnew travel_with
	
label var travel_with "Travels in a group (binary)"
	
*Group family

gen group_familynew=.
	replace group_familynew=1 if group_family=="NULL"
	replace group_familynew=2 if group_family=="adults"
	replace group_familynew=3 if group_family=="children"
	replace group_familynew=4 if group_family=="no"
	
label def group_family ///
	1 "Traveling alone" ///
	2 "Traveling with family (adults)" ///
	3 "Traveling with family (children)" ///
	4 "Traveling in a group (no family)" , replace
label val group_familynew group_family
	
replace group_familynew=. if travel_with==. // missing if no info in the previous question	
tab group_familynew group_family
drop group_family
rename group_familynew group_family

label var group_family "Travels with family members (class)"

*Number individuals group

*replace number_indiv_group="" if number_indiv_group=="NULL"
*destring number_indiv_group, replace 

*Last_transit_main_transport

replace last_transit_main_transport="" if last_transit_main_transport=="NULL"
drop al am an ao ap aq ar as at au av

foreach var in air_plane animal bike boat bus truck motorbike private_vehicle other foot {

	gen transit_main_`var'=0 
	replace transit_main_`var'=1 if strpos(last_transit_main_transport, "`var'")
	replace transit_main_`var'=. if last_transit_main_transport==""
	label var transit_main_`var' "Main transport: `var'"
	
	label def yesno 1 "Yes" 0 "No", replace 
	label val transit_main_`var' yesno

}

*Pay travel 

replace pay_travel="" if pay_travel=="NULL"
replace pay_travel="" if pay_travel=="no_answer"

drop bc q3_13_pay_travelsavings q3_13_pay_travelfamily_friends q3_13_pay_travelearnings q3_13_pay_travelno_answer q3_13_pay_travelother q3_13_pay_travel_other

foreach var in earnings family_friends_abroad family_friends_origin savings other {

	gen pay_travel_`var'=0 
	replace pay_travel_`var'=1 if strpos(pay_travel, "`var'")
	replace pay_travel_`var'=. if pay_travel==""
	
	label var pay_travel_`var' "Paid for trip: `var'"
	
	label def yesno 1 "Yes" 0 "No", replace 
	label val pay_travel_`var' yesno

}

*Destination why

replace destination_why="" if destination_why=="NULL"
replace destination_why="" if destination_why=="no_answer"
replace destination_why="" if destination_why=="unknown"
replace destination_why="" if destination_why=="unknown no_answer"

foreach var in socioecon_cond safety returning job_opp ///
followed_friends asylum relatives_dest network only_choice seasonal other {

	gen dest_why_`var'=0 
	replace dest_why_`var'=1 if strpos(destination_why, "`var'")
	replace dest_why_`var'=. if destination_why==""

	label def yesno 1 "Yes" 0 "No", replace 
	label val dest_why_`var' yesno

}

	label var dest_why_socioecon_cond   "Dest. reason: appealing economic cond."
	label var dest_why_safety 			"Dest. reason: safety"
	label var dest_why_returning 		"Dest. reason: returning to my country"
	label var dest_why_job_opp 			"Dest. reason: job opportunities"
	label var dest_why_followed_friends "Dest. reason: following family or friends"	
	label var dest_why_asylum 		    "Dest. reason: ease of access to asylum"
	label var dest_why_relatives_dest   "Dest. reason: realtives at destination country"
	label var dest_why_network 			"Dest. reason: network of co-nationals"
	label var dest_why_only_choice      "Dest. reason: only choice"
	label var dest_why_seasonal 		"Dest. reason: seasonal migration"
	label var dest_why_other 			"Dest. reason: other"

*How long

gen how_longnew=.
	replace how_longnew=1 if how_long=="one_week"
	replace how_longnew=2 if how_long=="one_week_three_months"
	replace how_longnew=3 if how_long=="three_to_12_months"
	replace how_longnew=4 if how_long=="more_than_one_year"
	replace how_longnew=5 if how_long=="not_planning_leave"
	replace how_longnew=6 if how_long=="unknown"

label def how_long ///
	1 "One week" ///
	2 "One week-3 months" ///
	3 "3-12 months" ///
	4 "More than one year" ///
	5 "Not planning to leave" ///
	6 "Doesn't know", replace
label val how_longnew how_long 	
tab  how_long how_longnew
drop how_long 
rename how_longnew how_long
label var how_long "Time planned to stay at destination"
	
*Intention to return 

gen want_returnnew=. 

	replace want_returnnew=1 if want_return=="yes_no_matter_what"
	replace want_returnnew=2 if want_return=="yes_as_soon_as_conditions_permit"
	replace want_returnnew=3 if want_return=="no_dontwant"
	replace want_returnnew=4 if want_return=="no_cannot"
	replace want_returnnew=5 if want_return=="unknown"
	
label def want_return ///
	1 "Yes, no matter what" ///
	2 "Yes, as soon as conditions permit" ///
	3 "No, I don't want" ///
	4 "No, I can't go back home" ///
	5 "I don't know", replace 	 
label val want_returnnew want_return 
tab  want_return want_returnnew
drop want_return 
rename want_returnnew want_return
label var	want_return "Intends to return (class)"
	
*Return when 

gen return_whennew=. 
	replace return_whennew=1 if return_when=="Within this week" | return_when=="In the week" 
	replace return_whennew=2 if return_when=="Between one week and 3 months"
	replace return_whennew=3 if return_when=="Between three or 12 months"
	replace return_whennew=4 if return_when=="In one year or later" 
	replace return_whennew=5 if return_when=="Cannot go back" 
	replace return_whennew=6 if return_when=="unknown" | return_when=="Never"

label define return_when ///
	1 "Whithin this week" ///
	2 "Between 2 weeks and 3 months" ///
	3 "Between 3 and 12 months" ///
	4 "More than one year" ///
	5 "Cannot go back" ///
	6 "Doesn't know", replace
	
label val return_whennew return_when 
tab return_when return_whennew
drop return_when
rename return_whennew return_when

label var return_when "Intends to return: when"

*Need info type (no info)
/*
gen need_info_typenew=. 
	replace need_info_typenew=1 if need_info_type=="info_return"
	replace need_info_typenew=2 if need_info_type=="info_medical"
	replace need_info_typenew=3 if need_info_type=="info_risks_route"
	replace need_info_typenew=4 if need_info_type=="legal_info"
	replace need_info_typenew=5 if need_info_type=="info_job"
	replace need_info_typenew=6 if need_info_type=="practical_info"
	replace need_info_typenew=7 if need_info_type=="info_dest"
	replace need_info_typenew=8 if need_info_type=="other"
	
label def need_info_type ///
	1 "Return and repatriation" ///
	2 "Medical services" ///
	3 "Risks on the route" ///
	4 "Legal information" ///
	5 "Job opportunities" ///
	6 "Practical information" ///
	7 "Destination country" ///
	8 "Other", replace 
label val need_info_typenew need_info_type 	
tab need_info_type need_info_typenew, m
drop need_info_type
rename need_info_typenew need_info_type

label var need_info_type	"Type of information needed"
*/
	
drop q4_3*
drop q5_*
drop qq5_*

order survey_country survey_country_code survey_date fmp_point ///
nationality nationality_code origin_birth_country origin_birth_country_code ///
origin_birth_admin1 /*origin_birth_admin2*/ langue_ethny sex age marital_status ///
education employment_status main_occupation description_occupation ///
departure_country  departure_country_code departure_admin1 departure_location leave_when ///
forcibly_displaced attempt_migrate journey_reason economic_reason ///
access_services_list last_transit transit_country transit_country_code last_transit_admin1 ///
/*last_transit_admin2*/ last_transit_location last_transit_main_transport ///
transit_main_air_plane transit_main_animal transit_main_bike transit_main_boat ///
transit_main_bus transit_main_truck transit_main_motorbike ///
transit_main_private_vehicle transit_main_other transit_main_foot ///
travel_with group_family number_indiv_group pay_travel pay_travel_earnings ///
pay_travel_family_friends_abroad pay_travel_family_friends_origin ///
pay_travel_savings pay_travel_other next_destination next_destination_code ///
final_destination final_destination_code destination_why dest_why_socioecon_cond ///
dest_why_safety dest_why_returning dest_why_job_opp dest_why_followed_friends ///
dest_why_asylum dest_why_relatives_dest dest_why_network dest_why_only_choice ///
dest_why_seasonal dest_why_other how_long want_return return_when ///
referral_mechanism difficulties_journey three_difficulties need_info ///
need_info_type comments

*drop start end today simserial subscriberid deviceid phonenumber metainstanceid metainstancename _id _index

*-------------------------------------------------------------------------------------------
* VI. Save data
*-------------------------------------------------------------------------------------------

save "data\FMS_WCA_2019_clean.dta",  replace
