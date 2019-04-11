// file: multi_colinear.do
set seed 19880505
cap program drop dgp
program define dgp, rclass
	syntax [, obs(integer 20) b(real 0) mc(real 1)]
	drop _all
	set obs `obs'
	tempvar x1 x2 y sigma
	gen `x1'=rnormal()
	if `mc'==1{
		gen `x2'=3/sqrt(10)*`x1'+1/sqrt(10)*rnormal()
	}
	else {
		gen `x2'=rnormal()
	}
	gen `y'=`b'*`x1'+`x2'+rnormal()
	quietly: reg `y' `x1' `x2'
	return scalar b=_b[`x1']
	return scalar se=_se[`x1']
	if abs(_b[`x1']/_se[`x1'])>=invt(`obs'-3,0.975) {
		return scalar rejected=1
	}
	else {
		return scalar rejected=0
	}
end
** multicolinearty, size
simulate rejected=r(rejected) b=r(b) se=r(se)/*
					*/ ,reps(2000):dgp
su
** multicolinearty, power
simulate rejected=r(rejected) b=r(b) se=r(se)/*
					*/ ,reps(2000):dgp, b(1)
su
** no multicolinearty, power
simulate rejected=r(rejected) b=r(b) se=r(se)/*
					*/ ,reps(2000):dgp, b(1) mc(0)
su
** multicolinearty, power with large N
simulate rejected=r(rejected) b=r(b) se=r(se)/*
					*/ ,reps(2000):dgp, b(1) obs(100)
su
