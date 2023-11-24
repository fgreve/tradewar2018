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

rename classif sector

drop tariff
rename tariffhs6 tariff
rename vol_p volp

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

drop if sector=="01-05"
drop if sector=="25-27"

levelsof sector, local(CLASE)
foreach c of local CLASE {
*local c "25-27"
display "`c'"

sectorname `c'
display r(name)

local titulo = r(name)
display "`titulo'"

count if sector=="`c'" 
}

*******************************************************************
levelsof sector, local(CLASE)
foreach c of local CLASE {
*local c "25-27"
display "`c'"

sectorname `c'
display r(name)

local titulo = r(name)
display "`titulo'"

preserve
keep if sector=="`c'" 
bysort date tariff: egen mean_volp = mean(volp)

collapse (first) mean_volp, by(date tariff)
rename mean_volp volp

reshape wide volp, i(date) j(tariff)

sort date
tset date
tsfilter hp volp0_hp = volp0, smooth(5)
tsfilter hp volp1_hp = volp1, smooth(5)
gen volp0_smooth = volp0 - volp0_hp
gen volp1_smooth = volp1 - volp1_hp

#delimit ;
twoway line volp0_smooth date, sort || 
line volp1_smooth date, sort lpattern(dash)
legend(label(1 "Control") label(2 "Treated")) 
tline(2018q3)
title("`titulo'", size(huge))
subtitle("sector: `c'", size(large))
ytitle("volp", size(large)) 
; #delimit cr
graph export "${Path}\DOC\paralelplot_volp\paralelplot_`c'.pdf" , as(pdf)  replace
restore
}









