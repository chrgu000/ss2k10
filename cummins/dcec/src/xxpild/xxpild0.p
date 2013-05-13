/* xxptld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxpild.i}
{xxloaddata.i}
define variable txt as character.
define variable i as integer.
empty temp-table xxtmppi no-error.
input from value(flhload).
repeat:
    import unformat txt.
    if entry(1,txt,",") <= "ZZZZZZZZZZZZ" and entry(1,txt,",") <> "" then do:
    	 create xxtmppi.
    	 assign xxpi_list = replace(entry(1,txt,","),'"',"") no-error.
    	 assign xxpi_cs   = replace(entry(2,txt,","),'"',"") no-error.
			 assign xxpi_part = replace(entry(3,txt,","),'"',"") no-error.     
 	     assign xxpi_curr = replace(entry(4,txt,","),'"',"") no-error.
 	     assign xxpi_um  = replace(entry(5,txt,","),'"',"") no-error.
			 assign xxpi_start = str2Date(replace(entry(6,txt,","),'"',""),"dmy") no-error.
			 assign xxpi_expir = str2Date(replace(entry(7,txt,","),'"',""),"dmy") no-error.
			 assign xxpi_amt = decimal(entry(8,txt,",")) no-error.
    end.
end.
input close.
assign i = 1.
for each xxtmppi exclusive-lock: 
	  assign xxpi_sn = i.
	  assign i = i + 1.
end.

/* check data */
for each xxtmppi exclusive-lock:
    find first pt_mstr no-lock where pt_domain = global_domain and
               pt_part = xxpi_part no-error.
    if not available(pt_mstr) then do:
       assign xxpi_chk = getMsg(17).
    end.
    if xxpi_cs <> "" then do:
       find first cm_mstr no-lock where cm_domain = global_domain and
                  cm_addr = xxpi_cs no-error.
       if not available(cm_mstr) then do:
          assign xxpi_chk = getMsg(3).
       end.
    end.
end.

/*
output to pi.txt.
FOR EACH pi_mstr NO-LOCK with width 400:
    DISPLAY pi_list pi_cs_code pi_part_code pi_curr pi_um pi_start pi_expir pi_list_price pi_amt_type pi_break_cat with stream-io.
END.
output close.
*/