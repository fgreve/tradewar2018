* Install ftools (remove program if it existed previously)
*cap ado uninstall ftools
*net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

* Install reghdfe 6.x
*cap ado uninstall reghdfe
*net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

* Install parallel, if using the parallel() option; don't install from SSC
*cap ado uninstall parallel
*net install parallel, from(https://raw.github.com/gvegayon/parallel/stable/) replace
*mata mata mlib index

* To run iv/gmm regressions with ivreghdfe, also run these lines:
*cap ado uninstall ivreghdfe
*cap ssc install ivreg2 // Install ivreg2, the core package
*net install ivreghdfe, from(https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/)

********************************************************************************
global Path = "C:\Users\f.grevemunoz\Dropbox\Research\panjivaus_imputevalue_shippingtime_yq"
********************************************************************************
use "${Path}\panjiva.dta", clear
order id gvkey_hs6 gvkey hs6 date, first

sort id date
xtset id date
count

xtreg sales_ln div_T div T i.year, robust

********************************************************************************
*label variable T " $ T $ "
*label variable sales_ln " $ Size $ "
*label variable elastq2 " $ Commodity $ "
*label variable T_elastq2 " $ T \times elastq2 $ "
*label variable elast " $ Elast.Demand $ "
********************************************************************************
qui reghdfe  vol_p T sales_ln, absorb(quarter year hs2 gvkey period)
est table, star(.05 .01 .001) keep(T)
eststo est_1

qui reghdfe  S T sales_ln, absorb(quarter year hs2 gvkey period)
est table, star(.05 .01 .001) keep(T)
eststo est_2

* tariff BAJA el % importacion de China
qui reghdfe  volchina T sales_ln, absorb(quarter year hs2 gvkey period)
est table, star(.05 .01 .001) keep(T)
eststo est_3

* tariff SUBE el % importacion de India
qui reghdfe  volindnam T sales_ln, absorb(quarter year hs2 gvkey period)
est table, star(.05 .01 .001) keep(T)
eststo est_4

* tariff SUBE el % importacion de Mexico
qui reghdfe  volmexda T sales_ln, absorb(quarter year hs2 gvkey period)
est table, star(.05 .01 .001) keep(T)
eststo est_5

#delimit ;
esttab est_1 est_2 est_3 est_4 est_5
using "${Path}/DOC/result1.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
"First Source"
" Number countries"
"China" 
"volindnam "
"volmexda"
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs 
; #delimit cr
***********************************************************************

reghdfe  dap_ln div_T div T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(div_T div T)
eststo est_1

#delimit ;
esttab est_1 
using "${Path}/DOC/result2.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr

********************************************************************
reghdfe  dap_ln divchina_T divchina T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(divchina_T divchina T)
eststo est_1

reghdfe  roa divchina_T divchina T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(divchina_T divchina T)


#delimit ;
esttab est_1  
using "${Path}/DOC/result3.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
"Leadtime"
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs 
wide
; #delimit cr

*********************************************************************
qui reghdfe  vol_p T sales_ln, absorb(quarter year gvkey period)
est table, star(.05 .01 .001) keep(T)

reghdfe  dap_ln div_T div T sales_ln, absorb(quarter)
est table, star(.05 .01 .001) keep(div_T div T)

reghdfe  dap_ln divchina_T divchina T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(divchina_T divchina T)

xtile sales_ln_q = sales_ln, n(4)

reg dap_ln div_T div T sales_ln_q if hs1=="8"
est table, star(.05 .01 .001) keep(div_T div T)

*******************************************************************
reghdfe  dap_ln D30_T D30 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D30_T D30 T)
eststo est_1
#delimit ;
esttab est_1 
using "${Path}/DOC/result9.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr
******************************
reghdfe  dap_ln D40_T D40 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D40_T D40 T)
eststo est_1
#delimit ;
esttab est_1 
using "${Path}/DOC/result8.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr
******************************
reghdfe  dap_ln D50_T D50 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D50_T D50 T)
eststo est_1
#delimit ;
esttab est_1 
using "${Path}/DOC/didD50.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr
******************************
reghdfe  dap_ln D60_T D60 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D60_T D60 T)
eststo est_1
#delimit ;
esttab est_1 
using "${Path}/DOC/didD60.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr
******************************
reghdfe  dap_ln D70_T D70 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D70_T D70 T)
eststo est_1
#delimit ;
esttab est_1 
using "${Path}/DOC/didD70.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr
******************************
reghdfe  dap_ln D80_T D80 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D80_T D80 T)
eststo est_1
#delimit ;
esttab est_1 
using "${Path}/DOC/didD80.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr
******************************
reghdfe  dap_ln D90_T D90 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D90_T D90 T)
eststo est_1
#delimit ;
esttab est_1 
using "${Path}/DOC/didD90.tex", replace 
nogaps collabels(none) 
star(* 0.1 ** 0.05 *** 0.01)  
mtitles(
" Leadtime "
) 
substitute(_ _  $ $ % \%)
label
r2 se(2) b(3)
booktabs
wide 
; #delimit cr

******************************************************************

reghdfe  dap_ln D90_T D90 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D90_T D90 T)

reghdfe  dap_ln D90_T D90 T sales_ln, absorb(quarter hs2 gvkey)
est table, star(.05 .01 .001) keep(D90_T D90 T)

reghdfe  dap_ln D90_T D90 T sales_ln, absorb(quarter hs6 gvkey)
est table, star(.05 .01 .001) keep(D90_T D90 T)



reghdfe  dap_ln D60_T D60 T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(D60_T D60 T)

reghdfe  dap_ln D60_T D60 T sales_ln, absorb(quarter hs2 gvkey)
est table, star(.05 .01 .001) keep(D60_T D60 T)

reghdfe  dap_ln D60_T D60 T sales_ln, absorb(quarter hs6 gvkey)
est table, star(.05 .01 .001) keep(D60_T D60 T)



reghdfe  dap_ln div_T div T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(div_T div T)

reghdfe  dap_ln div_T div T sales_ln, absorb(quarter hs2 gvkey)
est table, star(.05 .01 .001) keep(div_T div T)

reghdfe  dap_ln div_T div T sales_ln, absorb(quarter hs6 gvkey)
est table, star(.05 .01 .001) keep(div_T div T)



reghdfe  dap_ln divchina_T divchina T sales_ln, absorb(quarter hs2)
est table, star(.05 .01 .001) keep(divchina_T divchina T)

reghdfe  dap_ln divchina_T divchina T sales_ln, absorb(quarter hs2 gvkey)
est table, star(.05 .01 .001) keep(divchina_T divchina T)

reghdfe  dap_ln divchina_T divchina T sales_ln, absorb(quarter hs6 gvkey)
est table, star(.05 .01 .001) keep(divchina_T divchina T)


















