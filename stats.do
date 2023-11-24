************************************************************************
global Path = "C:\Users\f.grevemunoz\Dropbox\Research\panjivaus_imputevalue_shippingtime_yq"
********************************************************************
use "${Path}\panjiva.dta", clear
order id gvkey_hs6 gvkey hs6 date, first

tab classif 
tab classification

levelsof classif

*dap 
*mkvaltq
*saleq 
*roa
*roe 
*roi 
*salegr

label variable dap_ln 		" $ \log(dap) $ "
label variable mkvaltq_ln 	" $ \log(mkvaltq) $ "
label variable saleq_ln 	" $ \log(saleq) $ "
label variable roa 			" $ ROA $ "
label variable roe 			" $ ROE $ "

**********
* ROA
tabstat roa , c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p1roa = b[2,1]
global p99roa = b[10,1]
tabstat roa if roa>=$p1roa & roa<=$p99roa, c(stat) stat(mean sd q n)
***********
* ROE
tabstat roe , c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p1roe = b[2,1]
global p99roe = b[10,1]
tabstat roe if roe>=$p1roe & roe<=$p99roe, c(stat) stat(mean sd q n)
************
*#delimit ;
*estpost
*tabstat
*dap_ln mkvaltq_ln saleq_ln roa roe  
*if roa>=$p1roa & roa<=$p99roa
*&  roe>=$p1roe & roa<=$p99roe
*, c(stat) stat(mean sd q n)
*; #delimit cr
********************************************************************
* TOTAL
est clear
**********
* ROA
tabstat roa , c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p1roa = b[2,1]
global p99roa = b[10,1]
tabstat roa if roa>=$p1roa & roa<=$p99roa, c(stat) stat(mean sd q n)
***********
* ROE
tabstat roe , c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p1roe = b[2,1]
global p99roe = b[10,1]
tabstat roe if roe>=$p1roe & roe<=$p99roe, c(stat) stat(mean sd q n)
************
#delimit ;
estpost
tabstat
dap_ln mkvaltq_ln saleq_ln roa roe
if roa>=$p1roa & roa<=$p99roa
&  roe>=$p1roe & roa<=$p99roe 
, c(stat) stat(mean sd q n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/stats/stats_total.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
p25(fmt(%9.2fc)) 
p50(fmt(%9.2fc)) 
p75(fmt(%9.2fc)) 
count(fmt(%9.0fc))")
nomtitle nonote noobs label 
substitute(_ _  $ $ % \%)
plain fragment type 
mlabels(none) collabels(none)
; #delimit cr
*compress

est clear
#delimit ;
estpost
tabstat
dap_ln mkvaltq_ln saleq_ln roa roe
if after==0
&  roa>=$p1roa & roa<=$p99roa
&  roe>=$p1roe & roa<=$p99roe 
, c(stat) stat(mean sd q n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/stats/stats_total_t0.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
p25(fmt(%9.2fc)) 
p50(fmt(%9.2fc)) 
p75(fmt(%9.2fc)) 
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
dap_ln mkvaltq_ln saleq_ln roa roe
if after==1
&  roa>=$p1roa & roa<=$p99roa
&  roe>=$p1roe & roa<=$p99roe 
, c(stat) stat(mean sd q n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/stats/stats_total_t1.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
p25(fmt(%9.2fc)) 
p50(fmt(%9.2fc)) 
p75(fmt(%9.2fc)) 
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

tab classif
tab classification

levelsof classif, local(CLASE)
foreach c of local CLASE {
display "`c'"
est clear
**********
* ROA
tabstat roa if classif=="`c'", c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p1roa = b[2,1]
global p99roa = b[10,1]
tabstat roa if roa>=$p1roa & roa<=$p99roa, c(stat) stat(mean sd q n)
***********
* ROE
tabstat roe if classif=="`c'", c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p1roe = b[2,1]
global p99roe = b[10,1]
tabstat roe if roe>=$p1roe & roe<=$p99roe, c(stat) stat(mean sd q n)
************
#delimit ;
estpost
tabstat
dap_ln mkvaltq_ln saleq_ln roa roe
if classif=="`c'"
&  roa>=$p1roa & roa<=$p99roa
&  roe>=$p1roe & roa<=$p99roe 
, c(stat) stat(mean sd q n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/stats/stats_`c'.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
p25(fmt(%9.2fc)) 
p50(fmt(%9.2fc)) 
p75(fmt(%9.2fc)) 
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
dap_ln mkvaltq_ln saleq_ln roa roe
if classif=="`c'" & after==0
&  roa>=$p1roa & roa<=$p99roa
&  roe>=$p1roe & roa<=$p99roe 
, c(stat) stat(mean sd q n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/stats/stats_`c'_t0.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
p25(fmt(%9.2fc)) 
p50(fmt(%9.2fc)) 
p75(fmt(%9.2fc)) 
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
dap_ln mkvaltq_ln saleq_ln roa roe
if classif=="`c'" & after==1
&  roa>=$p1roa & roa<=$p99roa
&  roe>=$p1roe & roa<=$p99roe 
, c(stat) stat(mean sd q n)
; #delimit cr
#delimit ;
esttab
using "${Path}/DOC/stats/stats_`c'_t1.tex", replace  
cells(
"mean(fmt(%9.2fc)) 
sd(fmt(%9.2fc)) 
p25(fmt(%9.2fc)) 
p50(fmt(%9.2fc)) 
p75(fmt(%9.2fc)) 
count(fmt(%9.0fc))") 
nomtitle nonote noobs label 
substitute(_ _  $ $ % \%)
plain fragment type
mlabels(none) collabels(none)
; #delimit cr
}

	
	
	
	
	

