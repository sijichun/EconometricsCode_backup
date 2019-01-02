clear
set more off

** 观测数，共15期
set obs 15
** 产生时间以及政策变量
gen t=_n // 时间
gen t2=t^2
gen d=t>5 //第6期开始有政策发生
************************无动态效应*******************************
** 政策之前的y
gen y=t+30+0.3*rnormal() if d==0
gen true_trend=t+30
label variable true_trend "真实的趋势"
** 政策之后的y，政策效应为20
replace y=t+50+0.3*rnormal() if d==1
** 不控制时间趋势
reg y d
predict y0
replace y0=y0-_b[d] if d==1
label variable y0 "无时间趋势"
** 使用一次函数控制时间趋势
reg y d t
predict y1
replace y1=y1-_b[d] if d==1
label variable y1 "线性时间趋势"
** 使用二次函数控制时间趋势
reg y d t t2
predict y2
replace y2=y2-_b[d] if d==1
label variable y2 "二次时间趋势"
twoway (connected y0 t, msymbol(triangle) msize(small))/*
	*/ (connected y1 t, msymbol(diamond) msize(small))/*
	*/ (connected y2 t, msymbol(square) msize(small))/*
	*/ (line true_trend t, lpattern(dash))/*
	*/ (scatter y t,  msymbol(circle))/*
	*/ , title("无动态效应") legend(rows(2)) scheme(s1mono)
graph export DID_dynamic_trend_linear.png, replace
************************具有动态效应*******************************
keep t t2 d
** 政策之前的y
gen y=t+30+0.3*rnormal() if d==0
gen true_trend=t+30
label variable true_trend "真实的趋势"
** 政策之后的y，第8期之前上升，之后下降
replace y=-1*(t-8)^2+50+0.3*rnormal() if d==1
** 不控制时间趋势
reg y d
predict y0
replace y0=y0-_b[d] if d==1
label variable y0 "无时间趋势"
** 使用一次函数控制时间趋势
reg y d t
predict y1
replace y1=y1-_b[d] if d==1
label variable y1 "线性时间趋势"
** 使用二次函数控制时间趋势
reg y d t t2
predict y2
replace y2=y2-_b[d] if d==1
label variable y2 "二次时间趋势"
twoway (connected y0 t, msymbol(triangle) msize(small))/*
	*/ (connected y1 t, msymbol(diamond) msize(small))/*
	*/ (connected y2 t, msymbol(square) msize(small))/*
	*/ (line true_trend t, lpattern(dash))/*
	*/ (scatter y t,  msymbol(circle))/*
	*/ , title("动态效应") legend(rows(2)) scheme(s1mono)
graph export DID_dynamic_trend_dynamic.png, replace
