// file: heteroscedasticity.do
set seed 19880505
cap program drop dgp
program define dgp, rclass
	syntax [, obs(integer 100) b(real 1) hetero(real 0)]
	drop _all
	set obs `obs'
	tempvar x y sigma
	gen `x'=rnormal()
	gen `sigma'=1+`hetero'*abs(`x')
	gen `y'=3+`b'*`x'+rnormal(0,`sigma')
	quietly: reg `y' `x'
	return scalar b=_b[`x']
	return scalar se=_se[`x']
	quietly: reg `y' `x', robust
	return scalar r_b=_b[`x']
	return scalar r_se=_se[`x']
end
// multicolinearty, size
simulate b=r(b) se=r(se) rb=r(r_b) rse=r(r_se),/*
	*/ reps(2000): dgp
su
simulate b=r(b) se=r(se) rb=r(r_b) rse=r(r_se),/*
	*/ reps(2000): dgp, hetero(1)
su
