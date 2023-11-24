global Path = "C:\Users\f.grevemunoz\Dropbox\Research\panjivaus_imputevalue_shippingtime_yq"
*******************************************************************
use "${Path}\panjiva.dta", clear
order id gvkey_hs6 gvkey hs6 date, first

* SECTORS
*06-15
*64-67
drop if classif=="06-15"
drop if classif=="64-67"
drop if classif==""

rename dap_ln leadtime
rename classif sector

drop tariff
rename tariffhs6 tariff

gen when = cond(after==0, "Before", "After")


*******************************************************************
program drop sectorname
program sectorname, rclass
if "01-05"=="`1'"   return local name "Animal and Animal Products"
if "16-24"=="`1'"	return local name "Foodstuffs"
if "25-27"=="`1'"	return local name "Mineral Products"
if "28-38"=="`1'"	return local name "Chemicals and Allied Industries"
if "39-40"=="`1'"	return local name "Plastics and Rubbers"
if "41-43"=="`1'"	return local name "Raw Hides, Skins, Leather, and Furs"
if "44-49"=="`1'"	return local name "Wood and Wood Products"
if "50-63"=="`1'"	return local name "Textiles"
if "68-71"=="`1'"	return local name "Stone and Glass"
if "72-83"=="`1'"	return local name "Metals"
if "84-85"=="`1'"	return local name "Machinery and Electrical"
if "86-89"=="`1'"	return local name "Transportation"
if "90-97"=="`1'"	return local name "Miscellaneous"
end
*******************************************************************
local c "28-38"
display "`c'"

sectorname `c'
return list

display r(name)

local titulo = r(name)
display "`titulo'"

tabstat leadtime if sector=="`c'", c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p5 = b[2,1]
global p95 = b[10,1]
tabstat leadtime if leadtime>=$p5 & leadtime<=$p95, c(stat) stat(mean sd q n)
tabstat leadtime, c(stat) stat(mean sd q n)

preserve
keep if sector=="`c'" & leadtime>=$p5 & leadtime<=$p95
bysort date tariff: egen mean_leadtime = mean(leadtime)

collapse (first) mean_leadtime, by(date tariff)
rename mean_leadtime leadtime

reshape wide leadtime, i(date) j(tariff)

sort date
tset date
tsfilter hp leadtime0_hp = leadtime0, smooth(5)
tsfilter hp leadtime1_hp = leadtime1, smooth(5)
gen leadtime0_smooth = leadtime0 - leadtime0_hp
gen leadtime1_smooth = leadtime1 - leadtime1_hp

#delimit ;
twoway line leadtime0_smooth date, sort || 
line leadtime1_smooth date, sort lpattern(dash)
legend(label(1 "Control") label(2 "Treated")) 
tline(2018q3)
title("`titulo'", size(huge))
subtitle("sector: `c'", size(large))
ytitle("Leadtime", size(large)) 
; #delimit cr
graph export "${Path}\DOC\paralelplot\paralelplot_`c'.pdf" , as(pdf)  replace
restore

*******************************************************************
levelsof sector, local(CLASE)
foreach c of local CLASE {
display "`c'"

sectorname `c'
display r(name)

local titulo = r(name)
display "`titulo'"

tabstat leadtime if sector=="`c'", c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
matrix b = r(StatTotal)
global p5 = b[2,1]
global p95 = b[10,1]
tabstat leadtime if leadtime>=$p5 & leadtime<=$p95, c(stat) stat(mean sd q n)
tabstat leadtime, c(stat) stat(mean sd q n)

preserve
keep if sector=="`c'"
*keep if leadtime>=$p5 & leadtime<=$p95
*bysort date tariff: egen mean_leadtime = mean(leadtime)
bysort date tariff: egen mean_leadtime = median(leadtime)

collapse (first) mean_leadtime, by(date tariff)
rename mean_leadtime leadtime

reshape wide leadtime, i(date) j(tariff)

sort date
tset date
tsfilter hp leadtime0_hp = leadtime0, smooth(5)
tsfilter hp leadtime1_hp = leadtime1, smooth(5)
gen leadtime0_smooth = leadtime0 - leadtime0_hp
gen leadtime1_smooth = leadtime1 - leadtime1_hp

#delimit ;
twoway line leadtime0_smooth date, sort || 
line leadtime1_smooth date, sort lpattern(dash)
legend(label(1 "Control") label(2 "Treated")) 
tline(2018q3)
title("`titulo'", size(huge))
subtitle("sector: `c'", size(large))
ytitle("Leadtime", size(large)) 
; #delimit cr
graph export "${Path}\DOC\paralelplot\paralelplot_`c'.pdf" , as(pdf)  replace
restore
}
*******************************************************************
levelsof hs2, local(CLASE)
	foreach c of local CLASE {
	display "`c'"
	count if hs2=="`c'"
}
*******************************************************************
*gen hs2_n = real(hs2)
preserve
collapse (mean) leadtime, by(tariff hs2)
reshape wide leadtime, i(hs2) j(tariff)
drop if leadtime0==.
drop if leadtime1==.
levelsof hs2, local(HS2)
restore

levelsof hs2, local(HS2)
foreach c of local CLASE {
	*count if hs2=="`c'"
	
	preserve
	quiet keep if hs2=="`c'"
	quiet bysort date tariff: egen mean_leadtime = mean(leadtime)	
	quiet collapse (first) mean_leadtime, by(date tariff)
	rename mean_leadtime leadtime
	quiet reshape wide leadtime, i(date) j(tariff)
	display "`c'"
	ipolate leadtime0 date, generate(leadtime0i)
	ipolate leadtime1 date, generate(leadtime1i)
	count
	restore	
}
*******************************************************************
* hs2
levelsof hs2, local(CLASE)
foreach c of local CLASE {
display "`c'"

*sectorname `c'
*display r(name)

*local titulo = r(name)
*display "`titulo'"

*tabstat leadtime if sector=="`c'", c(stat) stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max) save
*matrix b = r(StatTotal)
*global p5 = b[2,1]
*global p95 = b[10,1]
*tabstat leadtime if leadtime>=$p5 & leadtime<=$p95, c(stat) stat(mean sd q n)
*tabstat leadtime, c(stat) stat(mean sd q n)

preserve
keep if hs2=="`c'"
*keep if leadtime>=$p5 & leadtime<=$p95
bysort date tariff: egen mean_leadtime = mean(leadtime)
*bysort date tariff: egen mean_leadtime = median(leadtime)

collapse (first) mean_leadtime, by(date tariff)
rename mean_leadtime leadtime
reshape wide leadtime, i(date) j(tariff)

sort date
tset date
tsfilter hp leadtime0_hp = leadtime0, smooth(5)
tsfilter hp leadtime1_hp = leadtime1, smooth(5)
gen leadtime0_smooth = leadtime0 - leadtime0_hp
gen leadtime1_smooth = leadtime1 - leadtime1_hp

#delimit ;
twoway line leadtime0_smooth date, sort || 
line leadtime1_smooth date, sort lpattern(dash)
legend(label(1 "Control") label(2 "Treated")) 
tline(2018q3)
title("hs2: `c'", size(large))
ytitle("Leadtime", size(large)) 
; #delimit cr
graph export "${Path}\DOC\paralelplot\hs2\paralelplot_`c'.pdf" , as(pdf)  replace
restore
}






