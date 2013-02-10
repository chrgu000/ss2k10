/* xxptld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxporcld.i}
{xxloaddata.i}
define variable txt as character.
define variable i as integer.
empty temp-table xxtmp no-error.
empty temp-table xxpo no-error.
input from value(flhload).
repeat:
    import unformat txt.
    if entry(1,txt,",") <= "ZZZZZZZZZZZZ" and entry(1,txt,",") <> "" then do:
       create xxtmp.
       assign xx_nbr = entry(1,txt,",") no-error.
       assign xx_part = entry(2,txt,",") no-error.
       assign xx_qty  = decimal(entry(3,txt,",")) no-error.
       assign xx_cost = decimal(entry(4,txt,",")) no-error.
       assign xx_pkg = entry(5,txt,",") no-error.
       assign xx_rc = entry(6,txt,",") no-error.
    end.
end.
input close.

for each xxtmp exclusive-lock:
    find first pod_det no-lock where pod_domain = global_domain
    			 and pod_nbr = xx_nbr and pod_part = xx_part
    			 and pod_qty_ord - pod_qty_rcvd = xx_qty and pod_pur_cost = xx_cost
    			 and not can-find(first xxpo where xxpo_nbr = pod_nbr and xxpo_line = pod_line) no-error.
    if available pod_det then do:
    	 assign xx_line = pod_line
    	        xx_site = pod_site
    	        xx_eff = date(1,31,2013).
    	 create xxpo.
    	 assign xxpo_nbr = pod_nbr
    	 				xxpo_line = pod_line.
    end.
    else do:
    	 assign xx_chk = "pod not found.".
    end.
end.
assign i = 1.
for each xxtmp exclusive-lock break by xx_nbr by xx_line:
    assign xx_sn = i.
    assign i = i + 1.
    find first pt_mstr no-lock where pt_part = xx_part no-error.
    if not available(pt_mstr) then do:
       assign xx_chk = getMsg(17).
    end.
    find first pod_det no-lock where pod_nbr = xx_nbr and pod_line = xx_line no-error.
    if available pod_det and pod_qty_ord - pod_qty_rcvd <> xx_qty then do:
       assign xx_chk = xx_chk + ";" + "ÊýÁ¿²»Æ¥Åä".
    end.
end.
