// file: reg_readings.do
use datasets/cfps_adult, clear
gen log_income=log(p_income+1)
drop if te4<0
drop if qq1101<0
reg log_income qq1101
outreg2 using reg_readings.tex, replace /*
*/ addt(学历固定效应, "No", 省份固定效应, "No",/*
*/ 学历×省份固定效应, "No")
reg log_income qq1101 i.te4
outreg2 using reg_readings.tex, append keep(qq1101) /*
*/ addt(学历固定效应, "Yes", 省份固定效应, "No",/*
*/ 学历×省份固定效应, "No")
reghdfe log_income qq1101, absorb(i.te4 i.provcd14)
outreg2 using reg_readings.tex, append /*
*/ addt(学历固定效应, "Yes", 省份固定效应, "Yes",/*
*/ 学历×省份固定效应, "No")
reghdfe log_income qq1101, absorb(i.te4#i.provcd14)
outreg2 using reg_readings.tex, append /*
*/ addt(学历固定效应, "No", 省份固定效应, "No",/*
*/ 学历×省份固定效应, "Yes")
