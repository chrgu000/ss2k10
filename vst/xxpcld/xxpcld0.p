/* xxptld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxpcld.i}
{xxloaddata.i}
define variable txt as character.
define variable i as integer.
empty temp-table xxtmppc no-error.
input from value(flhload).
repeat:
    import unformat txt.
    if entry(1,txt,",") <= "ZZZZZZZZZZZZ" and entry(1,txt,",") <> "" then do:
    	 create xxtmppc.
    	 assign xxpc_list = entry(1,txt,",") no-error.
 		 	 assign xxpc_curr = entry(2,txt,",") no-error.
			 assign xxpc_part = entry(3,txt,",") no-error.
			 assign xxpc_start = str2Date(entry(4,txt,","),"ymd") no-error.
			 assign xxpc_expir  = str2Date(entry(5,txt,","),"ymd") no-error.
			 assign xxpc_um  = entry(6,txt,",") no-error.
			 assign xxpc_user1 = entry(7,txt,",") no-error.
			 assign xxpc_amt = decimal(entry(8,txt,",")) no-error.
    end.
end.
input close.
assign i = 1.
for each xxtmppc exclusive-lock: 
	  assign xxpc_sn = i.
	  assign i = i + 1.
end.

/* check data */
for each xxtmppc exclusive-lock:
    find first pt_mstr no-lock where pt_part = xxpc_part no-error.
    if not available(pt_mstr) then do:
       assign xxpc_chk = getMsg(17).
    end.
    find first vd_mstr no-lock where vd_addr = xxpc_list no-error.
    if not available(vd_mstr) then do:
       assign xxpc_chk = getMsg(2).
    end.
end.
