clear
set more off
cd /Users/aragorn/Working/Econometrics/EconometricsCode/code_in_notes
use datasets/citydata.dta
** 声明面板数据
xtset CityCode Year
** 产生新变量
gen log_gdp=log(v84)
gen growth_gdp=log_gdp-L.log_gdp //如何产生滞后？
	sort CityCode Year
	by CityCode: gen growth_gdp2=log_gdp-log_gdp[_n-1]
gen num_schools=v188
gen log_edu_exp=log(v166)
gen log_rd_exp=log(v167)
** controls
local control "log_edu_exp log_rd_exp i.Year"
** 回归
** pooled OLS
reg growth_gdp log_gdp i.Year, vce(cl CityCode)
outreg2 using linear_panel.doc, replace addtext(FE, No, Time FE, Yes)
** random effects
xtreg growth_gdp log_gdp i.Year, re vce(cl CityCode)
outreg2 using linear_panel.doc, append addtext(FE, No, Time FE, Yes)
** between group estimator
xtreg growth_gdp log_gdp, be
outreg2 using linear_panel.doc, append addtext(FE, No, Time FE, No)
** fixed effects
xtreg growth_gdp log_gdp i.Year, fe vce(cl CityCode)
outreg2 using linear_panel.doc, append addtext(FE, Yes, Time FE, Yes)
** LSDV
reghdfe growth_gdp log_gdp i.Year, absorb(CityCode) cluster(CityCode)
outreg2 using linear_panel.doc, append addtext(FE, Yes, Time FE, Yes)
** LSDV twoway cluster
reghdfe growth_gdp log_gdp, absorb(i.CityCode i.Year) cluster(CityCode Year)
outreg2 using linear_panel.doc, append addtext(FE, Yes, Time FE, Yes)

** 加入控制变量
** random effects
xtreg growth_gdp log_gdp `control', re 
estimates store re
** fixed effects
xtreg growth_gdp log_gdp `control', fe 
estimates store fe
** Hauman 检验
hausman fe re

** interactive fixed effects
local control "log_edu_exp log_rd_exp"
regife  growth_gdp log_gdp `control', factors(CityCode Year, 1)
regife  growth_gdp log_gdp `control', factors(CityCode Year, 2)
regife  growth_gdp log_gdp `control', factors(CityCode Year, 3)
regife  growth_gdp log_gdp `control', factors(CityCode Year, 1) absorb(i.CityCode i.Year)
