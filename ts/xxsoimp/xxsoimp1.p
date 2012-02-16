/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxsoimp.i}

define variable fn as character.
define variable i as integer.
assign fn = "xxsoimp" + string(time).
output to value(fn + ".bpi").
FOR EACH tmp-so NO-LOCK WHERE BREAK BY tso_nbr BY tsod_line:
        find first pt_mstr no-lock where pt_domain = global_domain
               and pt_part = tsod_part no-error.
        IF FIRST-OF(tso_nbr) THEN DO:
            PUT UNFORMAT '"' tso_nbr '"' SKIP.
            PUT UNFORMAT '"' tso_cust '"' SKIP.
            PUT UNFORMAT '"' tso_bill '"' SKIP.
            PUT UNFORMAT '"' tso_ship '"' SKIP.
            PUT UNFORMAT '- "' tso_req_date '" - "' tso_due_date '" - - - "' tso_rmks '" ' .
            PUT UNFORMAT '- - "' tso_site '" - - '.
            PUT UNFORMAT '- ' tso_curr SKIP.
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
        END. /* if first-of tso_nbr */

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
        if available cm_mstr and cm_taxable then do:
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
        IF LAST-OF(tso_nbr) THEN DO:
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '-' SKIP.
        END. /*  IF LAST-OF(tso_nbr) THEN DO: */
    END.
OUTPUT CLOSE.

INPUT FROM VALUE(fn  + ".bpi") .
OUTPUT TO VALUE(fn + ".bpo") .
batchrun = yes.
{gprun.i ""sosomt.p""}
batchrun = NO.
INPUT CLOSE .
OUTPUT CLOSE .

assign i = 0.
for each tmp-so exclusive-lock:
     find first sod_det no-lock where sod_domain = global_domain
            and sod_nbr = tso_nbr and sod_line = tsod_line
            and sod_part = tsod_part and sod_qty_ord = tsod_qty_ord 
     no-error.
     if not available sod_det then do:
        assign tsod_chk = "ERROR......".
        assign i = 1.
     end.
     else do:
        assign tsod_chk = "OK!".
     end.
end.

if i = 0 then do:
    os-delete value(fn + ".bpi") no-error.
    os-delete value(fn + ".bpo") no-error.
end.