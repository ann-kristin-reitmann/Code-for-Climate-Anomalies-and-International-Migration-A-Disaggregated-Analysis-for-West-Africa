
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#install.packages("lmomco")
#install.packages("SPEI")
#install.packages("")

library(lmomco)
library(ncdf4)

setwd(".../data/_orig/SPEIbase-2.5.1/outputNcdf/")

#Set path and file name 

ncpath <- ".../data/_orig/SPEIbase-2.5.1/outputNcdf/"
ncname <- "cru_tmp"
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "spei"

ncin <- nc_open(".../data/_orig/SPEIbase-2.5.1/outputNcdf/spei01.nc")
print(ncin)

#Get longitude and latitude

lon <- ncvar_get(ncin, "lon")
nlon <- dim(lon)
head(lon)

lat <- ncvar_get(ncin, "lat")
nlat <- dim(lat)
head(lat)

print(c(nlon,nlat))

# Get time 

time <- ncvar_get(ncin,"time")
time

tunits <- ncatt_get(ncin, "time", "units")
nt <- dim(time)
nt

tunits

#get spei

tmp_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(tmp_array)

#get global attributes

title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"source")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")

ls()

#-------------------------------------------------------------------------------------------------------------------
# CONVERT FROM RASTER TO RECTANGULAR 
#-------------------------------------------------------------------------------------------------------------------

#load some packages

library(chron)
library(lattice)
library(RColorBrewer)

#convert time -- split the time units string into fields

tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
chron(time,origin=c(tmonth, tday, tyear))

#replace netCDF fill values with NA's

tmp_array[tmp_array==fillvalue$value] <- NA
length(na.omit(as.vector(tmp_array[,,1])))

#create dataframe -- reshape data

#matrix (nlon*nlat rows by 2 cols) of lons and lats

lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)

#vector of `tmp` values

tmp_vec <- as.vector(tmp_slice)
length(tmp_vec)

#create dataframe and add names

tmp_df01 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df01) <- c("lon","lat",paste(dname,as.character(m), sep="_"))
head(na.omit(tmp_df01), 10)

#Create dataframe for the whole array

#reshape the array into vector

tmp_vec_long <- as.vector(tmp_array)
length(tmp_vec_long)

#reshape the vector into a matrix

tmp_mat <- matrix(tmp_vec_long, nrow=nlon*nlat, ncol=nt)
dim(tmp_mat)

#head(na.omit(tmp_mat))   # too big so it doesnt work 

lonlat <- as.matrix(expand.grid(lon,lat))
tmp_df02 <- data.frame(cbind(lonlat,tmp_mat))

