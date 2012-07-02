/* xxinvld.p - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

{mfdeclre.i}
{xxbmld.i}
define variable vfile as character.

assign vfile = "xxbmld.p." + string(today,"99999999") + '.' + string(time).

output to value(vfile + ".bpi").

for each tmpbom exclusive-lock where tbm_chk = "":
    put unformat '"' tbm_par '"' skip.
    put unformat '"' tbm_old '" "" ' tbm_ostart skip.
    put unformat '- - ' tbm_ostart ' ' tbm_oend skip.
    put "." skip.
    put unformat '"' tbm_par '"' skip.
    put unformat '"' tbm_new '" "" ' tbm_nstart skip.
    put unformat tbm_qty_per ' - ' tbm_nstart ' ' tbm_nend skip.
    put "." skip.
end.
output close.

batchrun = yes.
input from value(vfile + ".bpi").
output to value(vfile + ".bpo") keep-messages.
hide message no-pause.
cimrunprogramloop:
do on stop undo cimrunprogramloop,leave cimrunprogramloop:
   {gprun.i ""bmpsmt.p""}
end.
hide message no-pause.
output close.
input close.
batchrun = no.

for each tmpbom exclusive-lock:
    if can-find(first ps_mstr no-lock where ps_par = tbm_par and ps_comp = tbm_old
                  and ps_ref = "" and ps_start = tbm_ostart and ps_end = tbm_oend) and
       can-find(first ps_mstr no-lock where ps_par = tbm_par and ps_comp = tbm_new
                  and ps_ref = "" and ps_start = tbm_nstart and ps_end = tbm_nend) then do:
      assign tbm_chk = "OK".
    end.
end.

os-delete value(vfile + ".bpi").
os-delete value(vfile + ".bpo").
