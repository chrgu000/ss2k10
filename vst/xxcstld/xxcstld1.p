/* xxcstld1.p - ppcsbtld.p cim load                                          */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */
{mfdeclre.i}
{xxcstld.i}
define variable vfile as character.

assign vfile = "xxwold.p." + string(today,"99999999") + '.' + string(time).
output to value(vfile + ".bpi").
for each xxsptdet no-lock where xxspt_chk = "".
    put unformat "N" skip.
    put unformat '"' xxspt_part '" "' xxspt_site '"' skip.
    put unformat '"' xxspt_sim '"' skip.
    put unformat '"' xxspt_element '" ' xxspt_cst skip.
    put unformat '-' skip.
end.
output close.

if cloadfile then do:
   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""ppcsbtld.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.

   for each xxsptdet exclusive-lock where xxspt_chk = "":
       find first spt_det no-lock where spt_site = xxspt_site and
               spt_sim = xxspt_sim and spt_part = xxspt_part and
               spt_element = xxspt_element no-error.
       if available spt_det and spt_cst_tl = xxspt_cst then do:
          assign xxspt_chk = "OK".
       end.
       else do:
          assign xxspt_chk = "FAIL".
       end.
   end.
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
end.
