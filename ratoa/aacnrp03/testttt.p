define var vendp_qty_re_scrp as int .
define var  vendp_qty_potr as int.
define var vendp_lastqty_oh as int.
define var global_domain as char .
define var mypart as char.
define var myvend as char .
define var i as int.
define var xx as int.
i = 0 .

global_domain = "30000".
mypart = "61510-A300100-0001".
myvend = "200352".

vendp_qty_re_scrp = 0 .
vendp_qty_potr = 0 .
vendp_lastqty_oh = 0 .

FOR EACH tr_hist NO-LOCK WHERE tr_domain =  global_domain    
and tr_effdate >= date(8,21,2012) and tr_effdate <= date(9,20,2012)  
and tr_part = mypart and substring(tr_serial,10,6) = myvend :
/*废品退供应商*/
IF tr_type = "iss-unp"  AND (tr_program = "aahjrtmt.p" or tr_program = "aahjrtbkmt.p")
and (tr_loc = "NC1" or tr_loc begins "P" or tr_loc begins "S") THEN 
assign vendp_qty_re_scrp = vendp_qty_re_scrp  - tr_qty_loc .
/*合格品退供应商*/
if tr_type = "iss-prv" and tr_program = "aaporvis.p" then 
assign vendp_qty_re_scrp = vendp_qty_re_scrp - tr_qty_loc.  
/*计算入库数*/
if tr_type = "rct-tr"   and tr_program = "aatrchmt.p" then   
assign vendp_qty_potr = vendp_qty_potr + tr_qty_loc.         
end.
for each ld_det use-index ld_part_loc where ld_domain = global_domain
and ld_site = "31000" and ld_part = mypart 
and (ld_loc begins "P" or ld_loc = "NC1" or ld_loc begins "s" ) 
and substring(ld_lot,10) = myvend  no-lock
break by ld_part by substring(ld_lot,10):  /*合计当前库存*/
vendp_lastqty_oh = vendp_lastqty_oh + ld_qty_oh.
end.                       
xx = vendp_lastqty_oh.
for each tr_hist where tr_domain = global_domain
and tr_site = "31000" and tr_effdate > date(9,20,2012)
and tr_part = mypart
and (tr_loc begins "P" or tr_loc = "NC1" or tr_loc begins "S")
and substring(tr_serial,10) = myvend no-lock
break by tr_effdate descending by tr_trnbr descending:
vendp_lastqty_oh = vendp_lastqty_oh - tr_qty_loc.
i = i + 1.
disp i tr_trnbr tr_loc tr_type tr_qty_loc.
end. /*for each tr_hist*/ 
disp i vendp_lastqty_oh vendp_qty_potr vendp_qty_re_scrp xx.