clear
cd "/Users/aragorn/OneDrive/Winter/code_in_notes/"
use datasets/HCW.dta,clear
tsset time
gen n=_n
gen pretreat=(n<45)
reg HongKong Australia  Austria  China Denmark Indonesia Italy Japan /*
	*/Korea Malaysia Mexico  NewZealand Norway Philippines Singapore Switzerland /*
	*/Taiwan  Thailand  if pretreat
predict counterfactual
gen treatment = HongKong - counterfactual
tsline HongKong counterfactual,lp(solid dash) xline(177) yline(0)
tsline treatment,xline(177) yline(0)
