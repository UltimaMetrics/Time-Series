


clear
capture log close
set logtype text
log using VVM.txt, replace

set more off
/*START*/
import fred DJIA VXDCLS DFF CBBCHUSD, daterange(2017-12-22 2018-07-13) aggregate(daily)

/*time series model declearation*/
tsset daten

/*begin data cleaning*/
rename VXDCLS DJVIX
rename DFF I
rename CBBCHUSD BC

generate LDJIA=log(DJIA)
generate DLDJIA=D.LDJIA
generate LBC=log(BC)
generate DLBC=D.LBC
generate DI=D.I

/*histogram LDJIA, bin(100) normal
histogram DJVIX, bin(100) normal
histogram LBC, bin(100) normal*/

/*line I daten
line DJVIX daten
line DJIA daten*/

fmm 3: regress DJVIX LDJIA I

/*Unit Root test*/
dfuller DLDJIA, lags(2) trend regress
dfuller DJVIX, lags(2) trend regress
dfuller I, lags(4) trend regress
dfuller DLBC, lags(1) trend regress
dfuller BC, lags(0) trend regress

/*generate lagged variables for stationarity*/
gen DLDJIA2=DLDJIA[_n-2]
gen DJVIX2=DJVIX[_n-2]

gen DLBC1=DLBC[_n-1]

/*marginal probability*/
estat lcprob, nose 


/*marginal mean*/
estat lcmean
/*Thus, 17.43% in group 1 at 18.78, 39.85% in group 2 at 14.24, 42.71% in group 3 at 12.10*/

estimates store fmm3 

fmm 2: regress DJVIX LDJIA I
estimates store fmm2 


fmm 1: regress DJVIX LDJIA I
estimates store fmm1


/*Model selection by AIC and BIC*/
estimates stats fmm1 fmm2 fmm3
/*Both AIC and BIC indidate that three-component model is the best*/


predict den, density marginal
/*histogram DJVIX, bin(80) addplot(line den DJVIX)*/


/*Vector Autoregression and stability check*/
var DI DLBC DLDJIA DJVIX 
varstable, graph


/*Assume Fed rate is the exogeneous variable*/
var DLBC DLDJIA DJVIX, dfk exog(DI)
/*Note: STATA's default is set at two lags, so no need to add lags for this model*/
varbasic DI DLBC DLDJIA DJVIX

/*Name the shock*/
irf create DIshock, step(10) set(myirfDIshock,replace)

irf graph irf, impulse(DI) response(DI DLBC DLDJIA DJVIX) 

irf table irf, impulse(DI) response(DI DLBC DLDJIA DJVIX) 

/*MS SWITCH*/
mswitch dr I


/*Volatiility modeling*/
/*ARCH GARCH*/
regress DLDJIA
estat archlm, lags(1)
arch DLDJIA, arch(1) garch(1) 
/*EGARCH*/
arch DLDJIA, ar(1) ma(1 4) earch(1) egarch(1) 

log cl
