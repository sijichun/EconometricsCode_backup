clear
set more off
use "datasets/cfps_family_econ.dta"
// 线性回归
reg expense fincome1
predict expense_linear
// 非线性回归
drop if fincome1==. | fincome1<0
drop if expense==. |expense<0 | expense>5*fincome1
nl (expense={alpha=_b[_cons]}+{beta=_b[fincome1]}*fincome1^{gamma=1})
predict expense_nls
// 计算MPC
gen mpc=_b[/beta]*_b[/gamma]*fincome1^(_b[/gamma]-1)
// 画图
sort fincome1
twoway (scatter expense fincome1)/*
    */ (line expense_linear fincome1)/*
    */ (line expense_nls fincome1)
graph export nls_mpc.pdf, replace
