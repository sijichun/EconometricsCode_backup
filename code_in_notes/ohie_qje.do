// replication of OHIE-QJE paper
clear frames
set more off
use datasets/OHIE_QJE.dta

// LATE，不加控制变量的结果
// 1st stage, 分母
reg ohp_std_ever_admin treatment if rx_num_mod_12m!=. , cl(household_id)
local first_stage=_b[treatment]
// Intention-to-Treat
reg rx_num_mod_12m treatment, cluster(household_id)
local ITT=_b[treatment]
// IV估计
ivreg rx_num_mod_12m (ohp_std_ever_admin = treatment), cl(household_id)
di `ITT'/`first_stage'

// 加入控制变量
// 1st stage, medcaid 和 OHP standard，两者系数几乎相同，说明只对OHP Standard有影响
// 控制变量：draw_lottery 为抽签的轮数，numhh为申请家庭的人数
reghdfe ohp_all_ever_admin treatment, absorb(i.numhh#i.draw_lottery) cl(household_id)
reghdfe ohp_std_ever_admin treatment, absorb(i.numhh#i.draw_lottery) cl(household_id)

// ITT
// 处方药，extensive margin & total utilization
reghdfe rx_any_12m treatment, absorb(i.numhh#i.draw_lottery) cl(household_id)
reghdfe rx_num_mod_12m treatment, absorb(i.numhh#i.draw_lottery) cl(household_id)
// 急救室，extensive margin & total utilization
reghdfe er_any_12m treatment, absorb(i.numhh#i.draw_lottery) cl(household_id)
reghdfe er_num_mod_12m treatment, absorb(i.numhh#i.draw_lottery) cl(household_id)

// IV估计
ivreghdfe rx_any_12m (ohp_std_ever_admin = treatment), absorb(i.numhh#i.draw_lottery) cl(household_id)
ivreghdfe rx_num_mod_12m (ohp_std_ever_admin = treatment), absorb(i.numhh#i.draw_lottery) cl(household_id)
// 急救室，extensive margin & total utilization
ivreghdfe er_any_12m (ohp_std_ever_admin = treatment), absorb(i.numhh#i.draw_lottery) cl(household_id)
ivreghdfe er_num_mod_12m (ohp_std_ever_admin = treatment), absorb(i.numhh#i.draw_lottery) cl(household_id)


