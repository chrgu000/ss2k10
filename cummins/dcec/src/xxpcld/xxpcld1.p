/* xxptld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxloaddata.i}
{xxpcld.i}
define variable i as integer.
define variable j as integer.

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

assign i = 0.
for each xxtmppc exclusive-lock break by xxpc_list by xxpc_part
      by xxpc_curr by xxpc_um by xxpc_start by xxpc_type:
      if first-of(xxpc_type) then do:
         assign i = i + 1.
         assign j = 1.
      end.
         assign xxpc_sn = i
                xxpc_sn1 = j.
         assign j = j + 1.
end.

