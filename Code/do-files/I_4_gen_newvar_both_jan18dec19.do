
*-------------------------------------------------------------------------------------------
* 4. Data prep do-file: new variables (robustness Jan 18 - Dec 19)
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file creates new variables for both grid sizes (robustness Jan 18 - Dec 19)
*Note: This data is for running the robustness check "FMPs open Jan 2018 - Dec 2019"

foreach data in 1by1 5by5 {

use "data\cells_`data'_all_jan18dec19.dta", clear 

*-------------------------------------------------------------------------------------------
* I. Define migration at the cell level -- > assign zero or missings (pop data)
*-------------------------------------------------------------------------------------------

	if "`data'" == "1by1" {

		*Generate dummy variable if a cell has a migrant
		
		foreach var in migrant internal international intonmove migafrica migeurope migother {

		gen 		d`var'=1 if `var'>=1 & !mi(`var') 
		replace 	d`var'=0 if `var'==0
		replace 	d`var'=0 if `var'==. &  pop_sum>1000

		gen 		c`var'=`var' if !mi(`var')
		replace 	c`var'=0 if `var'==0
		replace 	c`var'=0 if `var'==.  &  pop_sum>1000

		replace d`var'=. if year<=2017
		replace c`var'=. if year<=2017

		}

		*Replace missings for zeros 	
		
		foreach var in migrant internal international intonmove migafrica migeurope migother {

			replace  `var'=0 if pop_sum>1000 &!mi(pop_sum) & `var'==.  & urban==0 & year>2017
			replace d`var'=0 if pop_sum>1000 &!mi(pop_sum) & d`var'==. & urban==0 & year>2017
			replace c`var'=0 if pop_sum>1000 &!mi(pop_sum) & c`var'==. & urban==0 & year>2017

		}
		
	} 

	if "`data'" == "5by5" {

		*Generate dummy variable if a cell has a migrant
		
		foreach var in migrant internal international intonmove migafrica migeurope migother {

		gen 		d`var'=1 if !mi(`var') 
		replace 	d`var'=0 if `var'==0
		replace 	d`var'=0 if `var'==. &  pop_sum>200

		gen 		c`var'=`var' if !mi(`var')
		replace 	c`var'=0 if `var'==0
		replace 	c`var'=0 if `var'==.  &  pop_sum>200

		replace d`var'=. if year<=2017
		replace c`var'=. if year<=2017

		}

		*Replace missings for zeros 
		
		foreach var in migrant internal international intonmove migafrica migeurope migother {

		replace  `var'=0 if pop_sum>200 &!mi(pop_sum) & `var'==.  & urban==0 & year>2017
		replace d`var'=0 if pop_sum>200 &!mi(pop_sum) & d`var'==. & urban==0 & year>2017
		replace c`var'=0 if pop_sum>200 &!mi(pop_sum) & c`var'==. & urban==0 & year>2017

		}
		
	}

	foreach var in migrant internal international intonmove migafrica migeurope migother {
		replace `var'=. if west!=1 
		replace d`var'=. if west!=1
		replace c`var'=. if west!=1
	}


*Indicator if there is a crop in the cell or not

gen cropincell=.
replace cropincell=1 if cropstr!=""
replace cropincell=0 if cropstr=="No crop"
label var cropincell "Cell has a crop"	

*-------------------------------------------------------------------------------
* II. Binary shocks 
*-------------------------------------------------------------------------------

*Indicator if month is drier than average 

gen shock=0 if lrsma!=. 
replace shock=1 if lrsma<-.999 & lrsma!=.
label var shock "Month drier than average"

gen shock2d=0 if lrsma!=. 
replace shock2d=1 if lrsma<-1.999 & lrsma!=.
label var shock2d "Month drier than average (2 sd)"

*Sum of past 12-months drier than the average 

gen shock12=shock[_n-1]+shock[_n-2]+shock[_n-3]+shock[_n-4]+shock[_n-5]+ ///
			shock[_n-6]+shock[_n-7]+shock[_n-8]+shock[_n-9]+shock[_n-10]+ ///
			shock[_n-11]+shock[_n-12] if _ID==_ID[_n-12]
label var shock12 "Number of dry months in the last 12 months"

gen shock12_2d=shock2d[_n-1]+shock2d[_n-2]+shock2d[_n-3]+shock2d[_n-4]+shock2d[_n-5]+ ///
			shock2d[_n-6]+shock2d[_n-7]+shock2d[_n-8]+shock2d[_n-9]+shock2d[_n-10]+ ///
			shock2d[_n-11]+shock2d[_n-12] if _ID==_ID[_n-12]
label var shock12_2d "Number of dry months in the last 12 months (2sd)"

*Share of past 12-months drier than the average 
				
gen shshock12=shock12/12
label var shshock12 "Share of dry months in the last 12 months"

gen shshock12_2d=shock12_2d/12
label var shshock12_2d "Share of dry months in the last 12 months (2 sd)"

*-------------------------------------------------------------------------------
* III. Positive shocks 
*-------------------------------------------------------------------------------

*Indicator if month is wetter than average 

gen posshock=0 if lrsma!=. 
replace posshock=1 if lrsma>.999 & lrsma!=.
label var posshock "Month wetter than average"

gen posshock2d=0 if lrsma!=. 
replace posshock2d=1 if lrsma>1.999 & lrsma!=.
label var posshock2d "Month wetter than average (2 sd)"

*Sum of past 12-months wetter than the average 

gen posshock12=posshock[_n-1]+posshock[_n-2]+posshock[_n-3]+posshock[_n-4]+posshock[_n-5]+ ///
			posshock[_n-6]+posshock[_n-7]+posshock[_n-8]+posshock[_n-9]+posshock[_n-10]+ ///
			posshock[_n-11]+posshock[_n-12] if _ID==_ID[_n-12]
label var posshock12 "Number of wet months in the last 12 months"

gen posshock12_2d=posshock2d[_n-1]+posshock2d[_n-2]+posshock2d[_n-3]+posshock2d[_n-4]+posshock2d[_n-5]+ ///
			posshock2d[_n-6]+posshock2d[_n-7]+posshock2d[_n-8]+posshock2d[_n-9]+posshock2d[_n-10]+ ///
			posshock2d[_n-11]+posshock2d[_n-12] if _ID==_ID[_n-12]
label var posshock12_2d "Number of wet months in the last 12 months (2sd)"

*Share of past 12-months wetter than the average 	
			
gen shposshock12=posshock12/12
label var shposshock12 "Share of wet months in the last 12 months"

gen shposshock12_2d=posshock12_2d/12
label var shposshock12_2d "Share of wet months in the last 12 months (2 sd)"

*-------------------------------------------------------------------------------
* IV.  Binary shocks during growing season 
*--------------------------------------------------------------------------------

*Indicator if month is drier than average 

gen shockgs=0 if lrsma!=. 
replace shockgs=1 if lrsma<-.999 & lrsma!=. & growcrop==1
label var shock "Month drier than average in growing season"

gen shockgs2d=0 if lrsma!=. 
replace shockgs2d=1 if lrsma<-1.999 & lrsma!=. & growcrop==1
label var shockgs2d "Month drier than average in growing season (2 sd)"

*Sum of past 12-months drier than the average in the growing season

gen shock12gs=shockgs[_n-1]+shockgs[_n-2]+shockgs[_n-3]+shockgs[_n-4]+shockgs[_n-5]+ ///
			  shockgs[_n-6]+shockgs[_n-7]+shockgs[_n-8]+shockgs[_n-9]+shockgs[_n-10]+ ///
			  shockgs[_n-11]+shockgs[_n-12] if _ID==_ID[_n-12]

gen shock12gs_2d=shockgs2d[_n-1]+shockgs2d[_n-2]+shockgs2d[_n-3]+shockgs2d[_n-4]+shockgs2d[_n-5]+ ///
			  shockgs2d[_n-6]+shockgs2d[_n-7]+shockgs2d[_n-8]+shockgs2d[_n-9]+shockgs2d[_n-10]+ ///
			  shockgs2d[_n-11]+shockgs2d[_n-12] if _ID==_ID[_n-12]

*Share of past 12-months drier than the average 	
			
gen shshock12gs=shock12gs/12
replace shshock12gs=. if cropincell==0 //AKR: WHY THE RESTRICTION HERE?
label var shshock12gs "Share of dry months in the last 12 months growing season"

gen shshock12gs_2d=shock12gs_2d/12
replace shshock12gs_2d=. if cropincell==0 //AKR: WHY THE RESTRICTION HERE?
label var shshock12gs_2d "Share of dry months in the last 12 months growing season"

*-------------------------------------------------------------------------------
* V. Shocks outside growing season
*--------------------------------------------------------------------------------

*Indicator if month is drier than average 

gen shocknogs=0 if lrsma!=. 
replace shocknogs=1 if lrsma<-.999 & lrsma!=. & growcrop==0
label var shocknogs "Month drier than average in non growing season"

gen shocknogs2d=0 if lrsma!=. 
replace shocknogs2d=1 if lrsma<-1.999 & lrsma!=. & growcrop==0
label var shocknogs2d "Month drier than average in non growing season (2 sd)"

*Sum of past 12-months drier than the average in the growing season

gen shock12nogs=shocknogs[_n-1]+shocknogs[_n-2]+shocknogs[_n-3]+shocknogs[_n-4]+shocknogs[_n-5]+ ///
			  shocknogs[_n-6]+shocknogs[_n-7]+shocknogs[_n-8]+shocknogs[_n-9]+shocknogs[_n-10]+ ///
			  shocknogs[_n-11]+shocknogs[_n-12] if _ID==_ID[_n-12]

gen shock12nogs_2d=shocknogs2d[_n-1]+shocknogs2d[_n-2]+shocknogs2d[_n-3]+shocknogs2d[_n-4]+shocknogs2d[_n-5]+ ///
			  shocknogs2d[_n-6]+shocknogs2d[_n-7]+shocknogs2d[_n-8]+shocknogs2d[_n-9]+shocknogs2d[_n-10]+ ///
			  shocknogs2d[_n-11]+shocknogs2d[_n-12] if _ID==_ID[_n-12]

*Share of past 12-months drier than the average 
				
gen shshock12nogs=shock12nogs/12
replace shshock12nogs=. if cropincell==0 //AKR: WHY THE RESTRICTION HERE?
label var shshock12nogs "Share of dry months in the last 12 months growing season"

gen shshock12nogs_2d=shock12nogs_2d/12
replace shshock12nogs_2d=. if cropincell==0 //AKR: WHY THE RESTRICTION HERE?
label var shshock12nogs_2d "Share of dry months in the last 12 months growing season"

*-------------------------------------------------------------------------------
* VI. Average LRSMA and SMA
*-------------------------------------------------------------------------------

*Average lrsma in the past 12 months 

gen lrsma12gs= lrsma*growcrop if cropincell==1
	replace lrsma12gs=0 if lrsma12gs==. & cropincell==1
	
gen num2gs=growcrop[_n-1]+growcrop[_n-2] ///
			if _ID==_ID[_n-2]	
			replace num2gs=. if cropincell==0	
			  		  
gen num3gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3] ///
			if _ID==_ID[_n-3]	
			replace num3gs=. if cropincell==0	
			  
gen num4gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4] ///
			if _ID==_ID[_n-4]	
			replace num4gs=. if cropincell==0	
			  
gen num5gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5] ///
			if _ID==_ID[_n-5]	
			replace num5gs=. if cropincell==0	
			  
gen num6gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5]+ ///
			  growcrop[_n-6] if _ID==_ID[_n-6]	
			  replace num6gs=. if cropincell==0
			  		  
gen num7gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5]+ ///
			  growcrop[_n-6]+growcrop[_n-7] if _ID==_ID[_n-7]	
			  replace num7gs=. if cropincell==0
			  			  
gen num8gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5]+ ///
			  growcrop[_n-6]+growcrop[_n-7]+growcrop[_n-8] if _ID==_ID[_n-7]	
			  replace num8gs=. if cropincell==0		
			  
gen num9gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5]+ ///
			  growcrop[_n-6]+growcrop[_n-7]+growcrop[_n-8]+growcrop[_n-9] ///
			  if _ID==_ID[_n-7]	
			  replace num9gs=. if cropincell==0		
			  
gen num10gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5]+ ///
			  growcrop[_n-6]+growcrop[_n-7]+growcrop[_n-8]+growcrop[_n-9]+growcrop[_n-10] ///
			  if _ID==_ID[_n-10]	
			  replace num10gs=. if cropincell==0					  

gen num11gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5]+ ///
			  growcrop[_n-6]+growcrop[_n-7]+growcrop[_n-8]+growcrop[_n-9]+growcrop[_n-10]+ ///
			  growcrop[_n-11] if _ID==_ID[_n-11]
			  replace num11gs=. if cropincell==0
			  
gen num12gs=growcrop[_n-1]+growcrop[_n-2]+growcrop[_n-3]+growcrop[_n-4]+growcrop[_n-5]+ ///
			  growcrop[_n-6]+growcrop[_n-7]+growcrop[_n-8]+growcrop[_n-9]+growcrop[_n-10]+ ///
			  growcrop[_n-11]+growcrop[_n-12] if _ID==_ID[_n-12]	
			  replace num12gs=. if cropincell==0

gen sumlrsma2gs=lrsma12gs[_n-1]+lrsma12gs[_n-2] if _ID==_ID[_n-2]				  			  
			
gen sumlrsma3gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3] if _ID==_ID[_n-3]				  			  
								    
gen sumlrsma4gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4] ///
				if _ID==_ID[_n-4]	

gen sumlrsma5gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5] if _ID==_ID[_n-5]	
									
gen sumlrsma6gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5]+ lrsma12gs[_n-6] if _ID==_ID[_n-6]	
			  
gen sumlrsma7gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5]+ lrsma12gs[_n-6]+lrsma12gs[_n-7] ///
				if _ID==_ID[_n-7]	
			  			    									
gen sumlrsma8gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5]+ lrsma12gs[_n-6]+lrsma12gs[_n-7]+lrsma12gs[_n-8] ///
				if _ID==_ID[_n-8]	
			  			    												
gen sumlrsma9gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5]+ lrsma12gs[_n-6]+lrsma12gs[_n-7]+lrsma12gs[_n-8]+ ///
				lrsma12gs[_n-9] ///
				if _ID==_ID[_n-9]	
			  
gen sumlrsma10gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5]+ lrsma12gs[_n-6]+lrsma12gs[_n-7]+lrsma12gs[_n-8]+ ///
				lrsma12gs[_n-9]+lrsma12gs[_n-10] ///
				if _ID==_ID[_n-10]	
			  
gen sumlrsma11gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5]+ lrsma12gs[_n-6]+lrsma12gs[_n-7]+lrsma12gs[_n-8]+ ///
				lrsma12gs[_n-9]+lrsma12gs[_n-10]+lrsma12gs[_n-11] ///
				if _ID==_ID[_n-11]	
			  	    									    									    													
gen sumlrsma12gs=lrsma12gs[_n-1]+lrsma12gs[_n-2]+lrsma12gs[_n-3]+lrsma12gs[_n-4]+ ///
				lrsma12gs[_n-5]+ lrsma12gs[_n-6]+lrsma12gs[_n-7]+lrsma12gs[_n-8]+ ///
				lrsma12gs[_n-9]+lrsma12gs[_n-10]+lrsma12gs[_n-11]+lrsma12gs[_n-12] ///
				if _ID==_ID[_n-12]	
			   	  
drop lrsma12gs

	foreach num of num 2/12 {
		gen lrsma`num'gs=sumlrsma`num'gs/num`num'gs
		replace lrsma`num'gs=. if lrsma==.	 
		label var lrsma`num'gs "Average SMA index during last `num' months growing season"
		drop num`num'gs sumlrsma`num'gs		
	}

