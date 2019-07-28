// file: qreg_consump.do
use datasets/cfps_family_econ, clear
drop if expense<=0
drop if fincome1<=0
gen log_consump=log(expense)
gen log_income=log(fincome1)
// quantile regression, one variate
qreg log_consump log_income, q(0.25)
predict p_log_consump25
label variable p_log_consump25 "25% quantile"
qreg log_consump log_income, q(0.50)
predict p_log_consump50
label variable p_log_consump50 "50% quantile"
qreg log_consump log_income, q(0.75)
predict p_log_consump75
label variable p_log_consump75 "75% quantile"
// graph
sort log_income
twoway (scatter log_consump     log_income)/*
	*/ (line    p_log_consump25 log_income)/*
	*/ (line    p_log_consump50 log_income)/*
	*/ (line    p_log_consump75 log_income)
// comparison
sqreg log_consump log_income i.provcd14, q(0.25 0.5 0.75)
test [q25]log_income=[q50]log_income=[q75]log_income
