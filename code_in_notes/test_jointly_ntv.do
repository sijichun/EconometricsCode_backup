// test_jointly_ntv.do
clear
set more off
use datasets/NTV_Aggregate_Data_reshaped.dta
xtset tik_id year
// 不进行控制进行检验
reghdfe NTV L4.Votes_NDR_ L4.Votes_SPS_ L4.Votes_Yabloko_ L4.Votes_KPRF_ L4.Votes_LDPR_ L4.Turnout if year==1999, absorb(region) 
test L4.Votes_NDR_ L4.Votes_SPS_ L4.Votes_Yabloko_ L4.Votes_KPRF_ L4.Votes_LDPR_ L4.Turnout
// 控制社会经济变量以及人口、工资的多项式
forvalues i=1/5{
    gen log_pop_`i'=logpop^`i'
    gen log_wage_`i'=log_wage^`i'
}
local E_controls "L.log_pop_* L.log_wage_* L.nurses L.doctors_pc"
reghdfe NTV L4.Votes_NDR_ L4.Votes_SPS_ L4.Votes_Yabloko_ L4.Votes_KPRF_ L4.Votes_LDPR_ L4.Turnout `E_controls' if year==1999, absorb(region)
test L4.Votes_NDR_ L4.Votes_SPS_ L4.Votes_Yabloko_ L4.Votes_KPRF_ L4.Votes_LDPR_ L4.Turnout
