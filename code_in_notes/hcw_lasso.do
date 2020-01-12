clear
set more off
use datasets/shannxi_export.dta
tsset year
order year export_locationShaanxi
foreach v of varlist export_locationShaanxi- export_locationZhejiang{
	replace `v'=log(`v')
	egen std_`v'=std(`v')
}
local control "std_export_locationShanghai std_export_locationShanxi std_export_locationFujian std_export_locationGuangdong std_export_locationGuizhou std_export_locationHeilongjiang std_export_locationJiangxi std_export_locationAnhui"
lasso linear export_locationShaanxi `control' if year<2013
local selected_vars=e(post_sel_vars)
predict p_shaanxi_lasso
reg `selected_vars' if year<2013
predict p_shaanxi
label variable export_locationShaanxi "陕西省实际出口"
label variable p_shaanxi "陕西省出口的反事实估计"
label variable p_shaanxi_lasso "陕西省出口的反事实估计Lasso"
tsline export_locationShaanxi p_shaanxi p_shaanxi_lasso, lp(solid dash) xline(2013 2016, lstyle(grid)) scheme(s1mono) xtitle("年份") ytitle("出口对数值")
graph export hcw_lasso.pdf, replace
