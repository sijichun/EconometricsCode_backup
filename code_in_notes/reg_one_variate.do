// file: reg_one_variate.do
use datasets/cfps_adult, clear
drop if qp102<0
drop if qp101<130
reg qp102 qp101
outreg2 using reg_one_variate.tex, replace
predict p_weight
label variable p_weight "预测的体重"
sort qp101
twoway (scatter qp102 qp101 if mod(_n,30)==20)/*
     */(line p_weight qp101 if qp101>130 & qp101<200),/*
     */ xscale(range(130 200))
graph export reg_one_variate.pdf, replace
