// file: wald_ols.do
set seed 19880505
cap program drop dgp
program define dgp, rclass
	syntax [, obs(integer 1000) b(real -1.0)]
	drop _all
	set obs `obs'
	tempvar x y u
	tempname vkk V test_stat bk p
	gen `x'=rnormal()
	gen `u'=rnormal()^3
	gen `y'=`b'*`x'+`u'
	reg `y' `x' , robust
	local `bk'=_b[`x']
	mat `V'=e(V)
	local `vkk'=`V'[rownumb(`V',"`x'"),colnumb(`V',"`x'")]
	local `test_stat'=((``bk'')^2-1)^2/(4*(``bk'')^2*``vkk'')
	local `p'=1-chi2(1,``test_stat'')
	if ``p''<0.05{
		return scalar rejected=1
	}
	else{
		return scalar rejected=0
	}
	return scalar teststat=``test_stat''
end
// simulate
simulate rejected=r(rejected) teststat=r(teststat)/*
        */ ,reps(2000):dgp
su
hist teststat
simulate rejected=r(rejected) teststat=r(teststat)/*
        */ ,reps(2000):dgp, b(0)
su
