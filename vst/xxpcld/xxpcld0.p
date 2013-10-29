/* xxpcld.p - xxpppcmt.p cim load                                            */
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
define variable dte as date.
empty temp-table xxtmppc0 no-error.
empty temp-table xxtmppc no-error.
input from value(flhload).
repeat:
    import unformat txt.
    if entry(4,txt,",") <= "ZZZZZZZZZZZZ" and entry(4,txt,",") <> "" then do:
       create xxtmppc0.
       assign x0pc_axvd = entry(4,txt,",") no-error.
       assign x0pc_curr = entry(12,txt,",") no-error.
       assign x0pc_part = entry(6,txt,",") no-error.
       assign x0pc_start = str2Date(entry(18,txt,","),"ymd") no-error.
       assign x0pc_expir = str2Date(entry(19,txt,","),"ymd") no-error.
       assign x0pc_axum  = entry(22,txt,",") no-error.
       assign x0pc_user1 = entry(2,txt,",") no-error.
       assign x0pc_amt = decimal(entry(8,txt,",")) no-error.
    end.
end.
input close.

assign i = 1.
for each xxtmppc0 exclusive-lock:
    assign x0pc_sn = i.
    assign i = i + 1.
end.

/* check data */
for each xxtmppc0 exclusive-lock:
    find first pt_mstr no-lock where pt_part = x0pc_part no-error.
    if available(pt_mstr) then do:
       assign x0pc_um = pt_um.
    end.
    else do:
       assign x0pc_chk = getMsg(17).
    end.
    find first usrw_wkfl no-lock where usrw_key1 = "AX_QAD_VENDOR_REFERENCE"
           and usrw_key2 = x0pc_axvd no-error.
    if available usrw_wkfl then do:
       assign x0pc_list = usrw_key3.
    end.
    else do:
       assign x0pc_chk = getMsg(2) + "-xxvdaxref.p".
    end.
    find first vd_mstr no-lock where vd_addr = x0pc_list no-error.
    if available(vd_mstr) then do:
       assign x0pc_sort = vd_sort.
    end.
    else do:
        assign x0pc_chk = getMsg(2).
    end.
end.

assign i = 1.
for each xxtmppc0 no-lock:
/*失效旧的价格单*/
    assign dte = x0pc_start - 1.
    for each pc_mstr no-lock where pc_list = x0pc_list and
             pc_curr = x0pc_curr and pc_prod_line = "" and
             pc_part = x0pc_part and pc_um = x0pc_um and pc_amt_type = "L"
        break by pc_start descending:
        if pc_start <> x0pc_start and (pc_expir = ? or pc_expir <> dte) then do:
           create xxtmppc.
           assign xxpc_axvd  = x0pc_axvd
                  xxpc_list  = pc_list
                  xxpc_curr  = pc_curr
                  xxpc_part  = pc_part
                  xxpc_start = pc_start
                  xxpc_expir = dte
                  xxpc_um    = pc_um
                  xxpc_axum  = x0pc_axum
                  xxpc_user1 = pc_user1
                  xxpc_amt   = pc_amt[1]
                  xxpc_sort  = x0pc_sort.
        end.
        dte = pc_start - 1.
    end.
/*生效新价格*/
    create xxtmppc.
    assign xxpc_axvd  = x0pc_axvd
           xxpc_list  = x0pc_list
           xxpc_curr  = x0pc_curr
           xxpc_part  = x0pc_part
           xxpc_start = x0pc_start
           xxpc_expir = x0pc_expir
           xxpc_axum  = x0pc_axum
           xxpc_um    = x0pc_um
           xxpc_user1 = x0pc_user1
           xxpc_amt   = x0pc_amt
           xxpc_sort  = x0pc_sort
           xxpc_chk   = x0pc_chk.
end.
assign i = 1.
for each xxtmppc exclusive-lock:
    assign xxpc_sn = i.
    assign i = i + 1.
end.
