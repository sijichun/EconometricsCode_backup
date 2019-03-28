clear
set more off
use datasets/cfps_adult.dta
// 清洗并产生数据
drop if employ2014<0
drop if te4<0
drop if qa301<0 | qa301==5
gen exit_labor=employ2014==3
gen age=2014-cfps_birth
gen age2=age^2
gen urban_hukou=qa301==3
// 回归并预测
local x "age age2 cfps_gender urban_hukou i.provcd14 i.te4"
logit exit_labor `x'
// 如果用probit模型：probit exit_labor `x'
predict p_exit // 预测概率
// 计算cutoff=0.5时的查准率、查全率
gen predict_exit=p_exit>0.5
gen TP=(exit_labor==1 & predict_exit==1)
gen FP=(exit_labor==0 & predict_exit==1)
gen FN=(exit_labor==1 & predict_exit==0)
gen TN=(exit_labor==0 & predict_exit==0)
foreach v of varlist TP FP FN TN{
	quietly: su `v'
	local `v' = r(mean)
}
local R2=e(r2_p)
local precision=`TP'/(`TP'+`FP')
local recall=`TP'/(`TP'+`FN')
local accuracy=(`TP'+`TN')/(`TP'+`TN'+`FP'+`FN')
local F1=(2*`precision'*`recall')/(`precision'+`recall')
di "R2=`R2'"
di "查准率=`precision'"
di "查全率=`recall'"
di "精度=`accuracy'"
di "F1=`F1'"
// 画出ROC曲线
lroc
graph export roc.pdf, replace
// 画出sensitivity 以及specificity
lsens
graph export sens_speci.pdf, replace
