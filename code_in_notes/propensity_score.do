// propensity_score.do
clear
set more off

// 实验数据
use datasets/Lalonde_nsw/nsw.dta
gen age2=age^2
local controls "age-nodegree age2"
//Logit估计
logit treat `controls'
predict ps_1
//查看common support
bysort treat: su ps_1
//Logit估计 包含事前的y
bysort treat: su re75
logit treat `controls' re75
//事后比较
bysort treat: su re78
reg re78 treat, r


// 包含非实验数据
append using datasets/Lalonde_nsw/cps_controls.dta
replace age2=age^2
//Logit估计
logit treat `controls'
predict ps_2
//多项式Logit估计
local polynomial_control "`controls'"
foreach v of varlist `controls'{
	foreach w of varlist `controls'{
		gen _`v'_`w'=`v'*`w'
		local polynomial_control "`polynomial_control' _`v'_`w'"
	}
}
logit treat `polynomial_control'
predict ps_3
//使用Lasso选择变量
local std_polynomial_control ""
foreach v of varlist `polynomial_control'{
	egen std_`v'=std(`v')
	su std_`v', mean
	if r(N)>0 {
		local std_polynomial_control "`std_polynomial_control' std_`v'"
	}
}
lasso logit treat `controls', grid(5)
local post_vars=e(allvars_sel)
di "`post_vars'"
//post-estimation
logit treat e(`post_vars')
predict ps_4
//matching
teffects psmatch (re78) (treat `post_vars')
//使用指定的propensity score
gen trans_ps2=log(ps_2/(1-ps_2))
bysort treat: su ps_2
teffects psmatch (re78) (treat trans_ps2), atet
//后续：检查common support等
