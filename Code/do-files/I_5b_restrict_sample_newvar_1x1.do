
*-------------------------------------------------------------------------------------------
* 5b. Data prep do-file: restricted sample
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann 
*Year:		2024

*This do-file generates the restricted sample, which we will use for the rest of the analysis 

use "data/final_cell_1by1_month.dta", clear

eststo clear

*-------------------------------------------------------------------------------------------
* I. Add extra variables (these were included after running the preliminary regressions)
*-------------------------------------------------------------------------------------------

xtile povxtile=inf_mort if west==1, nq(5)
label var povxtile "Poverty quintile"

xtile popxtile5=pop_sum if west==1, nq(5)
label var popxtile5 "Poverty quintile"
xtile popxtile4=pop_sum if west==1, nq(4)
label var popxtile4 "Poverty quintile"

xtset _ID myear

*Lagged variable 

gen lrsmal1=l1.lrsma if  _ID==_ID[_n-1]	

gen lrsmal1gs=l1.lrsma if  growcrop[_n-1]==1 & _ID==_ID[_n-1]

*Categorical variable 	

foreach var in lrsmal1 lrsma2 lrsma3 lrsma4 lrsma5 lrsma6 ///
lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 ///
lrsmal1gs lrsma2gs lrsma3gs lrsma4gs lrsma5gs lrsma6gs ///
lrsma7gs lrsma8gs lrsma9gs lrsma10gs lrsma11gs lrsma12gs {

gen c`var'=. 
replace c`var'=1 if `var'<-1  & !mi(`var')
replace c`var'=2 if `var'>=-1 & `var'<=1 & !mi(`var')
replace c`var'=3 if `var'>1 & !mi(`var')
label var c`var' "Categorical `var'"

} 

*Invert categories

foreach var in lrsmal1 lrsma2 lrsma3 lrsma4 lrsma5 lrsma6 ///
lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 ///
lrsmal1gs lrsma2gs lrsma3gs lrsma4gs lrsma5gs lrsma6gs ///
lrsma7gs lrsma8gs lrsma9gs lrsma10gs lrsma11gs lrsma12gs {

gen c`var'inv=. 
replace c`var'inv=3 if `var'<-1  & !mi(`var')
replace c`var'inv=2 if `var'>=-1 & `var'<=1 & !mi(`var')
replace c`var'inv=1 if `var'>1 & !mi(`var')
label var c`var'inv "Inverse categorical `var'"

}

*FMP binary variable

gen cellfmp_bin=.
replace cellfmp_bin=1 if cellfmp==1 | cellfmp==2
replace cellfmp_bin=0 if cellfmp==0
label var cellfmp_bin "FMP in cell"

*--------------------------------------------------------------------------------
*II. Keep if e(sample)
*--------------------------------------------------------------------------------
	
rename dinternational dinter
rename cinternational cinter 

rename dintonmove dmove
rename cintonmove cmove
rename dmigeurope deuro
rename cmigeurope ceuro

rename dmigafrica dafric
rename cmigafrica cafric

*Restrict historical sample to 2018 and 2019 ---> many observations will be dropped

/*

This is the full data, which contains all historical data from 1948 to 2019:
We restrict the sample because: 

1) We are only intrested in the last two years of the data 2018 and 2019, because we only have migration data for these two year (in contrast to the historical climate data).

2) We are only intrested in cells that belong to west africa, because we have no migration data for cells outside of west africa 

3) We are only intrested in cells that have complete climate data for the past month, to the past 12 months --> this is because we will estimate regressions for each time frame and if we do not restrict the sample, we would include include different sub-samples. Thus, the loop makes sure that we always have the same sub-sample of cells in the end. --> Cells could have incomplete infomation because we got rid of outliers in the data prep. process

*/

keep if year==2018 | year==2019 // first restriction 
keep if west==1 // second restriction

*third restriction (runs regressions and drops cells with incomplete information)

global control  cellfmp_bin fmpbuff200km /*i.growcrop*/
global fe		i.month i.year##i.country_share
global se   	vce(cluster _ID)

foreach var in dinter cinter {

	foreach sma in 	lrsmal1 lrsma2 lrsma3 lrsma4 lrsma5 lrsma6 ///
					lrsma7 lrsma8 lrsma9 lrsma10 lrsma11 lrsma12 {
  
	areg `var' c.`sma'  $control $fe, absorb(_ID) $se
	keep if e(sample)
		
	}
	
}

*--------------------------------------------------------------------------------
*III. Save data
*--------------------------------------------------------------------------------

save "data/final_cell_1by1_sample.dta", replace
