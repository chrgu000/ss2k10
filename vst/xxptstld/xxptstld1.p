/* xxptstld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxptld.i}
define variable vfile as character.

assign vfile = "xxptstld.p." + string(today,"99999999") + '.' + string(time).

output to value(vfile + ".bpi").
for each xxtmppt no-lock where xxpt_chk = "".
    put unformat '"' xxpt_part '"' skip.
    put unformat '-' skip.
    put unformat '- - - - - ' xxpt_stat skip.
end.
output close.
for each xxtmppt exclusive-lock:
     if xxpt_stat = "-" then do:
        assign xxpt_stat = xxpt_ostat.
     end.
end.
if cloadfile then do:
   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""ppptmt04.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.

   for each xxtmppt exclusive-lock where xxpt_chk = "":
       find first pt_mstr no-lock where pt_part = xxpt_part no-error.
       if available pt_mstr and pt_status = xxpt_stat then do:
          assign xxpt_chk = "OK".
       end.
       else do:
          assign xxpt_chk = "FAIL".
       end.
   end.
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
end.
