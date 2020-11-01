// matching.do
clear
set more off

// 实验数据
use datasets/Lalonde_nsw/nsw.dta
local controls "age-nodegree"
// 事后比较
bysort treat: su re78
reg re78 treat, r
// 使用回归进行控制
reg re78 treat `controls', r
// 查看common support
bysort treat: su `controls'
drop if age>50
drop if education>14
// 使用临近匹配进行控制, ATE
teffects nnmatch (re78 `controls') (treat), nn(1)
// 评估两个组别的平衡性
// 使用临近匹配进行控制, ATT
teffects nnmatch (re78 `controls') (treat), nn(1) atet
tebalance summarize
// 评估unconfoundedness
teffects nnmatch (re75 `controls') (treat), nn(1)


// 精确匹配，首先扔掉那些不能精确匹配的样本
cap teffects nnmatch (re78 `controls') (treat), nn(1) ematch(black hispanic married nodegree) osample(omitted)
drop if omitted
drop omitted
cap teffects nnmatch (re78 `controls') (treat), nn(1) ematch(black hispanic married nodegree) osample(omitted)
drop if omitted
drop omitted
// 同理进行匹配估计
teffects nnmatch (re78 age education) (treat), nn(1) ematch(black hispanic married nodegree) gen(matched)
tebalance summarize