*Crops outside of the growing season 

gen lrsma12nogs= lrsma*nogrowcrop if cropincell==1
replace lrsma12nogs=0 if lrsma12nogs==. & cropincell==1
	
gen num2nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2] ///
			if _ID==_ID[_n-2]	
			replace num2nogs=. if cropincell==0	
			  
gen num3nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3] ///
			if _ID==_ID[_n-3]	
			replace num3nogs=. if cropincell==0		
			  
gen num4nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4] ///
			if _ID==_ID[_n-4]	
			replace num4nogs=. if cropincell==0		
			  
gen num5nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5] ///
			if _ID==_ID[_n-5]	
			replace num5nogs=. if cropincell==0	
			  
gen num6nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5]+ ///
			  nogrowcrop[_n-6] if _ID==_ID[_n-6]	
			  replace num6nogs=. if cropincell==0			  
		  
gen num7nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5]+ ///
			  nogrowcrop[_n-6]+nogrowcrop[_n-7] if _ID==_ID[_n-7]	
			  replace num7nogs=. if cropincell==0
			  			  
gen num8nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5]+ ///
			  nogrowcrop[_n-6]+nogrowcrop[_n-7]+nogrowcrop[_n-8] if _ID==_ID[_n-7]	
			  replace num8nogs=. if cropincell==0		
			  
