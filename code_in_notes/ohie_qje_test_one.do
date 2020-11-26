// ohie_qje_test_one.do
clear
set more off
use datasets/OHIE_QJE.dta

// 需要进行比较的特征
local lottery_list "birthyear_list female_list english_list /*
  */ self_list first_day_list have_phone_list pobox_list zip_msa"
// 挨个比较
foreach v of varlist `lottery_list'{
	reg `v' treatment [iw=weight_12m ], robust
	test treatment
}
