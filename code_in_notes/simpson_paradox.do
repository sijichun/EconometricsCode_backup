// file: simpson_paradox.do
clear
set obs 1000
gen gender=runiform()<0.5
gen     exer=runiform()<0.8 if gender==1
replace exer=runiform()<0.3 if gender==0
gen y=80-10*gender+3*exer+rnormal()
reg y exer
outreg2 using simpson_paradox.tex, replace
reg y exer if gender==1
outreg2 using simpson_paradox.tex, append
reg y exer if gender==0
outreg2 using simpson_paradox.tex, append
reg y exer gender
outreg2 using simpson_paradox.tex, append
