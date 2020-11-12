// replication of OHIE-Science paper
clear frames
set more off
use datasets/OHIE_Science.dta

// 主要结果
// 1st stage
reg ohp_all_ever_30sep2009 treatment ed_visit_09mar2008 i.numhh_list, cl(household_id)
// ITT
reg ed_visit_30sep2009 treatment  ed_visit_09mar2008 i.numhh_list, cl(household_id)
reg num_visit_cens_ed treatment  num_visit_pre_cens_ed i.numhh_list, cl(household_id)
// main results
ivregress 2sls ed_visit_30sep2009 (ohp_all_ever_30sep2009=treatment ) ed_visit_09mar2008 i.numhh_list, cl(household_id)
ivregress 2sls num_visit_cens_ed (ohp_all_ever_30sep2009=treatment ) num_visit_pre_cens_ed i.numhh_list, cl(household_id)

// 使用不同的控制结果是不一样的
local extra_controls "female_list i.birthyear_list english_list"
ivregress 2sls ed_visit_30sep2009 (ohp_all_ever_30sep2009=treatment ), cl(household_id)
ivregress 2sls ed_visit_30sep2009 (ohp_all_ever_30sep2009=treatment ) i.numhh_list, cl(household_id)
ivregress 2sls ed_visit_30sep2009 (ohp_all_ever_30sep2009=treatment ) ed_visit_09mar2008 i.numhh_list `extra_controls', cl(household_id)

// marginal treatment effects
// 由于不能用i.的形式，所以需要产生虚拟变量
quietly{
    tab birthyear_list, gen(birthyear_dummies)
    tab numhh_list, gen(numhh_dummies)
}
local controls "ed_visit_09mar2008 female_list numhh_dummies* birthyear_dummies* english_list"
// propensity score
logit ohp_all_ever_30sep2009 treatment `controls'
// 边际处理效应，使用多项式拟合propensity score的函数
margte ed_visit_30sep2009 `controls', treatment(ohp_all_ever_30sep2009 treatment `controls') common poly(4) noboot savepropensity
mat mte_mat=e(mte)
quietly: su p, de
local max_p=r(p99)
di `max_p'
// 我们发现计算的平均处理效应不准，重新计算
frame create fmte pclass mte
forvalues i=1/99{
    frame post fmte (`i') (mte_mat[1,`i'])
}
frame fmte: line mte p if p<`max_p'*100
frame fmte: su mte if p<`max_p'*100
// 边际处理效应，使用半参数方法拟合propensity score的函数
margte ed_visit_30sep2009 `controls', treatment(ohp_all_ever_30sep2009 treatment `controls') semi
