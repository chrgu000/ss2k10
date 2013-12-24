/* xxptcld3.p - xxppctmt.p cim load                                          */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxpcld.i}
define variable vfile as character.
define variable i     as integer.
define variable cfile as character.
define variable vchk as character no-undo.
define stream bf.
for each xxtmppc where xxpc_chk = "" break by xxpc_sn by xxpc_sn1:
    if first-of(xxpc_sn) then do:
      assign vfile = execname + "." + string(xxpc_sn,"999999").
      output stream bf to value(vfile + ".bpi").
      put stream bf unformat '"' xxpc_list '" "' xxpc_curr '" - "'
          xxpc_part '" "' xxpc_um '" ' xxpc_start skip.
      put stream bf unformat xxpc_expir ' ' xxpc_type skip.
    end.
    else do:
      if xxpc_type = "P"  then put stream bf unformat ' '.
    end.
      if xxpc_type = "P" then do:
         put stream bf unformat trim(string(xxpc_min_qty)) ' '.
      end.
      put stream bf unformat trim(string(xxpc_amt)).
    if last-of(xxpc_sn) then do:
      put stream bf skip.
      output stream bf close.
      cimrunprogramloop:
      do transaction:
         input from value(vfile + ".bpi").
         output to value(vfile + ".bpo") keep-messages.
         hide message no-pause.
         batchrun = yes.
           {gprun.i ""xxpppcmt.p""}
         batchrun = no.
         hide message no-pause.
         output close.
         input close.
         os-delete value(vfile + ".bpi").
         os-delete value(vfile + ".bpo").
      end.
   end.
end.

for each xxtmppc exclusive-lock where xxpc_chk = "" break by xxpc_sn by xxpc_sn1:
    if first-of(xxpc_sn) then do:
       assign i = 1.
    end.
       FIND FIRST pc_mstr NO-LOCK WHERE pc_domain = global_domain and
                  pc_list = xxpc_list and
                  pc_curr = xxpc_curr and pc_prod_line = "" and
                  pc_part = xxpc_part and pc_um = xxpc_um and
                  pc_start = xxpc_start no-error.
       if available pc_mstr then do:
          if xxpc_type = "L" then do:
             if pc_amt[1] = xxpc_amt then do:
                assign xxpc_chk = "OK".
             end.
             else do:
                assign xxpc_chk = "Err".
             end.
          end.
          else do:
             if pc_min_qty[xxpc_sn1] = xxpc_min_qty and pc_amt[xxpc_sn1] = xxpc_amt then do:
                assign xxpc_chk = "OK".
             end.
             else do:
                assign xxpc_chk = "Err".
             end.
          end.
       end.
       else do:
          assign xxpc_chk = "Err".
       end.
end.
