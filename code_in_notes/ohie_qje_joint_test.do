// ohie_qje_joint_test.do
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
