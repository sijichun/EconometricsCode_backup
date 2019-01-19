clear
set more off
cd  "/Users/aragorn/Working/Econometrics/EconometricsCode/code_in_notes/"
use "datasets/Divorce-Wolfers-AER.dta"
** state dummies
egen state=group(st)
** panel setting
xtset state year
gen year2=year^2
** benchmark
reghdfe div_rate unilateral divx* if year>1967 & year<1989 [w=stpop], absorb(i.state i.year) cl(state)
** state-specific trend
reghdfe div_rate unilateral divx* if year>1967 & year<1989 [w=stpop], absorb(i.state i.year i.state#c.year) cl(state)
reghdfe div_rate unilateral divx* if year>1967 & year<1989 [w=stpop], absorb(i.state i.year i.state#c.year i.state#c.year2) cl(state)

** common trend

gen delta_year=lfdivlaw-year

gen L12unilateral = delta_year>=12
gen L11unilateral = delta_year==11
gen L10unilateral = delta_year==10
gen L9unilateral = delta_year==9
gen L8unilateral = delta_year==8
gen L7unilateral = delta_year==7
gen L6unilateral = delta_year==6
gen L5unilateral = delta_year==5
gen L4unilateral = delta_year==4
gen L3unilateral = delta_year==3
gen L2unilateral = delta_year==2
gen unilateral0  = delta_year==0
gen F1unilateral = delta_year==-1
gen F2unilateral = delta_year==-2
gen F3unilateral = delta_year==-3
gen F4unilateral = delta_year==-4
gen F5unilateral = delta_year==-5
gen F6unilateral = delta_year==-6
gen F7unilateral = delta_year==-7
gen F8unilateral = delta_year==-8
gen F9unilateral = delta_year==-9
gen F10unilateral = delta_year==-10
gen F11unilateral = delta_year==-11
gen F12unilateral= delta_year==-12
gen F13unilateral = delta_year==-13
gen F14unilateral= delta_year==-14
gen F15unilateral = delta_year==-15
gen F16unilateral = delta_year==-16
gen F17unilateral = delta_year==-17
gen F18unilateral = delta_year==-18
gen F19unilateral= delta_year==-19
gen F20unilateral = delta_year<=-20
reghdfe div_rate L12unilateral - F20unilateral divx* if year>1967 & year<1989 [w=stpop], absorb(i.state i.year)
coefplot, keep(*unilateral*) vert xline(12)
** dynamic effects
reghdfe div_rate unilateral0 - F20unilateral divx* if year>1967 & year<1989 [w=stpop], absorb(i.state i.year) cl(state)
