// replication of OHIE-QJE paper
clear frames
set more off
use datasets/OHIE_QJE.dta

// table2 treatment-control balance
// control mean of respond to survey
// 注意权重的使用，附录中提供了调查抽样的设计，权重来自于抽样设计
su returned_12m if treatment==0 [iw=weight_12m ]
// 第二种做法，使用回归，不需要自变量，只对常数项做回归
reg returned_12m if treatment==0 [iw=weight_12m ]
di e(rmse)

// 比较随机化之前的特征
local lottery_list "birthyear_list female_list english_list self_list first_day_list have_phone_list pobox_list zip_msa"
// 挨个比较
foreach v of varlist `lottery_list'{
	reg `v' treatment [iw=weight_12m ], cl(household_id)
	test treatment
}
// 合在一起比较
frames put `lottery_list' treatment weight_12m household_id numhh_list, into(joint_compare)
frame change joint_compare
local i=0
foreach v of varlist `lottery_list'{
	local i=`i'+1
	rename `v' outcome`i'
}
gen id=_n
reshape long outcome, i(id) j(varid)
local test_coefs ""
forvalues j=1/`i'{
	local test_coefs "`test_coefs' 1.treatment#`j'.varid"
}
di "`test_coefs'"
reg outcome i.varid i.treatment#i.varid i.numhh_list#i.varid , cl(household_id)
test `test_coefs'
frame change default

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


