
clear
capture log close
set more off

cd "D:\UQ\2019 S1\Econ 7350 Applied MacroMetrics\ECON7350 Assignment\Project II

use "spetf.dta"
log using Q2Project2.log, replace



gen t = _n
tsset t

drop in 1/1058

gen ry = 100*log(y/L.y)
gen rx = 100*log(x/L.x)
gen rz = 100*log(z/L.z)

*Q2
//(A)
*Select the lag length p (T9)
varsoc ry rx rz, maxlag(10) 
*AIC suggests that I should choose lag length 5


//(B)
*Check the statonarity of VAR(p) (T9)
quietly var ry rx rz, lags(1/5) 
//varstable, graph
*The system is stable with VAR(5)

//varlmar, mlag(12)
*LM test shows that we cannot reject the null hypothesis that there is no autocorrelation at lag 5.

//(C)
*Write out the companion form

//(D)Use Cholesky decompositi

*(1)Compute impulse response (T10)
capture irf drop order1 order2 order3 order4 order5 order6
irf create order1, order(ry rx rz) set(irfs)
irf graph oirf, irf(order1) byopts(yrescale) yline(0) 

irf create order2, order(ry rz rx) 
irf graph oirf, irf(order2) byopts(yrescale) yline(0)

irf create order3, order(rx rz ry) 
irf graph oirf, irf(order3) byopts(yrescale) yline(0)

irf create order4, order(rx ry rz) 
irf graph oirf, irf(order4) byopts(yrescale) yline(0)

irf create order5, order(rz ry rx)
irf graph oirf, irf(order5) byopts(yrescale) yline(0)

irf create order6, order(rz rx ry) 
irf graph oirf, irf(order6) byopts(yrescale) yline(0)

irf describe

*IRF graph

*(2)Choose the most reasonable ordering and justify (T10)

*(3)Ger Forcast error variance decomposition using the ordering above (T10)

irf graph fevd, irf(order1) yline(1)
irf table fevd, irf(order1)

//(E)
*Do you think they Granger cause each other (T10)
quietly var ry rx rz, lags(1/5)
vargranger



























log close
