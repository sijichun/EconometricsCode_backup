clear
set more off
use datasets/disease_gender_gap
*****
** 变量说明
* year：调查的轮数
* district：区
* edu_years：教育年限
* year_birth：出生年龄，1960-1992  **注，流行性脑膜炎发生在1986
** 作者选取的cohort: 在1986年时0-5岁（不上学），6-12岁（小学），13-20岁（中学）
** 相应的年龄为1981-1986、1974-1980、1966-1973
gen cohort1=(year_birth>=1981 & year_birth<=1986)
gen cohort2=(year_birth>=1974 & year_birth<=1980)
gen cohort3=(year_birth>=1966 & year_birth<=1973)
** 交叉项
gen co1menin=cohort1*menin_avg
gen co2menin=cohort2*menin_avg
gen co3menin=cohort3*menin_avg

gen co1menin_female=cohort1*female*menin_avg
gen co2menin_female=cohort2*female*menin_avg
gen co3menin_female=cohort3*female*menin_avg
** district 为字符串，需要变成数字才能用i.district
gen n=_n
egen district_id=min(n), by(district)
** 第一个回归，才是实质上的DID，传统的时间其实是cohort，group变量是menin，三个cohort都是处理组，有两个未处理组
reghdfe edu_years co1menin co2menin co3menin female `control', absorb(i.year i.year_birth i.district_id) cl(district_id)
** 第二个回归，其实是比较了不同性别的treatment effects
reghdfe edu_years co1menin_female co2menin_female co3menin_female co1menin co2menin co3menin female `control', absorb(i.year i.year_birth i.district_id)  cl(district_id)
******问题：
** 为什么不控制个体的固定效应？i.indvidual_id？

** 如果不看1986以后出生的？依然是稳健的
preserve
reghdfe edu_years co1menin co2menin co3menin female `control', absorb(i.year i.year_birth i.district_id) cl(district_id)
reghdfe edu_years co1menin_female co2menin_female co3menin_female co1menin co2menin co3menin female `control', absorb(i.year i.year_birth i.district_id)  cl(district_id)
drop if year_birth>1986
restore

** 如果考虑截面相关，比如同一年龄段的peer effects，该cluster什么？
reghdfe edu_years co1menin co2menin co3menin female `control', absorb(i.year i.year_birth i.district_id) cl(district_id year_birth)
reghdfe edu_years co1menin_female co2menin_female co3menin_female co1menin co2menin co3menin female `control', absorb(i.year i.year_birth i.district_id)  cl(district_id year_birth)

** 如果继续严格控制固定效应
reghdfe edu_years co1menin co2menin co3menin female `control', absorb(i.year i.year_birth#i.district_id) cl(district_id year_birth)
reghdfe edu_years co1menin_female co2menin_female co3menin_female co1menin co2menin co3menin female `control', absorb(i.year i.year_birth#i.district_id)  cl(district_id year_birth)
* 问题：第一个回归方程能估计出来吗？
* 问题：第二个回归方程识别出来的是什么？
