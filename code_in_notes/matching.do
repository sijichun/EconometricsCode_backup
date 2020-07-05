clear
set more off

// 实验数据
use datasets/Lalonde_nsw/nsw.dta
local controls "age-nodegree"
//查看common support
bysort treat: su `controls'
drop if age>50
drop if education>14
//事后比较
bysort treat: su re78
reg re78 treat, r
// NN matching, ATE
teffects nnmatch (re78 `controls') (treat), nn(1)
tebalance summarize

cap teffects nnmatch (re78 `controls') (treat), nn(1) ematch(black hispanic married nodegree) osample(omitted)
drop if omitted
drop omitted
cap teffects nnmatch (re78 `controls') (treat), nn(1) ematch(black hispanic married nodegree) osample(omitted)
drop if omitted
drop omitted
teffects nnmatch (re78 `controls') (treat), nn(1) ematch(black hispanic married nodegree) gen(matched)
tebalance summarize
teffects nnmatch (re75 `controls') (treat), nn(1) ematch(black hispanic married nodegree)
