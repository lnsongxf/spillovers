/* MexReform.do v0.00            damiancclarke             yyyy-mm-dd:2014-11-07
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

This file runs regressions of the form:

birth(ijt) = ... + alpha*Reform(ijt-1) + beta*Close(ijt-1) + XG + u(ijt)

contact: mailto:damian.clarke@economics.ox.ac.uk

*/

vers 11
clear all
set more off
cap log close

********************************************************************************
*** (1) Globals and Locals
********************************************************************************
global DAT "~/investigacion/2014/Spillovers/data"
global OUT "~/investigacion/2014/Spillovers/results/Mexico"
global LOG "~/investigacion/2014/Spillovers/log"

log using "$LOG/MexReform.txt", replace text

local FE i.stateid i.year#i.month
local tr i.stateid#c.linear
local se cluster(stateid)
local cont medicalstaff MedMissing planteles* aulas* bibliotecas* totalinc /*
*/ totalout subsidies unemployment

********************************************************************************
*** (2) Setup data
********************************************************************************
use "$DAT/MunicipalBirths.dta"
gen AgeGroup=.
replace AgeGroup=1 if Age>=15&Age<=17
replace AgeGroup=2 if Age>=18&Age<=24
replace AgeGroup=3 if Age>=25&Age<=29
replace AgeGroup=4 if Age>=30&Age<=39
drop if AgeGroup==.

collapse `cont' Abortion (sum) birth, by(stateid munid year month AgeGroup)
merge m:1 stateid munid using "$DAT/DistProcessed.dta"

********************************************************************************
*** (3) Regressions
********************************************************************************
