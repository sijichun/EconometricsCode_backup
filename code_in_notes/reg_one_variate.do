// file: reg_one_variate.do
use datasets/cfps_adult, clear
drop if qp102<0
drop if qp101<0
reg qp102 qp101
outreg2 using reg_one_variate.tex, replace
predict p_weight
sort qp101
twoway (scatter qp102 qp101)/*
     */(line p_weight qp101)
graph export reg_one_variate.png, replace
