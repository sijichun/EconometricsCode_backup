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
// 计算propensity score
logit treat `controls' `extra_controls'
predict ps
// 查看ps的描述统计
bysort treat: su ps, de
twoway (hist ps if treat==0, color(green%30))/*
     */(hist ps if treat==1, color(red%30))/*
     */, leg(lab(1 "Untreated") lab(2 "Treated"))
// 检查common support
gen ignore=ps<0.15
twoway (hist ps if treat==0, color(green%30))/*
     */(hist ps if treat==1, color(red%30))/*
     */, leg(lab(1 "Untreated") lab(2 "Treated"))
// 进行PSM
local nn=3
teffects psmatch (re78) (treat `controls') if ~ignore, atet nn(`nn')
teffects psmatch (re78) (treat `controls' `extra_controls') if ~ignore, atet nn(`nn')
tebalance summarize
