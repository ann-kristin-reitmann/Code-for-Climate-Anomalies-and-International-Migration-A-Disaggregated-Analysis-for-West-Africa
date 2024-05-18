
*-------------------------------------------------------------------------------------------
* 7a. Data prep do-file: quarterly data
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024

*This do-file generates the quarterly data

*-------------------------------------------------------------------------------
* I. Prepare quartely data 5x5
*-------------------------------------------------------------------------------

*Identify cells included in final sample 

use "data/final_cell_5by5_month_sample.dta", clear

	keep _ID 
	duplicates drop 
	gen flag=1
	
save "data\junk.dta", replace 

*Prepare quartely data 

use "data/final_cell_5by5_month.dta", clear

xtset _ID myear

eststo clear

*-------------------------------------------------------------------------------
* II. Merge irrigation variables 
*-------------------------------------------------------------------------------

drop _merge
merge m:1 _ID using "data/irrigation_area.dta"
drop if _merge==2
drop _merge

gen irrdummy=0
replace irrdummy=1 if irrigation>=5
label var irrdummy "Cell has an irrigation system"

gen irrdummyinv=1
replace irrdummyinv=0 if irrigation>=10
label var irrdummyinv "Cell has no irrigation system"

gen nodiv=0
replace nodiv=1 if crop_area>=60
label var nodiv "Cell has no crop diversity"

*--------------------------------------------------------------------------------
* III. Leads 
*--------------------------------------------------------------------------------		

rename lrsma12gs llrsma12gs //just trick because we need this var later  

*Average lrsma in the past 12 months 

gen lrsma12gs= lrsma*growcrop if cropincell==1
	replace lrsma12gs=0 if lrsma12gs==. & cropincell==1
	
gen num2gs=growcrop[_n+1]+growcrop[_n+2] ///
			if _ID==_ID[_n+2]	
			replace num2gs=. if cropincell==0	
			  
gen num3gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3] ///
			if _ID==_ID[_n+3]	
			replace num3gs=. if cropincell==0	
		  
gen num4gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4] ///
			if _ID==_ID[_n+4]	
			replace num4gs=. if cropincell==0	
	
gen num5gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5] ///
			if _ID==_ID[_n+5]	
			replace num5gs=. if cropincell==0	
			  
gen num6gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5]+ ///
			growcrop[_n+6] if _ID==_ID[_n+6]	
			replace num6gs=. if cropincell==0
			   
gen num7gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5]+ ///
			growcrop[_n+6]+growcrop[_n+7] if _ID==_ID[_n+7]	
			replace num7gs=. if cropincell==0
			  			  
gen num8gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5]+ ///
			growcrop[_n+6]+growcrop[_n+7]+growcrop[_n+8] if _ID==_ID[_n+7]	
			replace num8gs=. if cropincell==0		
			  
gen num9gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5]+ ///
			growcrop[_n+6]+growcrop[_n+7]+growcrop[_n+8]+growcrop[_n+9] ///
			if _ID==_ID[_n+7]	
			replace num9gs=. if cropincell==0		
			  
gen num10gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5]+ ///
			growcrop[_n+6]+growcrop[_n+7]+growcrop[_n+8]+growcrop[_n+9]+growcrop[_n+10] ///
			if _ID==_ID[_n+10]	
			replace num10gs=. if cropincell==0					  

gen num11gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5]+ ///
			growcrop[_n+6]+growcrop[_n+7]+growcrop[_n+8]+growcrop[_n+9]+growcrop[_n+10]+ ///
			growcrop[_n+11] if _ID==_ID[_n+11]
			replace num11gs=. if cropincell==0
			  
gen num12gs=growcrop[_n+1]+growcrop[_n+2]+growcrop[_n+3]+growcrop[_n+4]+growcrop[_n+5]+ ///
			growcrop[_n+6]+growcrop[_n+7]+growcrop[_n+8]+growcrop[_n+9]+growcrop[_n+10]+ ///
			growcrop[_n+11]+growcrop[_n+12] if _ID==_ID[_n+12]	
			replace num12gs=. if cropincell==0

