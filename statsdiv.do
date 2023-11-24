************************************************************************
global Path = "C:\Users\f.grevemunoz\Dropbox\Research\panjivaus_imputevalue_shippingtime_yq"
********************************************************************
use "${Path}\panjiva.dta", clear
order id gvkey_hs6 gvkey hs6 date, first

tab classif 
tab classification

levelsof classif

*vol S vol_p volchina volindnam volmexda


label variable vol " $ VOL TEU $ "
label variable vol_p " $ volp $ "
label variable volchina " $ volchina $ "
label variable volindnam  " $ volindnam $ "
label variable volmexda  " $ volmexda $ "
label variable S " $ S $ "

**********
* vol_p
tabstat vol_p , c(stat) stat(mean sd p10 p25 p50 p75 p90 n)

********************************************************************
* TOTAL
est clear
#delimit ;
estpost
tabstat
vol_p S volchina volindnam volmexda
, c(stat) stat(mean sd min p10 p25 p50 p75 p90 max n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/statsdiv/statsdiv_total.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
min(fmt(%9.0fc))
p10(fmt(%9.0fc))
p25(fmt(%9.0fc))
p50(fmt(%9.0fc)) 
p75(fmt(%9.0fc)) 
p90(fmt(%9.0fc))
max(fmt(%9.0fc))
count(fmt(%9.0fc))")
nomtitle nonote noobs label 
substitute(_ _  $ $ % \%)
plain fragment type 
mlabels(none) collabels(none)
; #delimit cr

est clear
#delimit ;
estpost
tabstat
vol_p S volchina volindnam volmexda
if after==0
, c(stat) stat(mean sd min p10 p25 p50 p75 p90 max n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/statsdiv/statsdiv_total_t0.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
min(fmt(%9.0fc))
p10(fmt(%9.0fc))
p25(fmt(%9.0fc))
p50(fmt(%9.0fc)) 
p75(fmt(%9.0fc)) 
p90(fmt(%9.0fc))
max(fmt(%9.0fc))
count(fmt(%9.0fc))")
nomtitle nonote noobs label 
substitute(_ _  $ $ % \%)
plain fragment type 
mlabels(none) collabels(none)
; #delimit cr

est clear
#delimit ;
estpost
tabstat
vol_p S volchina volindnam volmexda
if after==1
, c(stat) stat(mean sd min p10 p25 p50 p75 p90 max n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/statsdiv/statsdiv_total_t1.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
min(fmt(%9.0fc))
p10(fmt(%9.0fc))
p25(fmt(%9.0fc))
p50(fmt(%9.0fc)) 
p75(fmt(%9.0fc)) 
p90(fmt(%9.0fc))
max(fmt(%9.0fc))
count(fmt(%9.0fc))")
nomtitle nonote noobs label 
substitute(_ _  $ $ % \%)
plain fragment type 
mlabels(none) collabels(none)
; #delimit cr

********************************************************************
* SECTORS

*06-15
*64-67
drop if classif=="06-15"
drop if classif=="64-67"
drop if classif==""

levelsof classif, local(CLASE)
foreach c of local CLASE {
display "`c'"
est clear
#delimit ;
estpost
tabstat
vol_p S volchina volindnam volmexda
if classif=="`c'"
, c(stat) stat(mean sd min p10 p25 p50 p75 p90 max n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/statsdiv/statsdiv_`c'.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
min(fmt(%9.0fc))
p10(fmt(%9.0fc))
p25(fmt(%9.0fc))
p50(fmt(%9.0fc)) 
p75(fmt(%9.0fc)) 
p90(fmt(%9.0fc))
max(fmt(%9.0fc))
count(fmt(%9.0fc))")
nomtitle nonote noobs label 
substitute(_ _  $ $ % \%)
plain fragment type 
mlabels(none) collabels(none)
; #delimit cr
}

levelsof classif, local(CLASE)
foreach c of local CLASE {
display "`c'"
est clear
#delimit ;
estpost
tabstat
vol_p S volchina volindnam volmexda
if classif=="`c'" & after==0
, c(stat) stat(mean sd min p10 p25 p50 p75 p90 max n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/statsdiv/statsdiv_`c'_t0.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
min(fmt(%9.0fc))
p10(fmt(%9.0fc))
p25(fmt(%9.0fc))
p50(fmt(%9.0fc)) 
p75(fmt(%9.0fc)) 
p90(fmt(%9.0fc))
max(fmt(%9.0fc))
count(fmt(%9.0fc))")
nomtitle nonote noobs label 
substitute(_ _  $ $ % \%)
plain fragment type 
mlabels(none) collabels(none)
; #delimit cr
}

levelsof classif, local(CLASE)
foreach c of local CLASE {
display "`c'"
est clear
#delimit ;
estpost
tabstat
vol_p S volchina volindnam volmexda
if classif=="`c'" & after==1
, c(stat) stat(mean sd min p10 p25 p50 p75 p90 max n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/statsdiv/statsdiv_`c'_t1.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
min(fmt(%9.0fc))
p10(fmt(%9.0fc))
p25(fmt(%9.0fc))
p50(fmt(%9.0fc)) 
p75(fmt(%9.0fc)) 
p90(fmt(%9.0fc))
max(fmt(%9.0fc))
count(fmt(%9.0fc))")
nomtitle nonote noobs label
substitute(_ _  $ $ % \%) 
plain fragment type 
mlabels(none) collabels(none)
; #delimit cr
}

	
	
	
	
	

