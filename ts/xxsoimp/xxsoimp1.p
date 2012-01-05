/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxsoimp.i}

define variable fn as character.
define variable i as integer.
define variable chk as logical.
assign fn = "xxsoimp" + string(time).
output to value(fn + ".bpi").
FOR EACH tmp-so NO-LOCK WHERE BREAK BY tso_nbr BY tsod_line:
        IF FIRST-OF(tso_nbr) THEN DO:
            PUT UNFORMAT '"' tso_nbr '"' SKIP.
            PUT UNFORMAT '"' tso_cust '"' SKIP.
            PUT UNFORMAT '"' tso_bill '"' SKIP.
            PUT UNFORMAT '"' tso_ship '"' SKIP.
            PUT UNFORMAT '- "' tso_req_date '" - "' tso_due_date '" - - - '.
            if tso_rmks = "-" then put unformat '- '.
                              else put unformat '"' tso_rmks '" '.
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
        if tsod_site = ? or tsod_site = "" then PUT UNFORMAT '-' SKIP.
           else PUT UNFORMAT '"' tsod_site '"' SKIP.
        PUT UNFORMAT trim(string(tsod_qty_ord,"->>>>,>>9.9<")) SKIP.
        PUT UNFORMAT "-" SKIP.
        PUT UNFORMAT "-" SKIP.
        PUT UNFORMAT "-" SKIP.
        PUT UNFORMAT '"' tsod_loc '" - - "' tsod_acct '" "' tsod_sub.
            put unformat '" - - - - - - - - - ' tsod_due_date SKIP.
        IF tsod_rmks1 <> "-" THEN DO:
           PUT UNFORMAT '- - - - - - - - - - y' skip.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '"' tsod_rmks1 '"' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '.' SKIP.
        END.
        ELSE DO:
           PUT UNFORMAT '-' SKIP.
        END.
        IF LAST-OF(tso_nbr) THEN DO:
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '.' SKIP.
           PUT UNFORMAT '-' SKIP.
           PUT UNFORMAT '-' SKIP.
        END. /*  IF LAST-OF(tso_nbr) THEN DO: */
    END.
OUTPUT CLOSE.

batchrun = yes.
INPUT FROM VALUE(fn + ".bpi").
OUTPUT TO VALUE(fn + ".bpo").
{gprun.i ""sosomt.p""}
INPUT CLOSE .
OUTPUT CLOSE .
batchrun = NO.

assign chk = yes.
for each tmp-so exclusive-lock:
    if not can-find(first sod_det where sod_domain = global_domain and
                          sod_nbr = tso_nbr and sod_line = tsod_line and
                          sod_part = tsod_part and sod_qty_ord = tsod_qty_ord)
    then do:
       assign tsod_chk = "导入失败".
       chk = no.
    end.
	  else do:
	  	 assign tsod_chk = "导入成功".
	  end.
end.
if chk then do:
   os-delete VALUE(fn + ".bpi").
   os-delete VALUE(fn + ".bpo").
end.