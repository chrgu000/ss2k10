/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxsoivimp.i}
FOR EACH TMP-SO EXCLUSIVE-LOCK :
    IF  TSO_NBR = '' OR tso_nbr = ? or tso_nbr > "ZZZZZZZZ" THEN DO:
        DELETE TMP-SO.
    END.
    ELSE DO:
           FIND FIRST cm_mstr NO-LOCK WHERE cm_domain = global_domain
           			  and cm_addr = tso_cust NO-ERROR.
           IF AVAILABLE cm_mstr THEN DO:
               ASSIGN vcurr = cm_curr.
           END.
           ELSE DO:
                 for first en_mstr
                   fields( en_domain en_curr en_entity en_name)
                    where en_mstr.en_domain = global_domain
                      and en_entity = current_entity
                   no-lock:
                 END.
                 IF AVAILABLE en_mstr THEN DO:
                     ASSIGN vcurr = en_curr.
                 END.
           END.
       IF tso_rmks = ? THEN ASSIGN tso_rmks = "-".

       IF tsod_acct = ? THEN do:
         ASSIGN tsod_acct = "-".
       END.
       IF index(tsod_acct,".") > 0 THEN DO:
           ASSIGN tsod_acct = substring(tsod_acct,1,index(tsod_acct,".") - 1).
       END.

       IF tsod_sub = ? THEN ASSIGN tsod_sub = "-".
       IF tsod_rmks1 = ? THEN ASSIGN tsod_rmks1 = "-".
       if tsod_site = ? and tso_site <> ? then assign tsod_site = tso_site.
    END.
END.

/* Check user data*/
for each tmp-so exclusive-lock:
    assign tsod_chk = "".
    if length(tso_nbr) > 8 then do:
       assign tsod_chk = "订单号长度大于8位限制;".
    end.
    if not can-find(first cm_mstr no-lock where cm_domain = global_domain
    			 and cm_addr = tso_cust) then do:
    	assign tsod_chk = tsod_chk + "客户" + tso_cust + "不存在;".
    end.
    if tso_cust <> tso_ship and (not can-find(first ad_mstr no-lock where ad_domain = global_domain
           and ad_addr = tso_ship and ad_type = "ship-to" and ad_ref = tso_cust)) then do:
       assign tsod_chk = tsod_chk + "交货地" + tso_ship + "错误;".
    end.
    if not can-find(pt_mstr no-lock where pt_domain = global_domain and
                    pt_part = tsod_part) then do:
       assign tsod_chk = tsod_chk + "料号 " + tsod_part + " 不存在;".
    end.
    if tsod_chk = "" then assign tsod_chk = "pass".
end.
