// poisson.do
clear
set more off
use "C:\Users\sijic\Working\Econometrics\EconometricsCode\code_in_notes\datasets\CivilConflict.dta"
collapse (sum) any_prio (mean)lpop gdp_g y_0 gini aid_capita,by(ccode)

local control "lpop gdp_g y_0 gini aid_capita"
poisson any_prio `control'
nbreg any_prio `control'
zip any_prio `control', inflate(_cons)
zip, irr
