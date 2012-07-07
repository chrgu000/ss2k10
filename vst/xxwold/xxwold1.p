/* xxwold1.p - wowomt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxwold.i}
define variable vfile as character.

assign vfile = "xxwold.p." + string(today,"99999999") + '.' + string(time).

output to value(vfile + ".bpi").
for each xxwo no-lock where xxwo_chk = "".
    put unformat '"" "' xxwo_lot '"' skip.
    put unformat '- - ' xxwo_rel_date ' ' xxwo_due_date ' - - - - - - - - n' skip.
    put unformat '-' skip.
    put unformat '-' skip.
    put unformat '-' skip.
end.
output close.
for each xxwo exclusive-lock:
     if xxwo_due_date = "-" then do:
        assign xxwo_due_date = xxwo_odue_date.
     end.
     if xxwo_rel_date = "-" then do:
        assign xxwo_rel_date = xxwo_orel_date.
     end.
end.
if cloadfile then do:
   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""wowomt.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.

   for each xxwo exclusive-lock where xxwo_chk = "":
       find first wo_mstr no-lock where wo_lot = xxwo_lot no-error.
       if available wo_mstr and wo_rel_date = xxwo_rel_date and 
       						  wo_due_date = xxwo_due_date
       then do:
          assign xxwo_chk = "OK".
       end.
       else do:
          assign xxwo_chk = "FAIL".
       end.
   end.
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
end.
