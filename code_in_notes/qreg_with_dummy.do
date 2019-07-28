// file: qreg_with_dummy.do
use datasets/cfps_adult, clear
keep cfps_gender p_income
drop if p_income<0
bysort cfps_gender: su p_income, de
qreg p_income cfps_gender, q(0.5)
qreg p_income cfps_gender, q(0.75)
qreg p_income cfps_gender, q(0.9)
