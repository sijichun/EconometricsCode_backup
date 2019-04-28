// file: oneway_anova.do
use datasets/cfps_adult, clear
gen log_income=log(p_income+1)
drop if te4<0
tab te4
// 用回归方法：
reg log_income i.te4
di "F=" e(F) " RSS=" e(rss)
// 用单因素方差分析
anova log_income te4
di "F=" e(F) " RSS=" e(rss)
