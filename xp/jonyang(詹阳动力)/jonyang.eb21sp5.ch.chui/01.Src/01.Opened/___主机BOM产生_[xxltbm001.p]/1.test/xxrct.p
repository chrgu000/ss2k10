4,561.80 

output to "/new/rct123.txt" .
for each tr_hist 
use-index tr_type
where tr_domain  = "jy" 
and tr_type = "RCT-wo"
and tr_effdate >= date(01,01,2010) 
and tr_qty_loc = 1 
:
disp tr_part tr_nbr tr_lot tr_qty_loc tr_serial  with width 100 .
end.
output close .



output to "/new/wo_bmtest_wod.txt" .
for each wod_det
where wod_domain = "jy"
and wod_nbr = "bmtest" no-lock,
each wo_mstr
where wo_domain = "jy"
and wo_lot = wod_lot
break by wod_lot by wod_part:
disp wod_nbr wod_lot wo_part wo_qty_ord wo_qty_comp
wod_part wod_op wod_bom_qty wod_qty_req wod_qty_iss
with width 200.

end.
output close .



for each xbm_mstr : delete xbm_mstr . end. 
for each xbmd_det : delete xbmd_det . end. 
for each xbmzp_det : delete xbmzp_det . end. 

for each xuse_mstr : delete xuse_mstr . end. 
for each xused_det : delete xused_det . end. 



for each xpre_det : delete xpre_det . end. 
for each xzp_det   : delete xzp_det . end. 
for each xsub_det : delete xsub_det . end. 




for each ps_mstr
where ps_domain = "Jy"
and ps_par = "JYL210E-50-4" .....
and ps_end = today
:
assign ps_userid = "mfg" ps_mod_date = today ps_end = today - 1  .
disp ps_comp ps_start ps_end ps_userid ps_mod_date  .

end.


output to "/new/wo_bmtest_trhist.txt" .
for each tr_hist 
where tr_domain  = "jy" 
and tr_nbr = "bmtest"
and tr_effdate >= date(09,01,2010) 
break by tr_nbr by tr_lot by tr_type:
disp tr_nbr tr_lot tr_part tr_qty_loc tr_serial  with width 100 .
end.
output close .

