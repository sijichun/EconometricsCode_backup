// file: reg_with_dummy.do
use datasets/cfps_adult, clear
keep cfps_gender p_income
drop if p_income<0
bysort cfps_gender: outreg2 using reg_with_dummy_su.tex,/*
	*/replace sum(log) eqkeep(N mean) keep(p_income)
reg p_income cfps_gender
outreg2 using reg_with_dummy.tex, replace