gen num9nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5]+ ///
			  nogrowcrop[_n-6]+nogrowcrop[_n-7]+nogrowcrop[_n-8]+nogrowcrop[_n-9] ///
			  if _ID==_ID[_n-7]	
			  replace num9nogs=. if cropincell==0		
			  
gen num10nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5]+ ///
			  nogrowcrop[_n-6]+nogrowcrop[_n-7]+nogrowcrop[_n-8]+nogrowcrop[_n-9]+nogrowcrop[_n-10] ///
			  if _ID==_ID[_n-10]	
			  replace num10nogs=. if cropincell==0					  

gen num11nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5]+ ///
			  nogrowcrop[_n-6]+nogrowcrop[_n-7]+nogrowcrop[_n-8]+nogrowcrop[_n-9]+nogrowcrop[_n-10]+ ///
			  nogrowcrop[_n-11] if _ID==_ID[_n-11]
			  replace num11nogs=. if cropincell==0
			  
gen num12nogs=nogrowcrop[_n-1]+nogrowcrop[_n-2]+nogrowcrop[_n-3]+nogrowcrop[_n-4]+nogrowcrop[_n-5]+ ///
			  nogrowcrop[_n-6]+nogrowcrop[_n-7]+nogrowcrop[_n-8]+nogrowcrop[_n-9]+nogrowcrop[_n-10]+ ///
			  nogrowcrop[_n-11]+nogrowcrop[_n-12] if _ID==_ID[_n-12]	
			  replace num12nogs=. if cropincell==0			  			  

