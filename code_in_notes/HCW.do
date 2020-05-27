clear
use datasets/HCW.dta,clear
tsset time
gen n=_n
gen pretreat=(n<18)
reg HongKong Japan Korea Philippines Taiwan if pretreat
predict counterfactual
gen treatment = HongKong - counterfactual
tsline HongKong counterfactual,lp(solid dash) xline(150) yline(0)
tsline treatment,xline(150) yline(0)
