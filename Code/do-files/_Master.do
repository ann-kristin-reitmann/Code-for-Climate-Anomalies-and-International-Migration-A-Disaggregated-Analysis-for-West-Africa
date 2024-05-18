
*-------------------------------------------------------------------------------------------
* Master do-file
*-------------------------------------------------------------------------------------------

*Project: 	Climate Anomalies and International Migration: 
			// A Disaggregated Analysis for West Africa
*Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
*Year:		2024	

*Directory: mirror (data, figures, tables) folders and change directory 

 clear
 clear matrix
 clear mata
 
 version 15.1: set seed 1234567
 
 if  "`c(username)'" == "" {

 cd ""
}

 else if "`c(username)'" == "" {
 cd ""

 }
 
/* Note: the file will not run unless you update the path in the do-file !! */

*-------------------------------------------------------------------------------------------
* Do-files 
*-------------------------------------------------------------------------------------------

*I. Data preparation do-files 

//This do-file prepares the FMS data for 2018

do "do-files\I_1a_dataprep_fms_18.do"

//This do-file prepares the FMS data for 2019    		

do "do-files\I_1b_dataprep_fms_19.do"

//This do-file appends FMS data for 2018 and 2019     		

do "do-files\I_1c_dataprep_fms_join_18_19.do"

do "do-files\I_1c_dataprep_fms_join_18_19_50percent.do"
/* Note: This data is for running the robustness check
"FMPs with best coverage of departure location information"*/

do "do-files\I_1c_dataprep_fms_join_18_19_jan18dec19.do"
/* Note: This data is for running the robustness check
"FMPs open Jan 2018 - Dec 2019"*/

//This do-file creates geocode locations of FMS data     

do "do-files\I_1d_geocodes_data.do"    			
/* Note: Most of the do-file is commented out.
We save geocodes and then proceed to clean the data to avoid running
the opencage geo multiple times and update the key every time. */

//This do-file matches FMS data to raster data for both grid sizes

do "do-files\I_1e_fms_cells.do"

do "do-files\I_1e_fms_cells_50percent.do"
/* Note: This data is for running the robustness check
"FMPs with best coverage of departure location information"*/

do "do-files\I_1e_fms_cells_jan18dec19.do"
/* Note: This data is for running the robustness check
"FMPs open Jan 2018 - Dec 2019"*/

//This do-file prepares the crop calendar data    				

do "do-files\I_2a_dataprep_crops.do"   

//This do-file prepares the FMP data
 			
do "do-files\I_2b_dataprep_fmp.do" 

//This do-file prepares the soil moisture data 

do "do-files\I_2c_dataprep_soilmoisture.do"

do "do-files\I_2c_dataprep_soilmoisture_1948.do"
/* Note: This data is for creating Figure 1,
where we need the SMA calculated back to 1948."*/

//This do-file merges all data at the .5x.5 degrees cell size

do "do-files\I_3a_merge_all_data_5x5.do"  

do "do-files\I_3a_merge_all_data_5x5_50percent.do"
/* Note: This data is for running the robustness check ///
"FMPs with best coverage of departure location information"*/

do "do-files\I_3a_merge_all_data_5x5_jan18dec19.do"
/* Note: This data is for running the robustness check ///
"FMPs open Jan 2018 - Dec 2019"*/ 

//This do-file merges all data at the 1x1 degrees cell size

do "do-files\I_3b_merge_all_data_1x1.do"

do "do-files\I_3b_merge_all_data_1x1_50percent.do"
/* Note: This data is for running the robustness check ///
"FMPs with best coverage of departure location information"*/

do "do-files\I_3b_merge_all_data_1x1_jan18dec19.do"
/* Note: This data is for running the robustness check ///
"FMPs open Jan 2018 - Dec 2019"*/ 

//This do-file generates new variables for both cell sizes .5x.5 and 1x1 using a loop