gen sumlrsma2gs=lrsma12gs[_n+1]+lrsma12gs[_n+2] if _ID==_ID[_n+2]				  			  
			
gen sumlrsma3gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3] if _ID==_ID[_n+3]				  			  
								    
gen sumlrsma4gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4] ///
			if _ID==_ID[_n+4]	

gen sumlrsma5gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5] if _ID==_ID[_n+5]	
									
gen sumlrsma6gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5]+ lrsma12gs[_n+6] if _ID==_ID[_n+6]	
			  
gen sumlrsma7gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5]+ lrsma12gs[_n+6]+lrsma12gs[_n+7] ///
			if _ID==_ID[_n+7]	
			  			    									
gen sumlrsma8gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5]+ lrsma12gs[_n+6]+lrsma12gs[_n+7]+lrsma12gs[_n+8] ///
			if _ID==_ID[_n+8]	
			  			    												
gen sumlrsma9gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5]+ lrsma12gs[_n+6]+lrsma12gs[_n+7]+lrsma12gs[_n+8]+ ///
			lrsma12gs[_n+9] ///
			if _ID==_ID[_n+9]	
			  
gen sumlrsma10gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5]+ lrsma12gs[_n+6]+lrsma12gs[_n+7]+lrsma12gs[_n+8]+ ///
			lrsma12gs[_n+9]+lrsma12gs[_n+10] ///
			if _ID==_ID[_n+10]	
			  
gen sumlrsma11gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5]+ lrsma12gs[_n+6]+lrsma12gs[_n+7]+lrsma12gs[_n+8]+ ///
			lrsma12gs[_n+9]+lrsma12gs[_n+10]+lrsma12gs[_n+11] ///
			if _ID==_ID[_n+11]	
			  	    									    									    													
gen sumlrsma12gs=lrsma12gs[_n+1]+lrsma12gs[_n+2]+lrsma12gs[_n+3]+lrsma12gs[_n+4]+ ///
			lrsma12gs[_n+5]+ lrsma12gs[_n+6]+lrsma12gs[_n+7]+lrsma12gs[_n+8]+ ///
			lrsma12gs[_n+9]+lrsma12gs[_n+10]+lrsma12gs[_n+11]+lrsma12gs[_n+12] ///
			if _ID==_ID[_n+12]	
  
foreach num of num 2/12 {

	gen flrsma`num'gs=sumlrsma`num'gs/num`num'gs
	replace flrsma`num'gs=. if lrsma==.
	replace flrsma`num'gs=. if num`num'gs==0
	 
	label var flrsma`num'gs "Future SMA"
	drop num`num'gs sumlrsma`num'gs		
}
	
sort _ID myear		
				 
*Lagged variable 	

gen lrsmal1=l1.lrsma if  _ID==_ID[_n-1]	

gen lrsmal1gs=l1.lrsma if  growcrop[_n-1]==1 & _ID==_ID[_n-1]	

*-------------------------------------------------------------------------------
* IV. Data at the quarterly level 
*-------------------------------------------------------------------------------

*Generate yearly variables 	(migration)

foreach var in 	migrant internal international intonmove ///
				migafrica migeurope migother {
	
	egen q`var'=sum(`var'), by(_ID year quarter) missing

}

label var qmigrant 			"Total migration by quarter"
label var qinternal			"Total internal migration by quarter"
label var qinternational	"Total international migration by quarter"
label var qmigafrica 		"Total international migration within Africa by quarter"
label var qmigeurope 		"Total international migration to Europe by quarter"
label var qmigother	 		"Total international migration other by quarter"

