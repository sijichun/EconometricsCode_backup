// file: reg_readings.do
use datasets/cfps_adult, clear
drop if p_income<0
drop if te4<0
drop if qq1101<0
reg p_income qq1101
outreg2 using reg_readings.tex, replace
reg p_income qq1101 i.te4
outreg2 using reg_readings.tex, append keep(qq1101)
reghdfe p_income qq1101, absorb(i.te4 i.provcd14)
outreg2 using reg_readings.tex, append
reghdfe p_income qq1101, absorb(i.te4#i.provcd14)
outreg2 using reg_readings.tex, append
