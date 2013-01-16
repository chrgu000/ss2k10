/* xxptcld1.p - xxppctmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxpcld.i}
define variable vfile as character.
define variable vchk as character no-undo.
define stream bf.
for each xxtmppc where xxpc_chk = "" by xxpc_sn:
    assign vfile = execname + "." + string(xxpc_sn,"999999").
    output stream bf to value(vfile + ".bpi").
    put stream bf unformat '"' xxpc_list '" "' xxpc_curr '" - "'
        xxpc_part '" "' xxpc_um '" ' xxpc_start skip.
    put stream bf unformat xxpc_expir ' "' xxpc_user1 '" L' skip.
    put stream bf unformat trim(string(xxpc_amt)) skip.
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
       assign vchk = "".
       FIND FIRST pc_mstr NO-LOCK WHERE pc_list = xxpc_list and
                  pc_curr = xxpc_curr and pc_prod_line = "" and
                  pc_part = xxpc_part and pc_um = xxpc_um and
                  pc_start = xxpc_start no-error.
       if available pc_mstr then do:
          if pc_expire = xxpc_expir and pc_user1 = xxpc_user1 and
             pc_amt_type = "L" and pc_amt[1] = xxpc_amt then do:
             assign vchk = "OK".
             os-delete value(vfile + ".bpi").
             os-delete value(vfile + ".bpo").
          end.
          else do:
             assign vchk = "CIM Data Error!".
             undo cimrunprogramloop,next. 
          end.
       end.
       else do:
            assign vchk = "CIM FAIL".
            undo cimrunprogramloop,next. 
       end.
   end.  /* do transaction:  */
   assign xxpc_chk = vchk.
end.
