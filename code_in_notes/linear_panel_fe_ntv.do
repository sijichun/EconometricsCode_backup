clear
set more off
use datasets/NTV_Aggregate_Data_reshaped.dta
xtset tik_id year
// 1995年NTV并没有成立
gen Watch_probit_p=0
replace Watch_probit_p=Watch_probit if year==1999
// 使用一阶差分
gen delta_Votes_SPS_=Votes_SPS_-L4.Votes_SPS_
gen delta_Watch_probit_p=Watch_probit_p-L4.Watch_probit_p
reg delta_Votes_SPS_ delta_Watch_probit_p i.year if year!=2003, cluster(region)
// 简单回归
reghdfe Votes_SPS_ Watch_probit_p i.year if year!=2003, absorb(i.tik_id) cluster(region)
// 使用96年人口进行加权
gen pop96t=population if year==1996
egen pop96=mean(pop96), by(tik_id)
reghdfe Votes_SPS_ Watch_probit_p i.year if year!=2003 [aw=pop96], absorb(i.tik_id) cluster(region)
