/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxsoimp.i}

define variable fn as character    no-undo.
define variable vtmp as character  no-undo.
define variable verr as character  no-undo.
define variable taxable as logical no-undo.
define variable newso like mfc_logical  no-undo.
define variable newsod like mfc_logical no-undo.

FOR EACH tmp-so EXCLUSIVE-LOCK WHERE tsod_chk = "" BREAK BY tso_nbr BY tsod_line:
assign newso = yes.
       newsod = yes.
find first sod_det no-lock where sod_domain = global_domain
       and sod_nbr = tso_nbr
       and sod_line = tsod_line no-error.
if available sod_det then do:
   assign newsod = no
          newso = no.
end.
else do:
     find first so_mstr no-lock where so_domain = global_domain
            and so_nbr = tso_nbr no-error.
     if available so_mstr then do:
        assign newso = no.
     end.
end.
assign fn = execname + "." + tso_nbr + "." + trim(string(tsod_line,">>>>9")).
   output to value(fn + ".bpi").
        find first pt_mstr no-lock where pt_domain = global_domain
               and pt_part = tsod_part no-error.
/*       IF FIRST-OF(tso_nbr) THEN DO:                                       */
            PUT UNFORMAT '"' tso_nbr '"' SKIP.
            PUT UNFORMAT '"' tso_cust '"' SKIP.
            PUT UNFORMAT '"' tso_bill '"' SKIP.
            PUT UNFORMAT '"' tso_ship '"' SKIP.
            if newso then do:
               PUT UNFORMAT '- "' tso_req_date '" - "' tso_due_date '" - - - '.
               if tso_rmks = "-" then PUT UNFORMAT '- '.
                                 else PUT UNFORMAT '"' tso_rmks '" ' .
               PUT UNFORMAT '- - "' tso_site '" - - '.
               PUT UNFORMAT '- ' tso_curr SKIP.
            end.
            else do:
               PUT UNFORMAT '-' SKIP.
            end.
            PUT UNFORMAT '-' SKIP.
            PUT UNFORMAT '-' SKIP.
            for first en_mstr
              fields( en_domain en_curr en_entity en_name)
                where en_mstr.en_domain = global_domain and
                      en_entity = current_entity
              no-lock:
            END.
            IF AVAILABLE en_mstr THEN DO:
                IF tso_curr <> en_curr OR tso_curr = ? THEN DO:
                    PUT "-" SKIP.
                END.
            END.
/*      END. /* if first-of tso_nbr */                                       */

        PUT UNFORMAT tsod_line SKIP.
        PUT UNFORMAT '"' tsod_part '"' SKIP.
        PUT UNFORMAT '"' tsod_site '"' SKIP.
        PUT UNFORMAT trim(string(tsod_qty_ord,"->>>>,>>9.9<")) SKIP.
        PUT UNFORMAT "-" SKIP.  /*价格单*/
        PUT UNFORMAT "-" SKIP.  /*单价*/
        PUT UNFORMAT "-" SKIP.  /*净价*/
        /* PUT UNFORMAT '"' tsod_loc '" - - "' tsod_acct '" "' tsod_sub. */
        IF tsod_loc = "-" THEN
           PUT UNFORMAT "- - - ".
        ELSE
           PUT UNFORMAT '"' tsod_loc '" - - '.
        IF tsod_acct = "-" then
           PUT UNFORMAT "- ".
        ELSE
           PUT UNFORMAT '"' tsod_acct '" '.
        IF tsod_sub = "-" then
           PUT UNFORMAT "- ".
        ELSE
           PUT UNFORMAT '"' tsod_sub '" '.
        PUT UNFORMAT '- - - - - - - - - ' tsod_due_date SKIP.
        find first cm_mstr no-lock where cm_domain = global_domain and
                   cm_addr = tso_cust no-error.
        if available cm_mstr then do:
           assign taxable = cm_taxable.
        end.
        for first ad_mstr where ad_domain = global_domain
              and ad_addr   = tso_ship no-lock:
           assign taxable = ad_taxable.
        end.
        for first ad_mstr where ad_domain = global_domain
              and ad_addr   = tso_cust no-lock:
           assign taxable = ad_taxable.
        end.
        find first pt_mstr no-lock where pt_domain = global_domain and
                   pt_part = tsod_part no-error.
        if available pt_mstr and pt_taxable and taxable then do:
            PUT UNFORMAT '-' SKIP. /*税*/
        end.
        if not available pt_mstr then do:
             PUT UNFORMAT '-' SKIP.  /* ITEM_NOT_IN_INVENTORY */
        end.
        IF tsod_rmks1 <> "-" THEN DO:
           PUT UNFORMAT '- - - - - - - - - - y' skip.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '"' tsod_rmks1 '"' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '.' SKIP.
        END.
/*     IF LAST-OF(tso_nbr) THEN DO:                                          */
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '-' SKIP.
/*        END. /*  IF LAST-OF(tso_nbr) THEN DO: */                           */
   output close.

   cimrunprogramloop:
   do transaction /* on stop undo cimrunprogramloop,leave cimrunprogramloop */ :
     input from value(fn + ".bpi").
     output to value(fn + ".bpo") keep-messages.
     pause 0 before-hide.
     hide message no-pause.
     batchrun = yes.
        {gprun.i ""sosomt.p""}
     batchrun = no.
     pause before-hide.
     hide message no-pause.
     output close.
     input close.
     find first sod_det no-lock where sod_domain = global_domain
            and sod_nbr = tso_nbr and sod_line = tsod_line
            and sod_part = tsod_part and sod_qty_ord = tsod_qty_ord
     no-error.
     if not available sod_det then do:
        assign vtmp = fn + ".bpo"
               verr = "ERROR.".
        {gprun.i ""xxgetcimerr.p"" "(input vtmp,output verr)"}
        if verr = "" then verr = 'OK'.
        /* undo,leave. */
     end.
     else do:
        assign verr = "OK!".
        os-delete value(fn + ".bpi") no-error.
        os-delete value(fn + ".bpo") no-error.
     end.
  end.  /* cimrunprogramloop: */
  assign tsod_chk = verr.
end. /*for each tmp-so*/
