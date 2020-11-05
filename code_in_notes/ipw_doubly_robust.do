// matching_psm.do
clear
set more off
use datasets/Lalonde_nsw/nsw.dta
append using datasets/Lalonde_nsw/cps_controls.dta
gen age2=age^2
gen age3=age^3
egen std_age2=std(age2)
egen std_age3=std(age3)
gen edu2=education^2
gen edu3=education^3
gen unemployed75=re75==0
gen re75s=re75^2
gen re75c=re75^3
egen std_re75s=std(re75s)
egen std_re75c=std(re75c)
gen re75_edu=re75*education
gen hisp_unemp=hispanic*unemployed75
local controls "age-nodegree std_age2-std_age3 edu2-edu3"
local extra_controls "re75 std_re75s std_re75c unemployed75 re75_edu hisp_unemp"
// 逆概率加权
cap teffects ipw (re78) (treat `controls' re75 unemployed75, logit), osample(omitted)
drop if omitted
drop omitted
teffects ipw (re78) (treat `controls'  re75 unemployed75, logit)
// 双向稳健
teffects aipw (re78 `controls' `extra_controls') (treat `controls' `extra_controls', logit)