names(tmp_df02) <- c("lat", "lon" ,	"Jan1901"	,	"Feb1901"	,	"Mar1901"	,	"Apr1901"	,	"May1901"	,	"Jun1901"	,	"Jul1901"	,	"Aug1901"	,	"Sep1901"	,	"Oct1901"	,	"Nov1901"	,	"Dec1901" ,
                     "Jan1902"	,	"Feb1902"	,	"Mar1902"	,	"Apr1902"	,	"May1902"	,	"Jun1902"	,	"Jul1902"	,	"Aug1902"	,	"Sep1902"	,	"Oct1902"	,	"Nov1902"	,	"Dec1902" ,
                     "Jan1903"	,	"Feb1903"	,	"Mar1903"	,	"Apr1903"	,	"May1903"	,	"Jun1903"	,	"Jul1903"	,	"Aug1903"	,	"Sep1903"	,	"Oct1903"	,	"Nov1903"	,	"Dec1903" ,
                     "Jan1904"	,	"Feb1904"	,	"Mar1904"	,	"Apr1904"	,	"May1904"	,	"Jun1904"	,	"Jul1904"	,	"Aug1904"	,	"Sep1904"	,	"Oct1904"	,	"Nov1904"	,	"Dec1904" ,
                     "Jan1905"	,	"Feb1905"	,	"Mar1905"	,	"Apr1905"	,	"May1905"	,	"Jun1905"	,	"Jul1905"	,	"Aug1905"	,	"Sep1905"	,	"Oct1905"	,	"Nov1905"	,	"Dec1905" ,
                     "Jan1906"	,	"Feb1906"	,	"Mar1906"	,	"Apr1906"	,	"May1906"	,	"Jun1906"	,	"Jul1906"	,	"Aug1906"	,	"Sep1906"	,	"Oct1906"	,	"Nov1906"	,	"Dec1906" ,
                     "Jan1907"	,	"Feb1907"	,	"Mar1907"	,	"Apr1907"	,	"May1907"	,	"Jun1907"	,	"Jul1907"	,	"Aug1907"	,	"Sep1907"	,	"Oct1907"	,	"Nov1907"	,	"Dec1907" ,
                     "Jan1908"	,	"Feb1908"	,	"Mar1908"	,	"Apr1908"	,	"May1908"	,	"Jun1908"	,	"Jul1908"	,	"Aug1908"	,	"Sep1908"	,	"Oct1908"	,	"Nov1908"	,	"Dec1908" ,
                     "Jan1909"	,	"Feb1909"	,	"Mar1909"	,	"Apr1909"	,	"May1909"	,	"Jun1909"	,	"Jul1909"	,	"Aug1909"	,	"Sep1909"	,	"Oct1909"	,	"Nov1909"	,	"Dec1909" ,
                     "Jan1910"	,	"Feb1910"	,	"Mar1910"	,	"Apr1910"	,	"May1910"	,	"Jun1910"	,	"Jul1910"	,	"Aug1910"	,	"Sep1910"	,	"Oct1910"	,	"Nov1910"	,	"Dec1910" ,
                     "Jan1911"	,	"Feb1911"	,	"Mar1911"	,	"Apr1911"	,	"May1911"	,	"Jun1911"	,	"Jul1911"	,	"Aug1911"	,	"Sep1911"	,	"Oct1911"	,	"Nov1911"	,	"Dec1911" ,
                     "Jan1912"	,	"Feb1912"	,	"Mar1912"	,	"Apr1912"	,	"May1912"	,	"Jun1912"	,	"Jul1912"	,	"Aug1912"	,	"Sep1912"	,	"Oct1912"	,	"Nov1912"	,	"Dec1912" ,
                     "Jan1913"	,	"Feb1913"	,	"Mar1913"	,	"Apr1913"	,	"May1913"	,	"Jun1913"	,	"Jul1913"	,	"Aug1913"	,	"Sep1913"	,	"Oct1913"	,	"Nov1913"	,	"Dec1913" ,
                     "Jan1914"	,	"Feb1914"	,	"Mar1914"	,	"Apr1914"	,	"May1914"	,	"Jun1914"	,	"Jul1914"	,	"Aug1914"	,	"Sep1914"	,	"Oct1914"	,	"Nov1914"	,	"Dec1914" ,
                     "Jan1915"	,	"Feb1915"	,	"Mar1915"	,	"Apr1915"	,	"May1915"	,	"Jun1915"	,	"Jul1915"	,	"Aug1915"	,	"Sep1915"	,	"Oct1915"	,	"Nov1915"	,	"Dec1915" ,
                     "Jan1916"	,	"Feb1916"	,	"Mar1916"	,	"Apr1916"	,	"May1916"	,	"Jun1916"	,	"Jul1916"	,	"Aug1916"	,	"Sep1916"	,	"Oct1916"	,	"Nov1916"	,	"Dec1916" ,
                     "Jan1917"	,	"Feb1917"	,	"Mar1917"	,	"Apr1917"	,	"May1917"	,	"Jun1917"	,	"Jul1917"	,	"Aug1917"	,	"Sep1917"	,	"Oct1917"	,	"Nov1917"	,	"Dec1917" ,
                     "Jan1918"	,	"Feb1918"	,	"Mar1918"	,	"Apr1918"	,	"May1918"	,	"Jun1918"	,	"Jul1918"	,	"Aug1918"	,	"Sep1918"	,	"Oct1918"	,	"Nov1918"	,	"Dec1918" ,
                     "Jan1919"	,	"Feb1919"	,	"Mar1919"	,	"Apr1919"	,	"May1919"	,	"Jun1919"	,	"Jul1919"	,	"Aug1919"	,	"Sep1919"	,	"Oct1919"	,	"Nov1919"	,	"Dec1919" ,
                     "Jan1920"	,	"Feb1920"	,	"Mar1920"	,	"Apr1920"	,	"May1920"	,	"Jun1920"	,	"Jul1920"	,	"Aug1920"	,	"Sep1920"	,	"Oct1920"	,	"Nov1920"	,	"Dec1920" ,
                     "Jan1921"	,	"Feb1921"	,	"Mar1921"	,	"Apr1921"	,	"May1921"	,	"Jun1921"	,	"Jul1921"	,	"Aug1921"	,	"Sep1921"	,	"Oct1921"	,	"Nov1921"	,	"Dec1921" ,
                     "Jan1922"	,	"Feb1922"	,	"Mar1922"	,	"Apr1922"	,	"May1922"	,	"Jun1922"	,	"Jul1922"	,	"Aug1922"	,	"Sep1922"	,	"Oct1922"	,	"Nov1922"	,	"Dec1922" ,
                     "Jan1923"	,	"Feb1923"	,	"Mar1923"	,	"Apr1923"	,	"May1923"	,	"Jun1923"	,	"Jul1923"	,	"Aug1923"	,	"Sep1923"	,	"Oct1923"	,	"Nov1923"	,	"Dec1923" ,
                     "Jan1924"	,	"Feb1924"	,	"Mar1924"	,	"Apr1924"	,	"May1924"	,	"Jun1924"	,	"Jul1924"	,	"Aug1924"	,	"Sep1924"	,	"Oct1924"	,	"Nov1924"	,	"Dec1924" ,
                     "Jan1925"	,	"Feb1925"	,	"Mar1925"	,	"Apr1925"	,	"May1925"	,	"Jun1925"	,	"Jul1925"	,	"Aug1925"	,	"Sep1925"	,	"Oct1925"	,	"Nov1925"	,	"Dec1925" ,
                     "Jan1926"	,	"Feb1926"	,	"Mar1926"	,	"Apr1926"	,	"May1926"	,	"Jun1926"	,	"Jul1926"	,	"Aug1926"	,	"Sep1926"	,	"Oct1926"	,	"Nov1926"	,	"Dec1926" ,
                     "Jan1927"	,	"Feb1927"	,	"Mar1927"	,	"Apr1927"	,	"May1927"	,	"Jun1927"	,	"Jul1927"	,	"Aug1927"	,	"Sep1927"	,	"Oct1927"	,	"Nov1927"	,	"Dec1927" ,
                     "Jan1928"	,	"Feb1928"	,	"Mar1928"	,	"Apr1928"	,	"May1928"	,	"Jun1928"	,	"Jul1928"	,	"Aug1928"	,	"Sep1928"	,	"Oct1928"	,	"Nov1928"	,	"Dec1928" ,
                     "Jan1929"	,	"Feb1929"	,	"Mar1929"	,	"Apr1929"	,	"May1929"	,	"Jun1929"	,	"Jul1929"	,	"Aug1929"	,	"Sep1929"	,	"Oct1929"	,	"Nov1929"	,	"Dec1929" , 
                     "Jan1930"	,	"Feb1930"	,	"Mar1930"	,	"Apr1930"	,	"May1930"	,	"Jun1930"	,	"Jul1930"	,	"Aug1930"	,	"Sep1930"	,	"Oct1930"	,	"Nov1930"	,	"Dec1930" ,
                     "Jan1931"	,	"Feb1931"	,	"Mar1931"	,	"Apr1931"	,	"May1931"	,	"Jun1931"	,	"Jul1931"	,	"Aug1931"	,	"Sep1931"	,	"Oct1931"	,	"Nov1931"	,	"Dec1931" , 
                     "Jan1932"	,	"Feb1932"	,	"Mar1932"	,	"Apr1932"	,	"May1932"	,	"Jun1932"	,	"Jul1932"	,	"Aug1932"	,	"Sep1932"	,	"Oct1932"	,	"Nov1932"	,	"Dec1932" ,
                     "Jan1933"	,	"Feb1933"	,	"Mar1933"	,	"Apr1933"	,	"May1933"	,	"Jun1933"	,	"Jul1933"	,	"Aug1933"	,	"Sep1933"	,	"Oct1933"	,	"Nov1933"	,	"Dec1933" ,
                     "Jan1934"	,	"Feb1934"	,	"Mar1934"	,	"Apr1934"	,	"May1934"	,	"Jun1934"	,	"Jul1934"	,	"Aug1934"	,	"Sep1934"	,	"Oct1934"	,	"Nov1934"	,	"Dec1934" ,
                     "Jan1935"	,	"Feb1935"	,	"Mar1935"	,	"Apr1935"	,	"May1935"	,	"Jun1935"	,	"Jul1935"	,	"Aug1935"	,	"Sep1935"	,	"Oct1935"	,	"Nov1935"	,	"Dec1935" ,
                     "Jan1936"	,	"Feb1936"	,	"Mar1936"	,	"Apr1936"	,	"May1936"	,	"Jun1936"	,	"Jul1936"	,	"Aug1936"	,	"Sep1936"	,	"Oct1936"	,	"Nov1936"	,	"Dec1936" , 
                     "Jan1937"	,	"Feb1937"	,	"Mar1937"	,	"Apr1937"	,	"May1937"	,	"Jun1937"	,	"Jul1937"	,	"Aug1937"	,	"Sep1937"	,	"Oct1937"	,	"Nov1937"	,	"Dec1937" ,
                     "Jan1938"	,	"Feb1938"	,	"Mar1938"	,	"Apr1938"	,	"May1938"	,	"Jun1938"	,	"Jul1938"	,	"Aug1938"	,	"Sep1938"	,	"Oct1938"	,	"Nov1938"	,	"Dec1938" ,
                     "Jan1939"	,	"Feb1939"	,	"Mar1939"	,	"Apr1939"	,	"May1939"	,	"Jun1939"	,	"Jul1939"	,	"Aug1939"	,	"Sep1939"	,	"Oct1939"	,	"Nov1939"	,	"Dec1939" ,
                     "Jan1940"	,	"Feb1940"	,	"Mar1940"	,	"Apr1940"	,	"May1940"	,	"Jun1940"	,	"Jul1940"	,	"Aug1940"	,	"Sep1940"	,	"Oct1940"	,	"Nov1940"	,	"Dec1940" ,
                     "Jan1941"	,	"Feb1941"	,	"Mar1941"	,	"Apr1941"	,	"May1941"	,	"Jun1941"	,	"Jul1941"	,	"Aug1941"	,	"Sep1941"	,	"Oct1941"	,	"Nov1941"	,	"Dec1941" ,
                     "Jan1942"	,	"Feb1942"	,	"Mar1942"	,	"Apr1942"	,	"May1942"	,	"Jun1942"	,	"Jul1942"	,	"Aug1942"	,	"Sep1942"	,	"Oct1942"	,	"Nov1942"	,	"Dec1942" ,
                     "Jan1943"	,	"Feb1943"	,	"Mar1943"	,	"Apr1943"	,	"May1943"	,	"Jun1943"	,	"Jul1943"	,	"Aug1943"	,	"Sep1943"	,	"Oct1943"	,	"Nov1943"	,	"Dec1943" ,
                     "Jan1944"	,	"Feb1944"	,	"Mar1944"	,	"Apr1944"	,	"May1944"	,	"Jun1944"	,	"Jul1944"	,	"Aug1944"	,	"Sep1944"	,	"Oct1944"	,	"Nov1944"	,	"Dec1944" ,
                     "Jan1945"	,	"Feb1945"	,	"Mar1945"	,	"Apr1945"	,	"May1945"	,	"Jun1945"	,	"Jul1945"	,	"Aug1945"	,	"Sep1945"	,	"Oct1945"	,	"Nov1945"	,	"Dec1945" ,
                     "Jan1946"	,	"Feb1946"	,	"Mar1946"	,	"Apr1946"	,	"May1946"	,	"Jun1946"	,	"Jul1946"	,	"Aug1946"	,	"Sep1946"	,	"Oct1946"	,	"Nov1946"	,	"Dec1946" ,
                     "Jan1947"	,	"Feb1947"	,	"Mar1947"	,	"Apr1947"	,	"May1947"	,	"Jun1947"	,	"Jul1947"	,	"Aug1947"	,	"Sep1947"	,	"Oct1947"	,	"Nov1947"	,	"Dec1947" ,
                     "Jan1948"	,	"Feb1948"	,	"Mar1948"	,	"Apr1948"	,	"May1948"	,	"Jun1948"	,	"Jul1948"	,	"Aug1948"	,	"Sep1948"	,	"Oct1948"	,	"Nov1948"	,	"Dec1948" ,
                     "Jan1949"	,	"Feb1949"	,	"Mar1949"	,	"Apr1949"	,	"May1949"	,	"Jun1949"	,	"Jul1949"	,	"Aug1949"	,	"Sep1949"	,	"Oct1949"	,	"Nov1949"	,	"Dec1949" ,
                     "Jan1950"	,	"Feb1950"	,	"Mar1950"	,	"Apr1950"	,	"May1950"	,	"Jun1950"	,	"Jul1950"	,	"Aug1950"	,	"Sep1950"	,	"Oct1950"	,	"Nov1950"	,	"Dec1950" ,
                     "Jan1951"	,	"Feb1951"	,	"Mar1951"	,	"Apr1951"	,	"May1951"	,	"Jun1951"	,	"Jul1951"	,	"Aug1951"	,	"Sep1951"	,	"Oct1951"	,	"Nov1951"	,	"Dec1951" ,
                     "Jan1952"	,	"Feb1952"	,	"Mar1952"	,	"Apr1952"	,	"May1952"	,	"Jun1952"	,	"Jul1952"	,	"Aug1952"	,	"Sep1952"	,	"Oct1952"	,	"Nov1952"	,	"Dec1952" ,
                     "Jan1953"	,	"Feb1953"	,	"Mar1953"	,	"Apr1953"	,	"May1953"	,	"Jun1953"	,	"Jul1953"	,	"Aug1953"	,	"Sep1953"	,	"Oct1953"	,	"Nov1953"	,	"Dec1953" ,
                     "Jan1954"	,	"Feb1954"	,	"Mar1954"	,	"Apr1954"	,	"May1954"	,	"Jun1954"	,	"Jul1954"	,	"Aug1954"	,	"Sep1954"	,	"Oct1954"	,	"Nov1954"	,	"Dec1954" ,
                     "Jan1955"	,	"Feb1955"	,	"Mar1955"	,	"Apr1955"	,	"May1955"	,	"Jun1955"	,	"Jul1955"	,	"Aug1955"	,	"Sep1955"	,	"Oct1955"	,	"Nov1955"	,	"Dec1955" ,
                     "Jan1956"	,	"Feb1956"	,	"Mar1956"	,	"Apr1956"	,	"May1956"	,	"Jun1956"	,	"Jul1956"	,	"Aug1956"	,	"Sep1956"	,	"Oct1956"	,	"Nov1956"	,	"Dec1956" ,
                     "Jan1957"	,	"Feb1957"	,	"Mar1957"	,	"Apr1957"	,	"May1957"	,	"Jun1957"	,	"Jul1957"	,	"Aug1957"	,	"Sep1957"	,	"Oct1957"	,	"Nov1957"	,	"Dec1957" ,
                     "Jan1958"	,	"Feb1958"	,	"Mar1958"	,	"Apr1958"	,	"May1958"	,	"Jun1958"	,	"Jul1958"	,	"Aug1958"	,	"Sep1958"	,	"Oct1958"	,	"Nov1958"	,	"Dec1958" ,
                     "Jan1959"	,	"Feb1959"	,	"Mar1959"	,	"Apr1959"	,	"May1959"	,	"Jun1959"	,	"Jul1959"	,	"Aug1959"	,	"Sep1959"	,	"Oct1959"	,	"Nov1959"	,	"Dec1959" ,
                     "Jan1960"	,	"Feb1960"	,	"Mar1960"	,	"Apr1960"	,	"May1960"	,	"Jun1960"	,	"Jul1960"	,	"Aug1960"	,	"Sep1960"	,	"Oct1960"	,	"Nov1960"	,	"Dec1960" ,
                     "Jan1961"	,	"Feb1961"	,	"Mar1961"	,	"Apr1961"	,	"May1961"	,	"Jun1961"	,	"Jul1961"	,	"Aug1961"	,	"Sep1961"	,	"Oct1961"	,	"Nov1961"	,	"Dec1961" ,
                     "Jan1962"	,	"Feb1962"	,	"Mar1962"	,	"Apr1962"	,	"May1962"	,	"Jun1962"	,	"Jul1962"	,	"Aug1962"	,	"Sep1962"	,	"Oct1962"	,	"Nov1962"	,	"Dec1962" ,
                     "Jan1963"	,	"Feb1963"	,	"Mar1963"	,	"Apr1963"	,	"May1963"	,	"Jun1963"	,	"Jul1963"	,	"Aug1963"	,	"Sep1963"	,	"Oct1963"	,	"Nov1963"	,	"Dec1963" ,
                     "Jan1964"	,	"Feb1964"	,	"Mar1964"	,	"Apr1964"	,	"May1964"	,	"Jun1964"	,	"Jul1964"	,	"Aug1964"	,	"Sep1964"	,	"Oct1964"	,	"Nov1964"	,	"Dec1964" ,
                     "Jan1965"	,	"Feb1965"	,	"Mar1965"	,	"Apr1965"	,	"May1965"	,	"Jun1965"	,	"Jul1965"	,	"Aug1965"	,	"Sep1965"	,	"Oct1965"	,	"Nov1965"	,	"Dec1965" ,
                     "Jan1966"	,	"Feb1966"	,	"Mar1966"	,	"Apr1966"	,	"May1966"	,	"Jun1966"	,	"Jul1966"	,	"Aug1966"	,	"Sep1966"	,	"Oct1966"	,	"Nov1966"	,	"Dec1966" ,
                     "Jan1967"	,	"Feb1967"	,	"Mar1967"	,	"Apr1967"	,	"May1967"	,	"Jun1967"	,	"Jul1967"	,	"Aug1967"	,	"Sep1967"	,	"Oct1967"	,	"Nov1967"	,	"Dec1967" ,
                     "Jan1968"	,	"Feb1968"	,	"Mar1968"	,	"Apr1968"	,	"May1968"	,	"Jun1968"	,	"Jul1968"	,	"Aug1968"	,	"Sep1968"	,	"Oct1968"	,	"Nov1968"	,	"Dec1968" ,
                     "Jan1969"	,	"Feb1969"	,	"Mar1969"	,	"Apr1969"	,	"May1969"	,	"Jun1969"	,	"Jul1969"	,	"Aug1969"	,	"Sep1969"	,	"Oct1969"	,	"Nov1969"	,	"Dec1969" ,
                     "Jan1970"	,	"Feb1970"	,	"Mar1970"	,	"Apr1970"	,	"May1970"	,	"Jun1970"	,	"Jul1970"	,	"Aug1970"	,	"Sep1970"	,	"Oct1970"	,	"Nov1970"	,	"Dec1970" ,
                     "Jan1971"	,	"Feb1971"	,	"Mar1971"	,	"Apr1971"	,	"May1971"	,	"Jun1971"	,	"Jul1971"	,	"Aug1971"	,	"Sep1971"	,	"Oct1971"	,	"Nov1971"	,	"Dec1971" ,
                     "Jan1972"	,	"Feb1972"	,	"Mar1972"	,	"Apr1972"	,	"May1972"	,	"Jun1972"	,	"Jul1972"	,	"Aug1972"	,	"Sep1972"	,	"Oct1972"	,	"Nov1972"	,	"Dec1972" ,
                     "Jan1973"	,	"Feb1973"	,	"Mar1973"	,	"Apr1973"	,	"May1973"	,	"Jun1973"	,	"Jul1973"	,	"Aug1973"	,	"Sep1973"	,	"Oct1973"	,	"Nov1973"	,	"Dec1973" ,
                     "Jan1974"	,	"Feb1974"	,	"Mar1974"	,	"Apr1974"	,	"May1974"	,	"Jun1974"	,	"Jul1974"	,	"Aug1974"	,	"Sep1974"	,	"Oct1974"	,	"Nov1974"	,	"Dec1974" ,
                     "Jan1975"	,	"Feb1975"	,	"Mar1975"	,	"Apr1975"	,	"May1975"	,	"Jun1975"	,	"Jul1975"	,	"Aug1975"	,	"Sep1975"	,	"Oct1975"	,	"Nov1975"	,	"Dec1975" ,
                     "Jan1976"	,	"Feb1976"	,	"Mar1976"	,	"Apr1976"	,	"May1976"	,	"Jun1976"	,	"Jul1976"	,	"Aug1976"	,	"Sep1976"	,	"Oct1976"	,	"Nov1976"	,	"Dec1976" ,
                     "Jan1977"	,	"Feb1977"	,	"Mar1977"	,	"Apr1977"	,	"May1977"	,	"Jun1977"	,	"Jul1977"	,	"Aug1977"	,	"Sep1977"	,	"Oct1977"	,	"Nov1977"	,	"Dec1977" ,
                     "Jan1978"	,	"Feb1978"	,	"Mar1978"	,	"Apr1978"	,	"May1978"	,	"Jun1978"	,	"Jul1978"	,	"Aug1978"	,	"Sep1978"	,	"Oct1978"	,	"Nov1978"	,	"Dec1978" ,
                     "Jan1979"	,	"Feb1979"	,	"Mar1979"	,	"Apr1979"	,	"May1979"	,	"Jun1979"	,	"Jul1979"	,	"Aug1979"	,	"Sep1979"	,	"Oct1979"	,	"Nov1979"	,	"Dec1979" ,
                     "Jan1980"	,	"Feb1980"	,	"Mar1980"	,	"Apr1980"	,	"May1980"	,	"Jun1980"	,	"Jul1980"	,	"Aug1980"	,	"Sep1980"	,	"Oct1980"	,	"Nov1980"	,	"Dec1980" ,
                     "Jan1981"	,	"Feb1981"	,	"Mar1981"	,	"Apr1981"	,	"May1981"	,	"Jun1981"	,	"Jul1981"	,	"Aug1981"	,	"Sep1981"	,	"Oct1981"	,	"Nov1981"	,	"Dec1981" ,
                     "Jan1982"	,	"Feb1982"	,	"Mar1982"	,	"Apr1982"	,	"May1982"	,	"Jun1982"	,	"Jul1982"	,	"Aug1982"	,	"Sep1982"	,	"Oct1982"	,	"Nov1982"	,	"Dec1982" ,
                     "Jan1983"	,	"Feb1983"	,	"Mar1983"	,	"Apr1983"	,	"May1983"	,	"Jun1983"	,	"Jul1983"	,	"Aug1983"	,	"Sep1983"	,	"Oct1983"	,	"Nov1983"	,	"Dec1983" ,
                     "Jan1984"	,	"Feb1984"	,	"Mar1984"	,	"Apr1984"	,	"May1984"	,	"Jun1984"	,	"Jul1984"	,	"Aug1984"	,	"Sep1984"	,	"Oct1984"	,	"Nov1984"	,	"Dec1984" ,
                     "Jan1985"	,	"Feb1985"	,	"Mar1985"	,	"Apr1985"	,	"May1985"	,	"Jun1985"	,	"Jul1985"	,	"Aug1985"	,	"Sep1985"	,	"Oct1985"	,	"Nov1985"	,	"Dec1985" ,
                     "Jan1986"	,	"Feb1986"	,	"Mar1986"	,	"Apr1986"	,	"May1986"	,	"Jun1986"	,	"Jul1986"	,	"Aug1986"	,	"Sep1986"	,	"Oct1986"	,	"Nov1986"	,	"Dec1986" ,
                     "Jan1987"	,	"Feb1987"	,	"Mar1987"	,	"Apr1987"	,	"May1987"	,	"Jun1987"	,	"Jul1987"	,	"Aug1987"	,	"Sep1987"	,	"Oct1987"	,	"Nov1987"	,	"Dec1987" ,
                     "Jan1988"	,	"Feb1988"	,	"Mar1988"	,	"Apr1988"	,	"May1988"	,	"Jun1988"	,	"Jul1988"	,	"Aug1988"	,	"Sep1988"	,	"Oct1988"	,	"Nov1988"	,	"Dec1988" ,
                     "Jan1989"	,	"Feb1989"	,	"Mar1989"	,	"Apr1989"	,	"May1989"	,	"Jun1989"	,	"Jul1989"	,	"Aug1989"	,	"Sep1989"	,	"Oct1989"	,	"Nov1989"	,	"Dec1989" ,
                     "Jan1990"	,	"Feb1990"	,	"Mar1990"	,	"Apr1990"	,	"May1990"	,	"Jun1990"	,	"Jul1990"	,	"Aug1990"	,	"Sep1990"	,	"Oct1990"	,	"Nov1990"	,	"Dec1990" ,
                     "Jan1991"	,	"Feb1991"	,	"Mar1991"	,	"Apr1991"	,	"May1991"	,	"Jun1991"	,	"Jul1991"	,	"Aug1991"	,	"Sep1991"	,	"Oct1991"	,	"Nov1991"	,	"Dec1991" ,
                     "Jan1992"	,	"Feb1992"	,	"Mar1992"	,	"Apr1992"	,	"May1992"	,	"Jun1992"	,	"Jul1992"	,	"Aug1992"	,	"Sep1992"	,	"Oct1992"	,	"Nov1992"	,	"Dec1992" ,
                     "Jan1993"	,	"Feb1993"	,	"Mar1993"	,	"Apr1993"	,	"May1993"	,	"Jun1993"	,	"Jul1993"	,	"Aug1993"	,	"Sep1993"	,	"Oct1993"	,	"Nov1993"	,	"Dec1993" ,
                     "Jan1994"	,	"Feb1994"	,	"Mar1994"	,	"Apr1994"	,	"May1994"	,	"Jun1994"	,	"Jul1994"	,	"Aug1994"	,	"Sep1994"	,	"Oct1994"	,	"Nov1994"	,	"Dec1994" ,
                     "Jan1995"	,	"Feb1995"	,	"Mar1995"	,	"Apr1995"	,	"May1995"	,	"Jun1995"	,	"Jul1995"	,	"Aug1995"	,	"Sep1995"	,	"Oct1995"	,	"Nov1995"	,	"Dec1995" ,
                     "Jan1996"	,	"Feb1996"	,	"Mar1996"	,	"Apr1996"	,	"May1996"	,	"Jun1996"	,	"Jul1996"	,	"Aug1996"	,	"Sep1996"	,	"Oct1996"	,	"Nov1996"	,	"Dec1996" ,
                     "Jan1997"	,	"Feb1997"	,	"Mar1997"	,	"Apr1997"	,	"May1997"	,	"Jun1997"	,	"Jul1997"	,	"Aug1997"	,	"Sep1997"	,	"Oct1997"	,	"Nov1997"	,	"Dec1997" ,
                     "Jan1998"	,	"Feb1998"	,	"Mar1998"	,	"Apr1998"	,	"May1998"	,	"Jun1998"	,	"Jul1998"	,	"Aug1998"	,	"Sep1998"	,	"Oct1998"	,	"Nov1998"	,	"Dec1998" ,
                     "Jan1999"	,	"Feb1999"	,	"Mar1999"	,	"Apr1999"	,	"May1999"	,	"Jun1999"	,	"Jul1999"	,	"Aug1999"	,	"Sep1999"	,	"Oct1999"	,	"Nov1999"	,	"Dec1999" ,
                     "Jan2000"	,	"Feb2000"	,	"Mar2000"	,	"Apr2000"	,	"May2000"	,	"Jun2000"	,	"Jul2000"	,	"Aug2000"	,	"Sep2000"	,	"Oct2000"	,	"Nov2000"	,	"Dec2000" ,
                     "Jan2001"	,	"Feb2001"	,	"Mar2001"	,	"Apr2001"	,	"May2001"	,	"Jun2001"	,	"Jul2001"	,	"Aug2001"	,	"Sep2001"	,	"Oct2001"	,	"Nov2001"	,	"Dec2001" ,
                     "Jan2002"	,	"Feb2002"	,	"Mar2002"	,	"Apr2002"	,	"May2002"	,	"Jun2002"	,	"Jul2002"	,	"Aug2002"	,	"Sep2002"	,	"Oct2002"	,	"Nov2002"	,	"Dec2002" ,
                     "Jan2003"	,	"Feb2003"	,	"Mar2003"	,	"Apr2003"	,	"May2003"	,	"Jun2003"	,	"Jul2003"	,	"Aug2003"	,	"Sep2003"	,	"Oct2003"	,	"Nov2003"	,	"Dec2003" ,
                     "Jan2004"	,	"Feb2004"	,	"Mar2004"	,	"Apr2004"	,	"May2004"	,	"Jun2004"	,	"Jul2004"	,	"Aug2004"	,	"Sep2004"	,	"Oct2004"	,	"Nov2004"	,	"Dec2004" ,
                     "Jan2005"	,	"Feb2005"	,	"Mar2005"	,	"Apr2005"	,	"May2005"	,	"Jun2005"	,	"Jul2005"	,	"Aug2005"	,	"Sep2005"	,	"Oct2005"	,	"Nov2005"	,	"Dec2005" ,
                     "Jan2006"	,	"Feb2006"	,	"Mar2006"	,	"Apr2006"	,	"May2006"	,	"Jun2006"	,	"Jul2006"	,	"Aug2006"	,	"Sep2006"	,	"Oct2006"	,	"Nov2006"	,	"Dec2006" ,
                     "Jan2007"	,	"Feb2007"	,	"Mar2007"	,	"Apr2007"	,	"May2007"	,	"Jun2007"	,	"Jul2007"	,	"Aug2007"	,	"Sep2007"	,	"Oct2007"	,	"Nov2007"	,	"Dec2007" ,
                     "Jan2008"	,	"Feb2008"	,	"Mar2008"	,	"Apr2008"	,	"May2008"	,	"Jun2008"	,	"Jul2008"	,	"Aug2008"	,	"Sep2008"	,	"Oct2008"	,	"Nov2008"	,	"Dec2008" ,
                     "Jan2009"	,	"Feb2009"	,	"Mar2009"	,	"Apr2009"	,	"May2009"	,	"Jun2009"	,	"Jul2009"	,	"Aug2009"	,	"Sep2009"	,	"Oct2009"	,	"Nov2009"	,	"Dec2009" ,
                     "Jan2010"	,	"Feb2010"	,	"Mar2010"	,	"Apr2010"	,	"May2010"	,	"Jun2010"	,	"Jul2010"	,	"Aug2010"	,	"Sep2010"	,	"Oct2010"	,	"Nov2010"	,	"Dec2010" ,
                     "Jan2011"	,	"Feb2011"	,	"Mar2011"	,	"Apr2011"	,	"May2011"	,	"Jun2011"	,	"Jul2011"	,	"Aug2011"	,	"Sep2011"	,	"Oct2011"	,	"Nov2011"	,	"Dec2011" ,
                     "Jan2012"	,	"Feb2012"	,	"Mar2012"	,	"Apr2012"	,	"May2012"	,	"Jun2012"	,	"Jul2012"	,	"Aug2012"	,	"Sep2012"	,	"Oct2012"	,	"Nov2012"	,	"Dec2012" ,
                     "Jan2013"	,	"Feb2013"	,	"Mar2013"	,	"Apr2013"	,	"May2013"	,	"Jun2013"	,	"Jul2013"	,	"Aug2013"	,	"Sep2013"	,	"Oct2013"	,	"Nov2013"	,	"Dec2013" ,
                     "Jan2014"	,	"Feb2014"	,	"Mar2014"	,	"Apr2014"	,	"May2014"	,	"Jun2014"	,	"Jul2014"	,	"Aug2014"	,	"Sep2014"	,	"Oct2014"	,	"Nov2014"	,	"Dec2014" ,
                     "Jan2015"	,	"Feb2015"	,	"Mar2015"	,	"Apr2015"	,	"May2015"	,	"Jun2015"	,	"Jul2015"	,	"Aug2015"	,	"Sep2015"	,	"Oct2015"	,	"Nov2015"	,	"Dec2015" ,
                     "Jan2016"	,	"Feb2016"	,	"Mar2016"	,	"Apr2016"	,	"May2016"	,	"Jun2016"	,	"Jul2016"	,	"Aug2016"	,	"Sep2016"	,	"Oct2016"	,	"Nov2016"	,	"Dec2016" ,
                     "Jan2017"	,	"Feb2017"	,	"Mar2017"	,	"Apr2017"	,	"May2017"	,	"Jun2017"	,	"Jul2017"	,	"Aug2017"	,	"Sep2017"	,	"Oct2017"	,	"Nov2017"	,	"Dec2017" ,
                     "Jan2018"	,	"Feb2018"	,	"Mar2018"	,	"Apr2018"	,	"May2018"	,	"Jun2018"	,	"Jul2018"	,	"Aug2018"	,	"Sep2018"	,	"Oct2018"	,	"Nov2018"	,	"Dec2018")
                     
#options(width=96)

ncol(tmp_df02)

newtmp_mat <- tmp_df02[c(1,2,1395:1416)]  #Select lat, long and all months for 2017 and 2018 

#write out the dataframe as a .csv file

csvpath <- ".../data/_orig/SPEIbase-2.5.1/outputNcdf/"
csvname <- "spei01_2017-2018.csv"
csvfile <- paste(csvpath, csvname, sep="")
write.table(na.omit(newtmp_mat),csvfile, row.names=FALSE, sep=",")
