clear
set more off
*** gen data ***
use datasets/soep_female_labor
replace husworkhour=husworkhour/1000
gen logIncome=log(income)
egen AveIncome=mean(income),by(persnr)
gen logAveIncome=log(AveIncome)
drop AveIncome
gen age2=age^2/100
egen MaxChld6=max(chld6), by(persnr)
*** controls ***
xtset persnr year
local control1 "chld6 chld16 age age2 logIncome husworkhour husemployment"
local control2 "chld6 chld16 age2 logIncome husworkhour husemployment"
local fixed "edu region"
quietly: tab year, gen(year)
local yeardummy "year1-year4"
foreach v in `control2'{
	egen ave`v'=mean(`v'), by(persnr)
}
local controlmean1 "MaxChld6 avechld6 avechld16 logAveIncome avehusworkhour avehusemployment"
*** descriptive stats ***
egen temp=sum(employment),by(persnr)
gen sortvara=1 if temp==0
replace sortvara=2 if temp==5
replace sortvara=3 if sortvara==.
drop temp
bysort sortvara: outreg2 using soep_female_labor_descr.tex, replace sum(log) keep(employment `control1' `fixed') eqkeep(mean sd min max)
*** regression ***
probit employment `control1' `fixed' `yeardummy'
margins, dydx(*)
outreg2 using soep_female_labor_res.tex, replace ctitle("Probit") keep(`control1' `fixed')
logit employment `control1' `fixed' `yeardummy'
margins, dydx(*)
outreg2 using soep_female_labor_res.tex, append ctitle("Logit") keep(`control1' `fixed')
xtprobit employment `control1' `fixed' `yeardummy'
margins, dydx(*)
outreg2 using soep_female_labor_res.tex, append ctitle("Random Effects Probit") keep(`control1' `fixed')
xtprobit employment `control1' `controlmean1' `fixed'  `yeardummy'
margins, dydx(*)
outreg2 using soep_female_labor_res.tex, append ctitle("Chamberlain Probit") keep(`control1' `fixed' MaxChld6)
xtlogit employment `control2'  `yeardummy', fe
margins, dydx(*)
outreg2 using soep_female_labor_res.tex, append ctitle("Fixed Effects Logit") keep(`control2')
