// file: chow_test.do
use datasets/cfps_adult, clear
gen log_income=log(p_income+1)
drop if qq1101<0
drop if te4<0
// 产生变量
gen male=cfps_gender
gen female=1-cfps_gender
tab te4, gen(edu)
local nulls "(male=female)"
local explans "male female"
foreach v of varlist qq1101 edu*{
    gen `v'f=`v'*female
    gen `v'm=`v'*male
    local nulls "`nulls' (`v'f=`v'm)"
    local explans "`explans' `v'f `v'm"
}
// 分组回归
reg log_income qq1101 edu1-edu7 if male==1
reg log_income qq1101 edu1-edu7 if female==1
// 合并回归并检验
reg log_income `explans', noconstant
di "`nulls'"
test `nulls'
