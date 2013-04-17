/* xxinvld.p - 日供发票导入，可以提示错误 装入系统                           */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

{mfdeclre.i}
{xxinvld.i}
define variable vfile as character.
assign vfile = "xxinvld.p." + string(today,"99999999") + '.' + string(time).
output to value(vfile + ".bpi").
for each tmpinv no-lock:
    put unformat '"' + tiv_vend + '" "' + tiv_ivnbr + '"' skip.
    if tiv_tax  then put "Y".
    						else put "N".
    put unformat ' "' + tiv_ctrnbr + '"' skip.
    put unformat tiv_line skip.
    put unformat tiv_draw skip.
    put unformat tiv_tray ' ' tiv_qty ' ' tiv_type skip.
    put '.' skip.
end.
output close.

batchrun = yes.
input from value(vfile + ".bpi").
output to value(vfile + ".bpo") keep-messages.
hide message no-pause.
cimrunprogramloop:
do on stop undo cimrunprogramloop,leave cimrunprogramloop:
   {gprun.i ""xxinvmt.p""}
end.
hide message no-pause.
output close.
input close.
batchrun = no.

for each tmpinv exclusive-lock:
    if can-find (first xxship_det no-lock where xxship_vend = tiv_vend and
                       xxship_nbr = tiv_ivnbr and xxship_line = tiv_line and
                       xxship_part = tiv_draw) then do:
       assign tiv_chk = "装入成功".
    end.
    else do:
       assign tiv_chk = "装入失败".
    end.
end.

os-delete value(vfile + ".bpi").
os-delete value(vfile + ".bpo").
