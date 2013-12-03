/* xxapvold.p - apvomt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 131115.1 LAST MODIFIED: 11/15/13 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxapvold.i}
define variable vamt like vod_amt no-undo.
define variable vfile as character.
define stream bf.
for each xxapvotmp no-lock where xxapt_chk = "" break by xxapt_ref.
    if first-of(xxapt_ref) then do:
       assign vfile = execname + trim(string(xxapt_sn,"99999")).
       output stream bf close.
       output stream bf to value(vfile + ".bpi").
       put stream bf unformat '""' skip.
       put stream bf unformat '-' skip.
       put stream bf unformat '"' xxapt_ref '"' skip.
       put stream bf "." skip.
           put stream bf unformat trim(string(xxapt_tot)) ' '.
           find ap_mstr where ap_ref = xxapt_ref and
                ap_type = "VO" no-lock no-error.
           if not available ap_mstr then do:
              put stream bf unformat '"' xxapt_vd '"'.
           end.
           put stream bf skip.
       put stream bf unformat "-" ' '.
       if not available ap_mstr then do:
          put stream bf unformat "-" ' '.
       end.
       put stream bf  '"' trim(xxapt_invoice) '"' skip.  /* curr */
       put stream bf unformat "-" skip.  /* perPay */
       put stream bf unformat "-" skip.  /* tax */
       assign vamt = 0.
    end.
    put stream bf unformat xxapt_line skip. /* line */
    find first vod_det where vod_ref = xxapt_ref and vod_ln = xxapt_line no-error.
    if not available vod_det then do:
       put stream bf unformat xxapt_acct ' - "' xxapt_cc '" "' xxapt_proj '" - '.
    end.
    put stream bf unformat '"' trim(xxapt_taxable) '"' skip.
    put stream bf unformat '-' skip. /* tax */
    put stream bf unformat '"' trim(xxapt_cmmt) '"' skip. /*desc*/
    put stream bf unformat trim(string(xxapt_amt)) skip.
    assign vamt = vamt + xxapt_amt.
    if last-of(xxapt_ref) then do:
       put stream bf unformat '.' skip.
       put stream bf unformat 'N' skip.
       put stream bf unformat '-' skip.
       if vamt <> xxapt_tot and xxapt_tot <> 0 then do:
       put stream bf unformat 1 skip.  /*ctrl and detial is diff 1. accept*/
       end.
       put stream bf unformat '.' skip.
       put stream bf unformat '.' skip.
       output stream bf close.
         input from value(vfile + ".bpi").
         output stream bf to value(vfile + ".bpo") keep-messages.
         batchrun = yes.
         cimrunprogramloop:
         do transaction:
            hide message no-pause.
            {gprun.i ""apvomt.p""}
            hide message no-pause.
         end.
         batchrun = no.
         output close.
         input stream bf close.
/*
         os-delete value(vfile + ".bpi").
         os-delete value(vfile + ".bpo").
*/
    end.
end.
output close.
