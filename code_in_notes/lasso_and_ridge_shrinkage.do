clear
set more off
use "datasets/cfps_adult.dta"
// data cleaning and generating
gen log_income=log(p_income)
drop if te4<0
gen age=2014-cfps_birthy
gen age2=age^2
egen std_age=std(age)
egen std_age2=std(age2)
tab te4, gen(edu)
tab provcd14, gen(province)
// lasso regression
lasso linear log_income (std_age) std_age2 edu* province*, /*
	*/selection(cv)
lassoinfo
local post_vars=e(post_sel_vars)
coefpath
graph export beta_lasso_plot.pdf, replace
reg `post_vars'
// ridge regression
elasticnet linear log_income (std_age) std_age2 edu* province*, /*
	*/selection(cv) alpha(0)
lassoinfo
local post_vars=e(post_sel_vars)
coefpath
graph export beta_ridge_plot.pdf, replace
reg `post_vars'