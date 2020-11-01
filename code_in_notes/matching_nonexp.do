// matching_nonexp.do
// 加入非实验的CPS数据来改进匹配
// 重新打开数据（由于上面删除了一些观测）
clear
set more off
use datasets/Lalonde_nsw/nsw.dta
append using datasets/Lalonde_nsw/cps_controls.dta
local controls "age-nodegree"
gen unemployed75=re75==0
// 简单比较
bysort treat: su re78
reg re78 treat, r
// 使用回归进行控制
reg re78 treat `controls', r
//查看common support
bysort treat: su `controls'
drop if age>50
drop if education>17
drop if education<4
// 使用临近匹配进行控制, ATE
local nn=5
teffects nnmatch (re78 `controls') (treat), nn(`nn') atet
teffects nnmatch (re78 `controls' re75) (treat), nn(`nn') atet
cap teffects nnmatch (re78 age edu re75) (treat), nn(`nn') ematch(black hispanic married nodegree) atet osample(omitted)
drop if omitted
drop omitted
cap teffects nnmatch (re78 age edu re75) (treat), nn(`nn') ematch(black hispanic married nodegree) atet osample(omitted)
drop if omitted
drop omitted
teffects nnmatch (re78 age edu re75) (treat), nn(`nn') ematch(black hispanic married nodegree) atet
// 评估两个组别的平衡性
tebalance summarize
// 评估unconfoundedness
teffects nnmatch (re75 `controls') (treat), nn(20) atet
