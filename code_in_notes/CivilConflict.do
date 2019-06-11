// CivilConflict.do
clear
set more off

use datasets/CivilConflict

//** 工具变量：降水增长率、滞后的降水增长率
//** 第一阶段，first stage
reghdfe gdp_g GPCP_g GPCP_g_l ,/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
predict gdp_g_pred
reghdfe gdp_g_l GPCP_g GPCP_g_l ,/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
predict gdp_g_l_pred
// reduced-form
reghdfe any_prio GPCP_g GPCP_g_l ,/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
// 错误做法：手动两阶段最小二乘
reghdfe any_prio gdp_g_pred gdp_g_l_pred,/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
// 两阶段最小二乘，三种命令
ivregress 2sls  any_prio /*
	*/(gdp_g gdp_g_l =GPCP_g GPCP_g_l ) /*
	*/i.ccode i.ccode#c.year, cl(ccode)
reghdfe any_prio /*
	*/(gdp_g gdp_g_l =GPCP_g GPCP_g_l ),/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
ivreg2  any_prio /*
	*/(gdp_g gdp_g_l =GPCP_g GPCP_g_l ) /*
	*/i.ccode i.ccode#c.year, cl(ccode)
// 两阶段最小二乘，多余的工具变量
reghdfe any_prio /*
	*/(gdp_g gdp_g_l =GPCP_g GPCP_g_l NCEP_g NCEP_g_l),/*
	*/ absorb(i.ccode i.ccode#c.year) cl(ccode)
** 有限信息极大似然
ivreg2 any_prio /*
	*/(gdp_g gdp_g_l =GPCP_g GPCP_g_l )/*
	*/ i.ccode i.ccode#c.year, cl(ccode) liml