gen sumlrsma2nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2] if _ID==_ID[_n-2]				  			  
			
gen sumlrsma3nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3] if _ID==_ID[_n-3]				  			  
								    
gen sumlrsma4nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4] ///
				if _ID==_ID[_n-4]	

gen sumlrsma5nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5] if _ID==_ID[_n-5]	
									
gen sumlrsma6nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5]+ lrsma12nogs[_n-6] if _ID==_ID[_n-6]	
			  
gen sumlrsma7nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5]+ lrsma12nogs[_n-6]+lrsma12nogs[_n-7] ///
				if _ID==_ID[_n-7]	
			  		    									
gen sumlrsma8nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5]+ lrsma12nogs[_n-6]+lrsma12nogs[_n-7]+lrsma12nogs[_n-8] ///
				if _ID==_ID[_n-8]	
			     												
gen sumlrsma9nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5]+ lrsma12nogs[_n-6]+lrsma12nogs[_n-7]+lrsma12nogs[_n-8]+ ///
				lrsma12nogs[_n-9] ///
				if _ID==_ID[_n-9]	
			  
gen sumlrsma10nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5]+ lrsma12nogs[_n-6]+lrsma12nogs[_n-7]+lrsma12nogs[_n-8]+ ///
				lrsma12nogs[_n-9]+lrsma12nogs[_n-10] ///
				if _ID==_ID[_n-10]	
			  
