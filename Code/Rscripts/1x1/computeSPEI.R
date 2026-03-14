
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#Compute SPEI at various time scales from very large netCDF files,
#using parallel computing.

install.packages("SPEI")
install.packages("ncdf4")
install.packages("snowfall")
install.packages("Hmisc")
install.packages("lmomco")

library(SPEI)
library(ncdf4)
library(snowfall)
library(Hmisc)
library(lmomco)

sfInit(parallel=TRUE, cpus=10)
sfExport(list='spei', namespace='SPEI')

setwd(".../data/_orig/SPEIbase-2.5.1/")
source(".../r-script/1x1/functions.R")

#Compute all time scales between 1 and 48

#for (i in c(2:48)) {
for (i in c(1,3)) {
    spei.nc(
		sca=i,
		inPre='./inputData/cru_ts4.04.1901.2019.pre.dat.nc',
		inEtp='./inputData/cru_ts4.04.1901.2019.pet.dat.nc',
		outFile=paste('./outputNcdf/spei',formatC(i, width=2, format='d', flag='0'),'.nc',sep=''),
		title=paste('Global ',i,'-month',ifelse(i==1,'','s'),' SPEI, z-values, 0.5 degree',sep=''),
		comment='Using CRU TS 4.00 precipitation and potential evapotranspiration data',
		block=24,
		inMask=NA,
		tlapse=NA
	)
  gc()
}

sfStop()
