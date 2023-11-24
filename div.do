global Path = "C:\Users\f.grevemunoz\Dropbox\Research\panjivaus_imputevalue_shippingtime_yq"
*******************************************************************
use "${Path}\panjiva.dta", clear
order id gvkey_hs6 gvkey hs6 date, first

sort id date
xtset id date
count

drop size
rename vol_p volp
rename saleq_ln size

*******************************************************************
* total
reghdfe  volp T size, absorb(gvkey quarter period classif) noconstant
eststo est_1
reghdfe  volp T size period, absorb(gvkey quarter classif) noconstant
eststo est_2

reghdfe  S T size, absorb(gvkey quarter period classif) noconstant
eststo est_3
reghdfe  S T size period, absorb(gvkey quarter classif) noconstant
eststo est_4

reghdfe  volchina T size, absorb(gvkey quarter year period classif) noconstant
eststo est_5
reghdfe  volchina T size period, absorb(gvkey quarter classif) noconstant
eststo est_6

reghdfe  volindnam T size, absorb(gvkey quarter year period classif) noconstant
eststo est_7
reghdfe  volindnam T size period, absorb(gvkey quarter classif) noconstant
eststo est_8

#delimit ;
esttab est_1 est_2 est_3 est_4 est_5 est_6 est_7 est_8
using "${Path}/DOC/div/div_total.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
stats(r2 N,fmt("%9.3fc  %9.0fc"))
r2  b(2) se(2)
nomtitle nonote nolabel 
fragment type nonumbers 
mlabels(,depvars) 
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


reghdfe  volp T size, absorb(gvkey quarter period) noconstant
eststo est_1
reghdfe  volp T size period, absorb(gvkey quarter) noconstant
eststo est_2

reghdfe  S T size, absorb(gvkey quarter period) noconstant
eststo est_3
reghdfe  S T size period, absorb(gvkey quarter) noconstant
eststo est_4

reghdfe  volchina T size, absorb(gvkey quarter year period) noconstant
eststo est_5
reghdfe  volchina T size period, absorb(gvkey quarter) noconstant
eststo est_6

reghdfe  volindnam T size, absorb(gvkey quarter year period) noconstant
eststo est_7
reghdfe  volindnam T size period, absorb(gvkey quarter) noconstant
eststo est_8

#delimit ;
esttab est_1 est_2 est_3 est_4 est_5 est_6 est_7 est_8
using "${Path}/DOC/div/div_`c'.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
stats(r2 N,fmt("%9.3fc  %9.0fc"))
r2  b(2) se(2)
nomtitle nonote nolabel 
fragment type nonumbers 
mlabels(,depvars) 
; #delimit cr

restore
}









