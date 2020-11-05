// linear_panel_fd.do
clear
set more off
use datasets/voting_cnty_clean.dta

xtset cnty90 year

gen numdailies_l1=L4.numdailies
gen prestout_l1=L4.prestout
gen changedailies=numdailies-numdailies_l1
gen changeprestout=prestout-prestout_l1
// 一阶差分
reghdfe changeprestout changedailies if mainsample, absorb(i.st#i.year) cluster(cnty90) resid
// 查看残差的自相关
predict resid_fd, residual
reg resid_fd L4.resid_fd
// 固定效应，额外加入各州的异质性趋势
reghdfe prestout numdailies if mainsample, absorb(i.st#i.year i.cnty90) cluster(cnty90)
// 固定效应，额外加入各县的异质性线性趋势
reghdfe prestout numdailies if mainsample, absorb(i.cnty90#c.year i.cnty90) cluster(cnty90)
