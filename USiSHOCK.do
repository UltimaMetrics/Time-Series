

clear

import fred CPIAUCSL FEDFUNDS, daterange(2005-02-01 2018-03-01) aggregate(monthly,eop)


tsset daten, monthly
tsset
rename CPIAUCSL CPI
rename FEDFUNDS I

reg CPI I, vce(robust)
var I CPI
