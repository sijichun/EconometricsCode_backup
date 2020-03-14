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

//使用外部命令chowreg
ssc install chowreg,replace

//先删除缺失值
foreach v of varlist log_income qq1101 edu*{
	drop if `v' == .
}
//再看看男女有多少人
sort male
tab male

chowreg log_income qq1101 edu1-edu7 ,dum(315) type(3)
//可以得到手动计算相同的结果，比较麻烦的就是需要看看两个组到底有多少人
