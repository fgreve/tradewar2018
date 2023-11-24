global Path = "C:\Users\f.grevemunoz\Dropbox\Research\panjivaus_imputevalue_shippingtime_yq"
*******************************************************************
use "${Path}\panjiva.dta", clear
order id gvkey_hs6 gvkey hs6 date, first

drop size
drop tariff
rename vol_p volp
rename dap_ln leadtime
rename tariffhs6 tariff

* size
egen size = cut(saleq_ln), group(10)
tab size

*reg leadtime T after tariffhs6 
*  -.0311572

*reghdfe  leadtime T after tariffhs6, absorb(gvkey) 
*reghdfe  leadtime T after tariffhs6, absorb(gvkey quarter) 
*reghdfe  leadtime T after tariffhs6, absorb(gvkey quarter) 
*reghdfe  leadtime T after tariffhs6, absorb(gvkey quarter period) 
*reghdfe  leadtime T after tariffhs6, absorb(gvkey quarter period size) 

*sort id date
*xtset id date
*count
*gen did = T

*quiet xtreg leadtime T i.date, fe vce(cluster id)
*est table, star(.05 .01 .001) keep(T)
* .00384407
*xtdidregress (leadtime) (T), group(id) time(date)
* .0038441 
*didregress (leadtime) (T), group(id) time(date)
* .0038441 

**************************************************************************
* total
reghdfe  S T after tariff, absorb(gvkey quarter classif period)
eststo est1 
reghdfe  S T after tariff, absorb(gvkey quarter size period) 
eststo est2 

reghdfe  volp T after tariff, absorb(gvkey quarter classif) 
eststo est3 
reghdfe  volp T after tariff, absorb(gvkey quarter size period) 
eststo est4 

reghdfe  leadtime T after tariff, absorb(gvkey quarter classif period)
eststo est5  
reghdfe  leadtime T after tariff, absorb(gvkey quarter size hs2 period) 
eststo est6 

#delimit ;
esttab est1 est2 est3 est4 est5 est6
using "${Path}/DOC/did/did_total.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
stats(N r2,fmt("%9.0fc  %9.3fc"))
r2  b(4) se(2)
nomtitle nonote nolabel 
fragment type nonumbers 
mlabels(,depvars) 
noconstant  
; #delimit cr 


********************************************************************
* SECTORS
*06-15
*64-67
drop if classif=="06-15"
drop if classif=="64-67"
drop if classif==""

tab classif
tab classification

levelsof classif, local(CLASE)
foreach c of local CLASE {
display "`c'"

preserve
keep if classif=="`c'"
est clear

reghdfe  S T after tariff, absorb(gvkey quarter period)
eststo est1 
reghdfe  S T after tariff, absorb(gvkey quarter size period) 
eststo est2 

reghdfe  volp T after tariff, absorb(gvkey quarter period) 
eststo est3 
reghdfe  volp T after tariff, absorb(gvkey quarter size period) 
eststo est4 

reghdfe  leadtime T after tariff, absorb(gvkey quarter period)
eststo est5  
reghdfe  leadtime T after tariff, absorb(gvkey quarter size period) 
eststo est6 

#delimit ;
esttab est1 est2 est3 est4 est5 est6
using "${Path}/DOC/did/did_`c'.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
stats(N r2,fmt("%9.0fc  %9.3fc"))
r2  b(4) se(2)
nomtitle nonote nolabel 
fragment type nonumbers 
mlabels(,depvars) 
noconstant  
; #delimit cr 


restore
}



















