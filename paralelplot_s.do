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
levelsof sector, local(CLASE)
foreach c of local CLASE {
	display "`c'"
}
*******************************************************************
levelsof sector, local(CLASE)
foreach c of local CLASE {
	local cl "`c'"
	display "`cl'"
}
*******************************************************************
levelsof sector, local(CLASE)
foreach c of local CLASE {
	sectorname `c'
	display r(name)
}
*******************************************************************
levelsof sector, local(CLASE)
foreach c of local CLASE {
	local cl "`c'"
	
	sectorname `cl'
	local titulo = r(name)
	display "`titulo'"
}
*******************************************************************
levelsof sector, local(CLASE)
foreach c of local CLASE {
	sectorname `c'
	display r(name)
}
*******************************************************************
levelsof sector, local(CLASE)
foreach c of local CLASE {
	sectorname `c'
	local titulo = r(name)
	display "`titulo'"
}
*******************************************************************


preserve
local c "94"
keep if hs2=="`c'"

*bysort date tariff: egen m_S = mean(S)
bysort date tariff: egen m_S = median(S)

collapse (first) m_S, by(date tariff)
rename m_S S

reshape wide S, i(date) j(tariff)

sort date
tset date

#delimit ;
twoway line S0 date, sort || 
line S1 date, sort lpattern(dash)
legend(label(1 "Control") label(2 "Treated")) 
tline(2018q3) 
; #delimit cr
restore
*******************************************************************
*scalar coefhp = 5
*tsfilter hp S0_hp = S0, smooth(`coefhp')
*tsfilter hp S1_hp = S1, smooth(`coefhp')
*gen S0_smooth = S0 - S0_hp
*gen S1_smooth = S1 - S1_hp
*#delimit ;
*twoway line S0_smooth date, sort || 
*line S1_smooth date, sort lpattern(dash)
*legend(label(1 "Control") label(2 "Treated")) 
*tline(2018q3) 
*; #delimit cr
*******************************************************************
* medianas sin HP
levelsof sector, local(CLASE)
foreach c of local CLASE {
display "`c'"

sectorname `c'
display r(name)

local titulo = r(name)
display "`titulo'"

preserve
keep if sector=="`c'" 
bysort date tariff: egen mean_S = mean(S)

collapse (first) mean_S, by(date tariff)
rename mean_S S

reshape wide S, i(date) j(tariff)

sort date
tset date

#delimit ;
twoway line S0 date, sort || 
line S1 date, sort lpattern(dash)
legend(label(1 "Control") label(2 "Treated")) 
tline(2018q3)
title("`titulo'", size(huge))
subtitle("sector: `c'", size(large))
ytitle("S", size(large)) 
; #delimit cr
graph export "${Path}\DOC\paralelplot_s\paralelplot_`c'.pdf" , as(pdf)  replace
restore
}
*******************************************************************
* tendencias HP
levelsof sector, local(CLASE)
foreach c of local CLASE {
*local c "28-38"
display "`c'"

sectorname `c'
display r(name)

local titulo = r(name)
display "`titulo'"

preserve
keep if sector=="`c'" 
bysort date tariff: egen mean_S = mean(S)

collapse (first) mean_S, by(date tariff)
rename mean_S S

reshape wide S, i(date) j(tariff)

sort date
tset date
tsfilter hp S0_hp = S0, smooth(5)
tsfilter hp S1_hp = S1, smooth(5)
gen S0_smooth = S0 - S0_hp
gen S1_smooth = S1 - S1_hp

#delimit ;
twoway line S0_smooth date, sort || 
line S1_smooth date, sort lpattern(dash)
legend(label(1 "Control") label(2 "Treated")) 
tline(2018q3)
title("`titulo'", size(huge))
subtitle("sector: `c'", size(large))
ytitle("S", size(large)) 
; #delimit cr
graph export "${Path}\DOC\paralelplot_s\paralelplot_`c'.pdf" , as(pdf)  replace
restore
}









