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
       assign xxpc_list = replace(entry(1,txt,","),'"',"") no-error.
       assign xxpc_curr = replace(entry(2,txt,","),'"',"") no-error.
       assign xxpc_part = replace(entry(3,txt,","),'"',"") no-error.
       assign xxpc_start = str2Date(replace(entry(4,txt,","),'"',""),"dmy") no-error.
       assign xxpc_expir = str2Date(replace(entry(5,txt,","),'"',""),"dmy") no-error.
       assign xxpc_um  = replace(entry(6,txt,","),'"',"") no-error.
       assign xxpc_amt = decimal(entry(7,txt,",")) no-error.
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
    find first pt_mstr no-lock where pt_domain = global_domain and
               pt_part = xxpc_part no-error.
    if not available(pt_mstr) then do:
       assign xxpc_chk = getMsg(17).
    end.
    find first vd_mstr no-lock where vd_domain = global_domain and
               vd_addr = xxpc_list no-error.
    if not available(vd_mstr) then do:
       assign xxpc_chk = getMsg(2).
    end.
end.