gen sumlrsma11nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5]+ lrsma12nogs[_n-6]+lrsma12nogs[_n-7]+lrsma12nogs[_n-8]+ ///
				lrsma12nogs[_n-9]+lrsma12nogs[_n-10]+lrsma12nogs[_n-11] ///
				if _ID==_ID[_n-11]	
			  	    									    									    													
gen sumlrsma12nogs=lrsma12nogs[_n-1]+lrsma12nogs[_n-2]+lrsma12nogs[_n-3]+lrsma12nogs[_n-4]+ ///
				lrsma12nogs[_n-5]+ lrsma12nogs[_n-6]+lrsma12nogs[_n-7]+lrsma12nogs[_n-8]+ ///
				lrsma12nogs[_n-9]+lrsma12nogs[_n-10]+lrsma12nogs[_n-11]+lrsma12nogs[_n-12] ///
				if _ID==_ID[_n-12]	
			   	  
drop lrsma12nogs

	foreach num of num 2/12 {
	 gen lrsma`num'nogs=sumlrsma`num'nogs/num`num'nogs
	 replace lrsma`num'nogs=. if lrsma==.
	 
	 
	label var lrsma`num'nogs "Average SMA index during last `num' months no growing season"
	drop num`num'nogs sumlrsma`num'nogs		
	
	}
	
