// file: cross_validation_reg.do
clear
set obs 50
gen x=runiform()*3
gen y=exp(x)+rnormal()*2
local control ""
scalar K=0
forvalues i=1/10{
  gen x`i'=x^`i'
  local control "`control' x`i'"
  local N= _N
  quietly{
    gen error=.
    forvalues j=1/`N'{
      reg y `control' if _n~=`j'
      predict resid, residual
      replace error=resid if _n==`j'
      drop resid
    }
  }
  gen error2=error^2
  quietly: su error2
  scalar mse=r(mean)
  display `i' _skip mse
  drop error error2
}
