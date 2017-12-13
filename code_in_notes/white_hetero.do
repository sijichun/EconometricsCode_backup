// file: white_hetero.do
cap program drop dgp
program define dgp, rclass
	syntax [, obs(integer 100) robust b(real 0)]
	drop _all
	set obs `obs'
	tempvar x y sigma
	gen `x'=rnormal()
	gen `sigma'=sqrt(`x'^2)
	gen `y'=`b'*`x'+`sigma'*rnormal()
	quietly: reg `y' `x', `robust'
	return scalar b=_b[`x']
	return scalar se=_se[`x']
	if abs(_b[`x']/_se[`x'])>=1.96 {
		return scalar rejected=1
	}
	else {
		return scalar rejected=0
	}
end

simulate rejected=r(rejected) b=r(b) se=r(se)/*
							*/ ,reps(1000):dgp
su
simulate rejected=r(rejected) b=r(b) se=r(se)/*
						*/,reps(1000):dgp, robust
su
