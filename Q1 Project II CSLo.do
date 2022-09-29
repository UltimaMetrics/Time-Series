
clear
capture log close
set more off

cd "E:\UQ\Econ 7350 Applied MacroMetrics\Project II

use "spetf.dta"
log using Q1Project2.log, replace

gen t = _n
tsset t


gen ry = 100*log(y/L.y) /*log return=log(y_t/y_t-1)=log(y_t)-log(y_t-1)*/

//corrgram ry

*Q1
//(A)
//tsline ry
//ac ry
//pac ry
//dfuller ry

dfuller ry, nocon lags(2) reg 
dfuller ry, drift lags(2) reg
dfuller ry, trend lags(2) reg

//dfuller ry, nocon reg 
//dfuller ry, drift reg
//dfuller ry, trend reg

//dfuller ry, trend regress lags(30)

//(B)
*T7
//arima ry, arima(1,0,1) //AIC:  10564.76 BIC:  10589.17
//estat ic
//arima ry, arima(1,0,2) //AIC: 10559.13 BIC: 10589.65
//estat ic
//arima ry, arima(1,0,3) //AIC:  BIC: 
//estat ic
//arima ry, arima(1,0,4) //AIC: 10559.13 BIC: 10589.65
//estat ic
//arima ry, arima(2,0,1) //AIC:  10558.22 BIC: 10588.74
//estat ic
//arima ry, arima(2,0,2) //AIC:   10559.06  BIC:  10595.67
//estat ic
//arima ry, arima(2,0,3) //AIC:     BIC:  
//estat ic
//arima ry, arima(2,0,4) //AIC:     BIC:  
//estat ic
//arima ry, arima(3,0,1) //AIC:     BIC:  
//estat ic
arima ry, arima(3,0,2) //AIC:     BIC:  
estat ic
arima ry, arima(3,0,3) //AIC:     BIC:  
estat ic
//arima ry, arima(3,0,4) //AIC:     BIC:  
//estat ic
//arima ry, arima(4,0,1) //AIC:     BIC:  
//estat ic
//arima ry, arima(4,0,2) //AIC:     BIC:  
//estat ic
//arima ry, arima(4,0,3) //AIC:     BIC:  
//estat ic
//arima ry, arima(4,0,4) //AIC:     BIC:  
//estat ic

*general convention is to choose ARMA (1,1)
//However, best model is (3,3) before (4,4)
quietly arima ry, arima(3,0,3)
predict ehat, res
gen ehat2 = ehat^2

*HO:no arch effects (no arch = homoskedasticity)
*e(N)*e(r2) is chi-squared distributed with k degree of freedom
*If e(N)*e(r2)> chi-squared(k) => reject the null and favor the alternative
reg ehat2 L.ehat2 //1 means reject the null
dis e(N)*e(r2) > invchi2(1, 0.95)
reg ehat2 L.ehat2 L2.ehat2 //1 means reject the null
dis e(N)*e(r2) > invchi2(2, 0.95)
reg ehat2 L.ehat2 L2.ehat2 L3.ehat2
dis e(N)*e(r2) > invchi2(3, 0.95) //1 means reject the null
reg ehat2 L.ehat2 L3.ehat2 L3.ehat2 L4.ehat2
dis e(N)*e(r2) > invchi2(4, 0.95) //1 means reject the null
//It shows o, so Do Not Reject the null as LM tst
//statistics is smaller than the critical value of Chi-square q distribution//

//(C)
*Select a preferred ARMA-ARCH(q) model
//arch ry, arima(3,0,3) arch(1) //AIC:  BIC: ; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2) //AIC:   BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3) //AIC: BIC:; p value sign
//estat ic
arch ry, arima(3,0,3) arch(1,2,3,4) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13,14) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19) //AIC:  BIC:; p value sign
//estat ic
//arch ry, arima(3,0,3) arch(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) //AIC:  BIC:; p value sign
//estat ic


*AIC and BIC give conflicting answer

//(D)
*Select a preferred ARMA-GARCH (p, q) model using BIC only
arch ry, arima(3,0,3) arch(1) garch(1) //BIC:
estat ic
arch ry, arima(3,0,3) arch(1) garch(2) //BIC:
estat ic
arch ry, arima(3,0,3) arch(1) garch(3) //BIC:
estat ic
arch ry, arima(3,0,3) arch(2) garch(1) //BIC:
estat ic
arch ry, arima(3,0,3) arch(2) garch(2) //BIC:
estat ic
//Note: ARMA 1,1 and GARCH 1,1 is the best //

//(E)
*T8
*Fit ARMA-TARCH model
//arch ry, arima(1,0,1) arch(1) garch(1) tarch(1) 
//arch ry, arima(1,0,1) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(1,0,2) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(1,0,3) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(1,0,4) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(2,0,1) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(2,0,2) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(2,0,3) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(2,0,4) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(3,0,1) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(3,0,2) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(3,0,3) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(3,0,4) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(4,0,1) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(4,0,2) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(4,0,3) arch(1) garch(1) tarch(1) nolog
//estat ic

//arch ry, arima(4,0,4) arch(1) garch(1) tarch(1) nolog
//estat ic
*Test the existence of leverage effects
arch ry, arima(3,0,3) arch(1) garch(1) tarch(1) nolog
estat ic
predict tgarch_h, var
predict ry_hat, y
tsline ry ry_hat tgarch_h

//(F)
//Fit a GARCH-M model with GARCH(2,1)
//arch ry, arch(1) garch(1,2) archm nolog //this model includes only a constant for the mean
//arch ry, arch(1) garch(2) archm nolog //this model includes only a constant for the mean
arch ry, arch(1) garch(1/2) archm nolog
predict garchm_h, var
predict y_hat_m, y
tsline garchm_h 


log close
