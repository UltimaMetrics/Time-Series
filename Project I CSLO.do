 

clear
capture log close
set more off

*cd "E:\UQ\Econ 7350 Applied MacroMetrics\Research Project I
cd "D:\UQ\2019 S1\Econ 7350 Applied MacroMetrics\ECON7350 Assignment\Research Project I"
use "project1data.dta"
log using Project1.log, replace


//(a) Load the data to Stata and declare the data as time series using year. Draw the time series plot of{lnkt}. Comment on the stationarity of{lnkt}

//keep year lnk /*select year and lnk*/

tsset year

gen t=_n
/*use date function to generate time variable*/
format year %ty  /*format yearly data (%tw week, %tm month, %ty yearly*/
//It is not stationary as it exhibits a strong trend in the first few years and followed by a much smaller magnitude of upward change.
//It is likely a random walk plus drift//

//label variable lnk "Log of physical capital stock per labor unit (lnk)"  /*change variable label*/
//twoway line lnk yr, xlabel(1(800)54, valuelabel) // 54 observations //
//graph twoway line lnk year
tsline lnk /*either one*/


//(b)
*ac lnk //In the beginning, the ACF of lnk presents a AR(1) process which converges toward zero geometrically. However, as the lag reaches 19, the ACF becomes negative. 
//Therefore, it also implies that this variable is not stationary.
*pac lnk //The PACF of lnk decays in a oscillatary path from lag 2 as MA(1) dominates.
//Overall, this is a ARMA (1,1) model.

//(c)

//arima lnk, arima(1,1,0)
//estat ic 

//arima lnk, arima(1,1,1)
//estat ic

//arima lnk, arima(1,1,2)
//estat ic

//arima lnk, arima(1,1,3)
//estat ic

//arima lnk, arima(1,1,4)
//estat ic

//arima lnk, arima(2,1,0)
//estat ic

//arima lnk, arima(2,1,1)
//estat ic

arima lnk, arima(2,1,2)
estat ic

//arima lnk, arima(2,1,3)
//estat ic

//arima lnk, arima(2,1,4)
//estat ic//



//(d)
//(d.1)Draw a time series plot of the residuals you obtain via estimating the ARIMA model selected
quietly arima lnk, arima(2,1,2)
predict ehat, res //
twoway line ehat year  //Plot of residual//
sum ehat 
corrgram ehat 


*Forecast from youtube
*Dynamic forecast
predict r

//We run Ljung-Box tests for k = 3; :::; 10. For each k, the Q-statistic
*H0:No auto for k lags
//Ha: at least one of k auto is different from zero
//Q stat is chi 2(k-p-q) degree of freedom
//In practice, this test should be conducte for different values of k
//If k is small, one may miss signfiicant rho_k for large k and fail to reject
//if k is too large, you have to use less observation, this is an issue for small sample case


* critical values k = 3,...,10
forvalues k = 5(1)9 {
display invchi2(`k'-2-2, 0.95) //k-2-2 becuase the best model I chose has p equals 2 and q equals 2
}


forvalues k = 5(1)9 {
display r(q`k') 
}

* test: compare Q-statistics with critical values, 1-reject, 0-not reject
forvalues k = 5(1)9 {   //for loop
display r(q`k') > invchi2(`k'-2-2, 0.95) //returns the inverse of chi2(): if chi2(df,x)=p, then invchi2(df,p)=x.  //Ljung-Box test is chi2 (k-p-q) distributed
}


*We failed to reject that lnk has no autocorrelation for 3~10 lags and so we can conclude that lnk is independently distributed at 95% significance level.
*Yes this is a good model.

//(e)
dfuller lnk, nocon lags(2) reg 
dfuller lnk, drift lags(2) reg
dfuller lnk, trend lags(2) reg
corrgram lnk, lag(20)

gen dlnk=D.lnk

dfuller dlnk, nocon lags(2) reg 
dfuller dlnk, drift lags(2) reg
dfuller dlnk, trend lags(2) reg


gen d2lnk=D.dlnk
dfuller d2lnk, nocon lags(2) reg 
dfuller d2lnk, drift lags(2) reg
dfuller d2lnk, trend lags(2) reg

//test (year = 0) (L.lnk = 0) 

dfuller lny, nocon lags(2) reg 
dfuller lny, drift lags(2) reg
dfuller lny, trend lags(2) reg

test (t=0) (lnk=0) (_cons=0)

*phi 2 for lny
//test (year=0) (lny=0) (_cons=0)
*phi 3 for lny
//test (year=0) (lny=0)

gen dlny=D.lny
dfuller dlny, nocon lags(2) reg 
dfuller dlny, drift lags(2) reg
dfuller dlny, trend lags(2) reg

gen d2lny=D.dlny
dfuller d2lny, nocon lags(2) reg 
dfuller d2lny, drift lags(2) reg
dfuller d2lny, trend lags(2) reg


dfuller lnw, nocon lags(2) reg 
dfuller lnw, drift lags(2) reg
dfuller lnw, trend lags(2) reg

gen dlnw=D.lnw
dfuller dlnw, nocon lags(2) reg 
dfuller dlnw, drift lags(2) reg
dfuller dlnw, trend lags(2) reg

gen d2lnw=D.dlnw
dfuller d2lnw, nocon lags(2) reg 
dfuller d2lnw, drift lags(2) reg
dfuller d2lnw, trend lags(2) reg

dfuller lno, nocon lags(2) reg 
dfuller lno, drift lags(2) reg
dfuller lno, trend lags(2) reg

gen dlno=D.lno
dfuller dlno, nocon lags(2) reg 
dfuller dlno, drift lags(2) reg
dfuller dlno, trend lags(2) reg
//(f)
ssc install ardl

//Estimate ARDL models with differetnt (p, q, m) , up to 2
* compare their BIC and AIC
*Let student know how to fit an ARDL model using the user developed command
*the option "lag" specifies (p,q,m) of the model and "tr" specifies the trend
*P=1(1)2 means 1 to 2 seprated by (1)

//forvalues p = 1(1)3 {
//forvalues q = 1(1)3 {
//forvalues l = 1(1)3 {
//forvalues m = 1(1)3 {
//quietly ardl lny lnk lnw lno, lags(`p' `q' `l' `m') tr(t) 
//display "For ARDL model with (p,q,l,m) = " "(`p',`q',`l',`m')"
//estat ic
//}
//}
//}
//}

*Among all, ARDL ?  has the smallest BIC which is ?

//(f)the above model selection can be done by simply using "maxlags" and "bic"
ardl lny lnk lnw lno d01 d0 d77, maxlags(3 3 3 3 3 3 3) tr(t) bic 
estat ic



//(g)
*It tells me ARDL (3,0,1,0,0,0,0) is the best which gives lowest BIC
*could also be (2,1,1,1,0,0,0)
ardl lny lnk lnw lno, lags(3,0,1,0) exog (d01 d0 d77) tr(t) ec1
estat ic



//(h)
ssc install egranger
egranger lnk lny lnw lno, lags(2) regress 
egranger lny lnk lnw lno, lags(2) regress 
egranger lnw lnk lny lno, lags(2) regress 
egranger lno lnk lny lnw, lags(2) regress 
egranger lny lno lnw lnk, lags(2) regress 
egranger lnw lno lny lnk, lags(2) regress 
egranger lno lnw lny lnk, lags(2) regress 
egranger lno lnw lnk lny, lags(2) regress 

//(i)
reg dlny d01 d0 d77 dlnk dlnw dlno

log close
