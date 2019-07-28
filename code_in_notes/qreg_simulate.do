// file: qreg_simulate.do
clear
set more off
set obs 1000
// generate vars
gen x=rnormal()
gen u=rnormal()
// u的分位数
gen q=normal(u)
// 系数：b(0.25)=1.25，b(0.5)=1.5
gen b=1+q
// y
gen y=1+b*x+u
// qreg
qreg y x , q(0.25)
qreg y x , q(0.50)
qreg y x , q(0.75)
