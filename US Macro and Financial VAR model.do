
/************************************************************
already Changed this to EVIEWS**************/

clear
capture log close
set logtype text
log using macro1.txt, replace

set more off

/*Import data*/
import fred PAYEMS FEDFUNDS UMCSENT SP500 DTWEXB M2SL CES0500000003, daterange(2008-08-01 2022-04-30) aggregate(monthly,eop)


/*time series model declaration*/
tsset daten, monthly
tsset

rename PAYEMS NP
rename FEDFUNDS I
rename UMCSENT UMC
rename SP500 SP
rename DTWEXB USD
rename M2SL M2
rename CES0500000003 NW
/*NP as nonparm payrolls*/
/*UMC as University of Michigan Consumer Confidence*/
/*USD as Traded weighted US Dollar Index*/
/*NW as Nominal Hourly Wage*/


generate LNP=log(NP)
generate LUMC=log(UMC)
generate LSP=log(SP)
generate LUSD=log(USD)
generate LM2=log(M2)
generate LNW=log(NW)

generate DLNP=d.LNP
generate DLUMC=d.LUMC
generate DLSP=d.LSP
generate DLUSD=d.LUSD
generate DLM2=d.LM2
generate DLNW=d.LNW
generate DI=d.I

/*Unit Root Test*/


/*Cointegration Test*/



/*Vector Autoregression and stability check*/
var NP I NW UMC 
varstable, graph


/*Assume Fed rate is the exogeneous variable*/
var NP I NW UMC, lags(1/2) dfk
/*Note: STATA's default is set at two lags, so no need to add lags for this model*/


irf create order3, step(10) set(myirfnpshock,replace)
irf graph oirf, impulse(NP) response(NP I NW UMC) 
irf table oirf, impulse(NP) response(NP I NW UMC) 




/************************************************************
already Changed this to EVIEWS**************/















log cl
