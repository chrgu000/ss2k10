/* xxicajld1.p.p - xxicccaj.p cim load                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120704.1 LAST MODIFIED: 07/04/12 BY:                            */
/* REVISION END                                                              */
{mfdeclre.i}
{xxicajld.i}
define variable vfile as character.
define variable trrecid as recid.
define variable clearwkfl as logical initial yes no-undo.

find first code_mstr no-lock where code_fldname = "Keep_Temp_WorkFile"
       and code_value = "YES|OTHER" and code_cmmt = "YES" no-error.
if available code_mstr then do:
    assign clearwkfl = no.
end.

for each xxic exclusive-lock where xxic_chk = "".
   assign vfile = "xxicajld.p." + string(xxic_sn,"9999999").
   output to value(vfile + ".bpi").
       put unformat 'R' skip.
       put unformat '"' xxic_part '"' skip.
       put unformat '"' xxic_site '" "' xxic_loc '" "' xxic_lot '" "' xxic_ref '"' skip.
       put unformat xxic_qty_adj ' - -' skip.
       put unformat '- ' today ' "' xxic_acct '" "' xxic_sub '" "' xxic_cc '"' skip.
       put "Y" skip.
       put "." skip.
   output close.

/*   assign trrecid = current-value(tr_sq01).  */
   find last tr_hist no-lock no-error.
   if available tr_hist then do:
      assign trrecid = tr_trnbr.
   end.

   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""xxicccaj.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.

   find first tr_hist no-lock where tr_trnbr > integer(trrecid)  and
              tr_type = "CYC-RCNT" and tr_date = today and
              tr_part = xxic_part and tr_site = xxic_site and
              tr_loc = xxic_loc and tr_lot = xxic_lot and
              tr_ref = xxic_ref and tr_qty_loc = xxic_qty_adj no-error.
   if available tr_hist then do:
      assign xxic_chk = "TRNBR:" + string(tr_trnbr).
   end.
   else do:
      assign xxic_chk = "FAIL".
   end.

   if clearwkfl then do:
      os-delete value(vfile + ".bpi").
      os-delete value(vfile + ".bpo").
   end.
end.   /* for each tmpic no-lock where xxic_chk = "". */
