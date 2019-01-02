clear
set more off
use "datasets/cfps_adult.dta"
// data cleaning and generating
gen log_income=log(p_income)
drop if te4<0
gen age=2014-cfps_birthy
gen age2=age^2
// lasso regression
lasso2 log_income age age2 i.te4 i.provcd14, /*
	*/alpha(1) lmax(800) plotpath(lambda) plotopt(legend(off))
graph export beta_lasso_plot.png, replace
// ridge regression
lasso2 log_income age age2 i.te4 i.provcd14, /*
	*/alpha(0) lmax(800) plotpath(lambda) plotopt(legend(off))
graph export beta_ridge_plot.png, replace
