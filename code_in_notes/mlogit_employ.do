// mlogit_employ.do
clear
set more off
use datasets/cfps_adult
// clean data
keep if qg2==1 | qg2==2 | qg2==3 | qg2==4
tab qg2
gen age=2014-cfps_birthy
drop if te4<0
// regress
mlogit qg2 age cfps_gender i.te4, baseoutcome(1)
outreg2 using mlogit_employ.doc, replace
// test
test [2]age=[3]age
