clear
set more off
set matsize 10000
use datasets/DDCGdata_final
// 国家代码
egen ccode=group(wbcode)
// 设置面板结构
xtset ccode year
// 固定效应回归
xtreg y l.y dem i.year, fe cluster(ccode)
xtreg y l(1/2).y dem i.year, fe cluster(wbcode2)
xtreg y l(1/4).y dem i.year, fe cluster(wbcode2)
// 动态面板，差分GMM
xtabond2 y l.y dem i.year,/*
	*/gmmstyle(y, laglimits(2 .)) gmmstyle(dem, laglimits(1 .)) ivstyle(i.year, p)/*
	*/ noleveleq robust nodiffsargan
xtabond2 y l(1/2).y dem i.year,/*
	*/gmmstyle(y, laglimits(2 .)) gmmstyle(dem, laglimits(1 .)) ivstyle(i.year, p)/*
	*/ noleveleq robust nodiffsargan
xtabond2 y l(1/4).y dem i.year,/*
	*/gmmstyle(y, laglimits(2 .)) gmmstyle(dem, laglimits(1 .)) ivstyle(i.year, p)/*
	*/ noleveleq robust nodiffsargan
// 动态面板，系统GMM
xtabond2 y l.y dem i.year,/*
	*/gmmstyle(y, laglimits(2 4)) gmmstyle(dem, laglimits(1 3)) ivstyle(i.year)/*
	*/ robust nodiffsargan
xtabond2 y l(1/2).y dem i.year,/*
	*/gmmstyle(y, laglimits(2 4)) gmmstyle(dem, laglimits(1 3)) ivstyle(i.year)/*
	*/ robust nodiffsargan
xtabond2 y l(1/4).y dem i.year,/*
	*/gmmstyle(y, laglimits(2 4)) gmmstyle(dem, laglimits(1 3)) ivstyle(i.year)/*
	*/ robust nodiffsargan
