// CivilConflict.do
clear
set more off

use datasets/CivilConflict

// 最简单情况：一个内生变量一个工具变量
// 内生变量：GDP增长率 gdp_g
// 工具变量：降水增长率 GPCP_g
// 第一阶段，first stage
reg gdp_g GPCP_g i.ccode i.ccode#c.year
predict gdp_g_pred
// reduced-form
reg any_prio GPCP_g i.ccode i.ccode#c.year, cl(ccode)
// 错误做法：手动两阶段最小二乘
reg any_prio gdp_g_pred i.ccode i.ccode#c.year,cl(ccode)
// 两阶段最小二乘，三种命令
ivregress 2sls  any_prio (gdp_g = GPCP_g) /*
	*/i.ccode i.ccode#c.year, cl(ccode)
ivreghdfe any_prio (gdp_g = GPCP_g),/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
ivreg2 any_prio (gdp_g = GPCP_g) /*
	*/i.ccode i.ccode#c.year, cl(ccode)

// 两个内生变量，两个工具变量
// 内生变量：GDP增长率 gdp_g、GDP增长率之后gdp_g_l
// 工具变量：降水增长率 GPCP_g、降水增长率滞后 GPCP_g_l
// 第一阶段，first stage
drop gdp_g_pred
reg gdp_g   GPCP_g GPCP_g_l i.ccode i.ccode#c.year
predict gdp_g_pred
reg gdp_g_l GPCP_g GPCP_g_l i.ccode i.ccode#c.year
predict gdp_g_l_pred
// 两阶段最小二乘，三种命令
ivregress 2sls any_prio (gdp_g gdp_g_l = GPCP_g GPCP_g_l ) /*
	*/i.ccode i.ccode#c.year, cl(ccode)
ivreghdfe any_prio (gdp_g gdp_g_l = GPCP_g GPCP_g_l ),/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
ivreg2  any_prio (gdp_g gdp_g_l = GPCP_g GPCP_g_l ) /*
	*/i.ccode i.ccode#c.year, cl(ccode)
// 两阶段最小二乘，多余的(四个)工具变量
ivreghdfe any_prio /*
	*/(gdp_g gdp_g_l =GPCP_g GPCP_g_l NCEP_g NCEP_g_l),/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
** 有限信息极大似然
ivreg2 any_prio (gdp_g gdp_g_l =GPCP_g GPCP_g_l )/*
	*/ i.ccode i.ccode#c.year, cl(ccode) liml
