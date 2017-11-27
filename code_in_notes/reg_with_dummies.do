// file: reg_with_dummies.do
use datasets/cfps_adult, clear
drop if p_income<0
drop if te4<0
tab te4, gen(edu)
reg p_income edu*
outreg2 using reg_with_dummies.tex, replace
reg p_income edu*, noconstant
outreg2 using reg_with_dummies.tex, append
