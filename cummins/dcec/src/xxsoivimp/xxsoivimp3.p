/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxsoivimp.i}

define variable fn as character.
define variable i as integer.
define variable taxable as logical.

FOR EACH tmp-so NO-LOCK WHERE BREAK BY tso_nbr BY tsod_line:
        find first pt_mstr no-lock where pt_domain = global_domain
               and pt_part = tsod_part no-error.
        IF FIRST-OF(tso_nbr) THEN DO:
            assign fn = "xxsoimp_" + tso_nbr.
            output to value(fn + ".bpi").
            PUT UNFORMAT '"' tso_nbr '"' SKIP.
            PUT UNFORMAT '"' tso_cust '"' SKIP.
            PUT UNFORMAT '"' tso_bill '"' SKIP.
            PUT UNFORMAT '"' tso_ship '"' SKIP.
            PUT UNFORMAT tso_ord_date ' - - - - - '.
            if tso_rmks = "-" then PUT UNFORMAT '- '.
                              else PUT UNFORMAT '"' tso_rmks '" ' .
            PUT UNFORMAT '- - "' tso_site '" "' tso_channel '" - '.
            PUT UNFORMAT '- ' vcurr SKIP.
            /* 兑换率 */
            for first en_mstr
              fields(en_domain en_curr en_entity en_name)
                where en_mstr.en_domain = global_domain and
                      en_entity = current_entity
              no-lock:
            END.
            IF AVAILABLE en_mstr THEN DO:
                IF vcurr <> en_curr OR vcurr = ? THEN DO:
                    PUT "-" SKIP.
                END.
            END.
            if tso_tax_usage = "-" then do:
               put unformat '-' skip.
            end.
            else do:
               PUT UNFORMAT '"' tso_tax_usage '"' SKIP. /* 税 */
            end.
            PUT UNFORMAT '- NO - - - - - - - - - - NO' SKIP. /*推销员(无备注)*/
        END. /* if first-of tso_nbr */

        PUT UNFORMAT tsod_line SKIP.
        PUT UNFORMAT '"' tsod_part '"' SKIP.
        PUT UNFORMAT '"' tsod_site '"' SKIP.
        PUT UNFORMAT trim(string(tsod_qty_ord,"->>>>,>>9.9<<<")) SKIP.
        PUT UNFORMAT '-' SKIP.  /* 价格单 */
  /* jordan 21030227.1         PUT UNFORMAT '-' SKIP.  */ /*单价*/
        PUT UNFORMAT tsod_pr SKIP.   /*单价*/
        PUT UNFORMAT '-' SKIP.  /*净价*/
        if not available pt_mstr then do:
           PUT UNFORMAT '-' SKIP.  /*描述 jordan 20130227*/
        end.
        /* PUT UNFORMAT '"' tsod_loc '" - - "' tsod_acct '" "' tsod_sub. */
           PUT UNFORMAT '"TEMP" - - - - '.
        IF tsod_acct = "-" then
           PUT UNFORMAT "- ".
        ELSE
           PUT UNFORMAT '"' tsod_acct '" '.
        IF tsod_sub = "-" then
           PUT UNFORMAT "- ".
        ELSE
           PUT UNFORMAT '"' tsod_sub '" '.
        IF tsod_cc = "-" then
           PUT UNFORMAT "- ".
        ELSE
           PUT UNFORMAT '"' tsod_cc '" '.   
        IF tsod_project = "-" then
           PUT UNFORMAT "- ".
        ELSE
           PUT UNFORMAT '"' tsod_project '" '.    
        if available pt_mstr then do:
           put unformat '- - - - - - - - - M - - - - - N' SKIP.
        end.
        else do:
          put unformat skip.
        end.
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
/*      IF tsod_rmks1 <> "-" THEN DO:                                        */
/*         PUT UNFORMAT '- - - - - - - - - - y' skip.                        */
/*         PUT UNFORMAT '-' SKIP.                                            */
/*         PUT UNFORMAT '-' SKIP.                                            */
/*         PUT UNFORMAT '"' tsod_rmks1 '"' SKIP.                             */
/*         PUT UNFORMAT '-' SKIP.                                            */
/*         PUT UNFORMAT '.' SKIP.                                            */
/*      END.                                                                 */
        IF LAST-OF(tso_nbr) THEN DO:
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '- - - - "' tsod_inv_nbr '"' SKIP.
           output close.

           INPUT FROM VALUE(fn  + ".bpi") .
           OUTPUT TO VALUE(fn + ".bpo") .
           batchrun = yes.
           {gprun.i ""soivmt.p""}
           batchrun = NO.
           INPUT CLOSE.
           OUTPUT CLOSE.

        END. /*  IF LAST-OF(tso_nbr) THEN DO: */
    END.
OUTPUT CLOSE.


for each tmp-so exclusive-lock break by tso_nbr by tsod_line:
    if first-of(tso_nbr) then do:
       assign i = 0.
       assign fn = "xxsoimp_" + tso_nbr.
    end.
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
     if last-of(tso_nbr) then do:
        if i = 0 then do:
            os-delete value(fn + ".bpi") no-error.
            os-delete value(fn + ".bpo") no-error.
        end.
     end.
end.

