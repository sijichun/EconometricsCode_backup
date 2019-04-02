clear
set more off
// 生成数据
set seed 19880505
set obs 300
gen x=2*runiform()
gen y=exp(sin(x^3))+rnormal()
//回归
gen x2=x^2
gen x3=x^3
gen x4=x^4
reg y x*
predict yhat_unweighted
label variable yhat_unweighted "Unweighted"
//加权回归
gen w=normalden(2*x)
reg y x* [iw=w]
predict yhat_weighted
label variable yhat_weighted "Weighted"
//画图
sort x
twoway (scatter y x) /*
    */(line yhat_unweighted x) /*
    */(line yhat_weighted x) 
graph export wls.pdf
