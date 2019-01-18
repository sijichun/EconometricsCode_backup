clear
set more off
cd /Users/aragorn/Working/Econometrics/EconometricsCode/code_in_notes
use datasets/citydata.dta
** 声明面板数据
xtset CityCode Year
** 产生新变量
gen log_gdp=log(v84)
gen growth_gdp=log_gdp-L.log_gdp
gen num_schools=v188
gen log_edu_exp=log(v166)
gen log_rd_exp=log(v167)
** controls
local control "log_edu_exp log_rd_exp"
** 回归
** pooled OLS
reg growth_gdp log_gdp , vce(cl CityCode)
outreg2 using panel_no_control.doc, replace addtext(FE, No)
** random effects
xtreg growth_gdp log_gdp, re vce(cl CityCode)
outreg2 using panel_no_control.doc, append addtext(FE, No)
** between group estimator
xtreg growth_gdp log_gdp, be
outreg2 using panel_no_control.doc, append addtext(FE, No)
** fixed effects
xtreg growth_gdp log_gdp, fe vce(cl CityCode)
outreg2 using panel_no_control.doc, append addtext(FE, Yes)
** LSDV
reghdfe growth_gdp log_gdp, absorb(CityCode) cluster(CityCode)
outreg2 using panel_no_control.doc, append addtext(FE, Yes)
** LSDV twoway cluster
reghdfe growth_gdp log_gdp, absorb(CityCode) cluster(CityCode Year)
outreg2 using panel_no_control.doc, append addtext(FE, Yes)

** 加入控制变量
** random effects
xtreg growth_gdp log_gdp `control', re 
estimates store re
** fixed effects
xtreg growth_gdp log_gdp `control', fe 
estimates store fe
** Hauman 检验
hausman fe re
