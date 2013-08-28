define var xxqty1 as int .
define var xxqty2 as int .
define var xxqty3 as int .
define var xxqty4 as int .
define var xxqty5 as int .
define var xxqty7 as int .
define var xxqty8 as int .
define var xxqty9 as int .
define var xxqty10 as int .
define var xxqty11 as int.
define var global_domain as char .
define var mypart as char.
define var myvend as char .
define var dd1 as date.
define var dd2 as date.
define var mysite as char.
mysite = "31000".
dd1 = date(8,21,2012).
dd2 = date(9,20,2012).
global_domain = "30000".
mypart = "61510-A300100-0001".
myvend = "200352".
xxqty1 = 0 .
xxqty2 = 0 .
xxqty3 = 0 .
xxqty4 = 0 .
xxqty5 = 0 .
xxqty7 = 0 .
xxqty8 = 0 .
xxqty9 = 0 .
xxqty10 = 0 .
xxqty11 = 0 .

for each tr_hist where tr_domain = global_domain 
and tr_part = mypart and tr_site = mysite
and tr_effdate >= dd1
and substring(tr_serial,10,6) = myvend
and tr_qty_loc <> 0 and tr_ship_type = ""  no-lock
break by tr_part by tr_loc by substring(tr_serial,10,6) by tr_effdate:
if tr_effdate <= dd2 and tr_loc <> "NC1" then do:
if ( tr_type begins "rct" or tr_type = "cn-rct" or tr_type = "TAG-CNT" ) then
xxqty2 = xxqty2 + tr_qty_loc.
else 
if (tr_type = "CYC-RCNT" and tr_qty_loc > 0) then 
xxqty2 = xxqty2 + tr_qty_loc.
else
xxqty3 = xxqty3 - tr_qty_loc.
end.
if tr_effdate <= dd2 and tr_loc = "NC1" then do:        
if (tr_type begins "rct" or tr_type = "iss-wo" or (tr_type = "CYC-RCNT" and tr_qty_loc >0))        then
xxqty2 = xxqty2 + tr_qty_loc.
else        
xxqty3 = xxqty3 - tr_qty_loc.        
end.               
if tr_effdate > dd2 then do:
if ( tr_type begins "rct" or tr_type = "cn-rct" or tr_type = "CYC-RCNT" or tr_type = "TAG-CNT")  
then xxqty9 = xxqty9 + tr_qty_loc.
else  xxqty10 = xxqty10 - tr_qty_loc.
xxqty11 = xxqty11 + 1.


end.
                
if last-of(substring(tr_serial,10,6)) then do:                        
xxqty7 = 0.
xxqty8 = 0.
for each ld_det where ld_domain = global_domain and ld_part = tr_part and 
ld_site = mysite and ld_loc = tr_loc and 
substring(ld_lot,10,6) = substring(tr_serial,10,6) no-lock:
if ld_status begins "NN" then
xxqty8 = xxqty8 + ld_qty_oh.
else
xxqty7 = xxqty7 + ld_qty_oh.
end.
xxqty1 = xxqty8 + xxqty7 - xxqty2 + xxqty3 - xxqty9 + xxqty10 .
xxqty4 = xxqty8 .
xxqty5 = xxqty7 - xxqty9 + xxqty10 + xxqty4.

disp  xxqty1 xxqty5  xxqty7 xxqty8 xxqty9  xxqty10  xxqty4.
 xxqty2 = 0 . xxqty1 = 0 . xxqty3 = 0 . xxqty4 = 0 . xxqty5 = 0 . 
xxqty9 = 0 . xxqty10 = 0 .    xxqty11 = 0 .
end.
end.
