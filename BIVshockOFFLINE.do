


clear
capture log close
set logtype text
log using tyvixshockoffline.txt, replace

/*Note that this is the offline version for Bond Implied Volatility Shock research in case of the computer that you 
are using does not have STATA 15*/

/*use "H:\Time Series Research  in STATA ,EVIEWS, R\Macro and Finc Panels\iresearch.dta"*/

cd "H:\Time Series Research  in STATA ,EVIEWS, R\Macro and Finc Panels\
use "iresearch.dta"

tsset daten




/*Regression*/
reg TYVIX FED Tentwospread VIX

/*
/*Stability Check*/
var FED TYVIX Tentwospread VIX
varstable, graph
*/
/*they are stable*/

/*VAR model begins*/
var FED TYVIX Tentwospread VIX, lags(1/2) dfk
irf create order1, step(10) set(myFedirfoffline,replace)
irf graph oirf, impulse(FED) response(TYVIX Tentwospread VIX FED) 
irf table oirf, impulse(FED) response(TYVIX Tentwospread VIX FED) 


log cl