do "do-files\I_4_gen_newvar_both.do"

do "do-files\I_4_gen_newvar_both_50percent.do"
/* Note: This data is for running the robustness check ///
"FMPs with best coverage of departure location information"*/

do "do-files\I_4_gen_newvar_both_jan18dec19.do"
/* Note: This data is for running the robustness check ///
"FMPs open Jan 2018 - Dec 2019"*/

// This do-file restricts sample to final sample size at the .5x.5 degrees cell size   		

do "do-files\I_5a_restrict_sample_newvar_5x5.do"  

do "do-files\I_5a_restrict_sample_newvar_5x5_50percent.do"
/* Note: This data is for running the robustness check ///
"FMPs with best coverage of departure location information"*/

do "do-files\I_5a_restrict_sample_newvar_5x5_jan18dec19.do"
/* Note: This data is for running the robustness check ///
"FMPs open Jan 2018 - Dec 2019"*/

do "do-files\I_5a_restrict_sample_newvar_5x5_20ySMA.do" 
/* Note: This data is for running the robustness check ///
"SMA based on past 20 years"*/

// This do-file restricts sample to final sample size at the 1x1 degrees cell size   		

do "do-files\I_5b_restrict_sample_newvar_1x1.do"  

//This do-file merges precipitation data for cell sizes .5x.5

do "do-files\I_6_rainfall_data_5x5.do"

//This do-file creates quarterly level data for cell sizes .5x.5

do "do-files\I_7a_quarterly_level_5x5.do"

//This do-file creates annual level data for cell sizes .5x.5

do "do-files\I_7b_annual_level_5x5.do"

//This do-files prepares data to read in R and generate maps

do "do-files\I_8_dataprep_maps_R.do"


*II. Do-files to generate Figures

//Figure 1

do "do-files\II_figure1.do"

//Figure 2

/*Figure 2 is generated in QGIS*/

//Figure 3

/*Figure 3 is generated in R*/

//Figure 4

/*Figure 4 is generated in R*/

//Figure 5

do "do-files\II_figure5.do"

//Figure 6

do "do-files\II_figure6.do"

//Figure 7

do "do-files\II_figure7.do"

//Figure 8

do "do-files\II_figure8.do"

//Figure 9

do "do-files\II_figure9.do"

//Figure 10

do "do-files\II_figure10.do"


*III. Do-files to generate Tables

//Table 1

do "do-files\III_table1.do"

//Table 2

do "do-files\III_table2.do"

//Table 3

do "do-files\III_table3.do"

//Table 4 

do "do-files\III_table4.do"

//Table 5

*Other robustness checks

do "do-files\III_table5.do"
/*CAUTION: Need to run first part of Master do-file again, to set directory!!!*/

 if  "`c(username)'" == "" {

 cd ""
}

//Table 6 

do "do-files\III_table6.do"

//Table 7 

do "do-files\III_table7.do"


*IV. Do-files to generate Appendix Figures

//Figure A1

/*Figure A1 is generated in R*/

//Figure A2

/*Figure A2 is generated in R*/

//Figure A3

/*Figure A3 is generated in R*/

//Figure A4

/*Figure A4 is generated in R*/

//Figure A5

do "do-files\IV_figureA5.do"

//Figure A6

do "do-files\IV_figureA6.do"

//Figure A7

/*Figure A7 is generated in R*/

//Figure A8

do "do-files\IV_figureA8.do"

//Figure A8

do "do-files\IV_figureA9.do"



*V. Do-files to generate Appendix Tables

//Table A1

/*Table A1 is generated manually in the manuscript */

//Table A2

do "do-files\V_tableA2.do"

//Table A3

do "do-files\V_tableA3.do"

//Table A4

do "do-files\V_tableA4.do"

//Table A5

do "do-files\V_tableA5.do"

//Table A6

do "do-files\V_tableA6.do"

//Table A7

do "do-files\V_tableA7.do"