foreach var in sma lrsma {

	egen q`var'=mean(`var'), by(_ID quarter year)
	egen q`var'_gs=mean(`var') if growcrop==1, by(_ID quarter year)
	
	replace q`var'_gs=0 if growcrop==0 & cropstr=="No crop"
	egen q`var'_gsmax=max(q`var'_gs), by(_ID quarter year)
	
	replace q`var'_gsmax=. if cropincell==0
	drop q`var'_gs
	rename q`var'_gsmax q`var'_gs

}

foreach var in 	dmigrant dinternal dinternational dintonmove ///
				dmigafrica dmigeurope dmigother shockgs cellfmp fmpbuff200km {
	
	egen q`var'=max(`var'), by(_ID quarter year)
	
}

*-------------------------------------------------------------------------------
* V. Merge temperature and rainfall data 
*-------------------------------------------------------------------------------

merge 1:1 _ID myear using "data/temp_precipitation_2016_2020.dta" 
drop if _merge==2
drop _merge 

gen negshock=0 if lrsma!=. 
replace negshock=1 if lrsma<-1 & lrsma!=. 

drop posshock

gen posshock=0 if lrsma!=. 
replace posshock=1 if lrsma>1 & lrsma!=. 
 

gen negshockgs=0 if lrsma!=. 
replace negshockgs=1 if lrsma<-1 & lrsma!=. & growcrop==1 

gen posshockgs=0 if lrsma!=. 
replace posshockgs=1 if lrsma>1 & lrsma!=. & growcrop==1
 
foreach var in temperature_c_2m_mean total_precipitation_mm_mean total_precipitation_mm_sum {
	
	egen q`var'=mean(`var'), by(_ID quarter year)
}

foreach var in negshock posshock negshockgs posshockgs {
	
	egen q`var'=max(`var'), by(_ID quarter year)
}

*-------------------------------------------------------------------------------
* VI. Keep quarterly data 
*-------------------------------------------------------------------------------

keep _ID quarter year q* country_share cropincell 

duplicates drop 

gen yq = yq(year, quarter)

merge m:1 _ID using "data\junk.dta"
rename flag cellsample 

save "data/final_cell_5by5_quarter_all.dta", replace

*-------------------------------------------------------------------------------
* VII. Additional control variables 
*-------------------------------------------------------------------------------

keep if year>=2013 

rename qcellfmp cellfmp 
rename qfmpbuff200km fmpbuff200km 

gen lntemp=ln(qtemperature_c_2m_mean)

*Positive or negative shock at least in one month during the quarter

gen cond=1 if qposshock==0 & qnegshock==0  
replace cond=1 if qposshock==1 & qnegshock==1 // very few cases of positive and negative shocks  
replace cond=2 if qposshock==1 & qnegshock==0
replace cond=3 if qposshock==0 & qnegshock==1

*Positive of negative shocsk in a growing season month during the quarter 

gen condgs=1 if qposshockgs==0 & qnegshockgs==0  // no cases of positive and negative shocks  
replace condgs=1 if qposshockgs==1 & qnegshockgs==1 // very few cases of positive and negative shocks  
replace condgs=2 if qposshockgs==1 & qnegshockgs==0
replace condgs=3 if qposshockgs==0 & qnegshockgs==1

* Define labels   

label def cond ///
1 "Normal" /// 
2 "Positive shock" ///
3 "Negative shock", replace 
label val cond cond 
label val condgs cond

*Categorical variable: this variable replicates the main variable of the monthly regressions 

foreach var in qlrsma {

	gen c`var'=. 
	replace c`var'=1 if `var'<-1  & !mi(`var')
	replace c`var'=2 if `var'>=-1 & `var'<=1 & !mi(`var')
	replace c`var'=3 if `var'>1 & !mi(`var')
	label var c`var' "Categorical `var'"
	
} 
	
*Bad quarter dummy (only negative shocks)

gen badq=0 if qlrsma!=. 
replace badq=1 if qlrsma<-1 & qlrsma!=. 

*-------------------------------------------------------------------------------
* VIII. Save data
*-------------------------------------------------------------------------------

save "data/final_cell_5by5_quarter.dta", replace

