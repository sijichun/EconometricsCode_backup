clear
set more off

use datasets/CivilConflict
** controls
local  control "polity2l Oil lpopl1"

** first stage
* 工具变量：降水增长率、滞后的降水增长率
reghdfe gdp_g GPCP_g GPCP_g_l , absorb(i.ccode i.ccode#c.year) cl(ccode)
* reduced-form
reghdfe any_prio GPCP_g GPCP_g_l , absorb(i.ccode i.ccode#c.year) cl(ccode)
* 2SLS
reghdfe any_prio (gdp_g gdp_g_l =GPCP_g GPCP_g_l ), absorb(i.ccode i.ccode#c.year) cl(ccode)
* ivreg2  any_prio (gdp_g gdp_g_l =GPCP_g GPCP_g_l ) i.ccode i.ccode#c.year, cl(ccode)
* 2SLS
reghdfe any_prio (gdp_g gdp_g_l =GPCP_g GPCP_g_l NCEP_g NCEP_g_l), absorb(i.ccode i.ccode#c.year) cl(ccode)
** 有限信息极大似然
 ivreg2  any_prio (gdp_g gdp_g_l =GPCP_g GPCP_g_l ) i.ccode i.ccode#c.year, cl(ccode) liml
