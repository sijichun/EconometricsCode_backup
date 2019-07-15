clear
set more off
use datasets/bronzini_r_and_d.dta

gen s=score-75
gen treat=s>0
gen s2=s^2 
gen s3=s^3

//左边
gen ls=s*(1-treat)
gen ls2=ls^2
gen ls3=ls^3
//右边
gen rs=s*treat
gen rs2=rs^2
gen rs3=rs^3

//全样本，多项式
reg INVSALES treat ls rs, cluster(score)
reg INVSALES treat ls ls2 rs rs2, cluster(score)
reg INVSALES treat ls ls2 ls3 rs rs2 rs3, cluster(score)
// 分数为10的窗宽
reg INVSALES treat ls rs if s<10 & s>-10, cluster(score)
reg INVSALES treat ls ls2 rs rs2 if s<10 & s>-10, cluster(score)
reg INVSALES treat ls ls2 ls3 rs rs2 rs3 if s<10 & s>-10, cluster(score)
// rdrobust
rdrobust INVSALES s, c(0) h(10)
rdrobust INVSALES s, c(0)

// 画图
reg INVSALES treat ls ls2 ls3 if s<0 & s>-10
predict l_pred_INVSALES
reg INVSALES treat rs rs2 rs3 if s>=0 & s<10
predict r_pred_INVSALES
sort s
twoway (scatter INVSALES s if s<10 & s>-10)/*
	*/ (line l_pred_INVSALES s if s<=0 & s>-10)/*
	*/ (line r_pred_INVSALES s if s>=0 & s<10)
// manipulation检验
rddensity s, c(0)
