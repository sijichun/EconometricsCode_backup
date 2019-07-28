// file: qreg_outlier.do
clear
set more off
set obs 50
// generate vars
gen x=rnormal()
gen u=rnormal()
// y
gen y=1+x+u
// 产生一个outlier
sort x
replace y=30 if _n==1
// qreg
reg y x
predict p_y_reg
label variable p_y_reg "OLS"
qreg y x , q(0.50)
predict p_y_qreg
label variable p_y_qreg "QREg"
// graph
twoway (scatter y        x)/*
	*/ (line    p_y_reg  x)/*
	*/ (line    p_y_qreg x)
graph export qreg_outlier.pdf, replace