*Average lrsma 

gen lrsma2=lrsma[_n-1]+lrsma[_n-2] if _ID==_ID[_n-2]	
	replace lrsma2=lrsma2/2
label var lrsma2 "Av. lrsma in the past 2 months"

gen lrsma3=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3] if _ID==_ID[_n-3]	
	replace lrsma3=lrsma3/3
label var lrsma3 "Av. lrsma in the past 3 months"

gen lrsma4=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+lrsma[_n-4] if _ID==_ID[_n-4]	
	replace lrsma4=lrsma4/4
label var lrsma4 "Av. lrsma in the past 4 months"

gen lrsma5=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+lrsma[_n-4]+lrsma[_n-5] if _ID==_ID[_n-5]	
	replace lrsma5=lrsma5/5
label var lrsma5 "Av. lrsma in the past 5 months"

gen lrsma6=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+ ///
		   lrsma[_n-4]+lrsma[_n-5]+lrsma[_n-6] if _ID==_ID[_n-6]	
	replace lrsma6=lrsma6/6
label var lrsma6 "Av. lrsma in the past 6 months"

gen lrsma7=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+ ///
		   lrsma[_n-4]+lrsma[_n-5]+lrsma[_n-6]+lrsma[_n-7] if _ID==_ID[_n-7]	
	replace lrsma7=lrsma7/7
label var lrsma7 "Av. lrsma in the past 7 months"
		
gen lrsma8=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+ ///
		   lrsma[_n-4]+lrsma[_n-5]+lrsma[_n-6]+lrsma[_n-7]+ ///
		   lrsma[_n-8] if _ID==_ID[_n-8]	
	replace lrsma8=lrsma8/8
label var lrsma8 "Av. lrsma in the past 8 months"
		
gen lrsma9=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+ ///
		   lrsma[_n-4]+lrsma[_n-5]+lrsma[_n-6]+lrsma[_n-7]+ ///
		   lrsma[_n-8]+lrsma[_n-9] if _ID==_ID[_n-9]	
	replace lrsma9=lrsma9/9
label var lrsma9 "Av. lrsma in the past 9 months"
	
gen lrsma10=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+ ///
		   lrsma[_n-4]+lrsma[_n-5]+lrsma[_n-6]+lrsma[_n-7]+ ///
		   lrsma[_n-8]+lrsma[_n-9]+lrsma[_n-10] if _ID==_ID[_n-10]	
	replace lrsma10=lrsma10/10
