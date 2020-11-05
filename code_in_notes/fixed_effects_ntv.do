// fixed_effects_ntv.do
clear
set more off
use datasets/NTV_Aggregate_Data_reshaped.dta
xtset tik_id year
forvalues i=1/5{
    gen log_pop_`i'=logpop^`i'
    gen log_wage_`i'=log_wage^`i'
}
// 简单回归
reghdfe Votes_Edinstvo_ Watch_probit if year==1999, absorb(region)  cluster(region)
// 加入社会经济控制
local E_controls "L.log_pop_* L.log_wage_* L.nurses L.doctors_pc"
reghdfe Votes_Edinstvo_ Watch_probit `E_controls' if year==1999, absorb(region) cluster(region)
// 加入1995年选举的变量
local X_controls "L4.Votes_KPRF_ L4.Votes_Yabloko_ L4.Votes_NDR_ L4.Votes_LDPR_ L4.Turnout"
reghdfe Votes_Edinstvo_ Watch_probit `E_controls' `X_controls' if year==1999, absorb(region) cluster(region)