label var lrsma10 "Av. lrsma in the past 10 months"
			
gen lrsma11=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+ ///
		   lrsma[_n-4]+lrsma[_n-5]+lrsma[_n-6]+lrsma[_n-7]+ ///
		   lrsma[_n-8]+lrsma[_n-9]+lrsma[_n-10]+ ///
		   lrsma[_n-10] if _ID==_ID[_n-10]	
	replace lrsma11=lrsma11/11
label var lrsma11 "Av. lrsma in the past 11 months"
					
gen lrsma12=lrsma[_n-1]+lrsma[_n-2]+lrsma[_n-3]+ ///
		    lrsma[_n-4]+lrsma[_n-5]+lrsma[_n-6]+ ///
		    lrsma[_n-7]+lrsma[_n-8]+lrsma[_n-9]+ ///
		    lrsma[_n-10]+lrsma[_n-11]+lrsma[_n-12] if _ID==_ID[_n-12]	
	replace lrsma12=lrsma12/12
label var lrsma12 "Av. lrsma in the past 12 months"
	
*Outliers 

	foreach var in lrsma lrsma2 lrsma3 lrsma4 lrsma5 ///
	lrsma6 lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 ///
	lrsma lrsma2gs lrsma3gs lrsma4gs lrsma5gs ///
	lrsma6gs lrsma7gs lrsma8gs lrsma9gs lrsma10gs lrsma11gs lrsma12gs ///
	lrsma2nogs lrsma3nogs lrsma4nogs lrsma5nogs ///
	lrsma6nogs lrsma7nogs lrsma8nogs lrsma9nogs lrsma10nogs lrsma11nogs lrsma12nogs {
	replace `var'=. if `var'>=3 
	replace `var'=. if `var'<=-4
	}

*Generate share of migrants at the cell level per 10 thousand inhabitants

foreach var in migrant international intonmove {
gen sh`var'=(c`var'/pop_sum)*10000
}

label var shmigrant 		"Share of migrants per 10 thousand inhabitants"
label var shinternational   "Share of int. migrants per 10 thousand inhabitants"
label var shintonmove       "Share of real int. migrants per 10 thousand inhabitants"

*-------------------------------------------------------------------------------------------
* VII. Save (monthly) data
*-------------------------------------------------------------------------------------------

save "data/final_cell_`data'_month_jan18dec19.dta", replace

*-------------------------------------------------------------------------------------------
* VIII. Data at the yearly level 
*-------------------------------------------------------------------------------------------

*Generate yearly variables 	(migration)

	foreach var in migrant internal international intonmove migafrica migeurope migother {
		egen y`var'=sum(`var'), by(_ID year) missing
	}

label var ymigrant 			"Total migration by year"
label var yinternal			"Total internal migration by year"
label var yinternational	"Total international migration by year"
label var ymigafrica 		"Total international migration within Africa by year"
label var ymigeurope 		"Total international migration to Europe by year"
label var ymigother	 		"Total international migration other by year"

*REMOVE OUTLIERS FOR YEARLY AVERAGE 
	
* Soil moisture average 

replace sma=. if sma>=8  // top 1% missing
replace sma=. if sma<=-3 

replace lrsma=. if lrsma>=3 
replace lrsma=. if lrsma<=-4

foreach var in sma lrsma {
	egen y`var'=mean(`var'), by(_ID year)
	egen y`var'_gs=mean(`var') if growcrop==1, by(_ID year)
	
	replace y`var'_gs=0 if growcrop==0 & cropstr=="No crop"
	egen y`var'_gsmax=max(y`var'_gs), by(_ID year)
	
	replace y`var'_gsmax=. if cropincell==0
	drop y`var'_gs
	rename y`var'_gsmax y`var'_gs
}	

*keep if year>=2017 
*keep if west==1
keep if month==12 
xtset _ID year

*-------------------------------------------------------------------------------------------
* IX. Save (annual) data
*-------------------------------------------------------------------------------------------

save "data/final_cell_`data'_jan18dec19.dta", replace 

}
