/* xxptcld1.p - xxppctmt.p cim load                                          */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxpcatld.i}
define variable vfile as character.
define variable vchk as character no-undo.
define variable fmv as character no-undo.
define stream bf.

for each xxtmppc where xxpc_chk = "" break by xxpc_file by xxpc_sn:
/*生效新的价格单*/
    assign vfile = execname + "." + string(xxpc_sn,"99999999").
    output stream bf to value(vfile + ".bpi").
    put stream bf unformat '"' xxpc_list '" "' xxpc_curr '" - "'
        xxpc_part '" "' xxpc_um '" ' xxpc_start skip.
    put stream bf unformat xxpc_expir ' "' xxpc_user1 '" L' skip.
    put stream bf unformat trim(string(xxpc_amt)) skip.
    output stream bf close.
    if first-of(xxpc_file) then do:
       assign fmv = "ok".
    end.

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
             assign vchk = "ok".
             os-delete value(vfile + ".bpi").
             os-delete value(vfile + ".bpo").
          end.
          else do:
             assign vchk = "CIM DATA ERROR!".
             undo cimrunprogramloop,next.
          end.
       end.
       else do:
            assign vchk = "CIM FAIL！".
            undo cimrunprogramloop,next.
       end.
   end.  /* do transaction:  */
   assign xxpc_chk = vchk.
end.

/*输出日志*/
for each xxtmppc no-lock break by xxpc_file by xxpc_sn:
    if first-of(xxpc_file) then do:
       output stream bf to value(sTxtDir + "/log/" + xxpc_file + ".log").
       put stream bf unformat 'VENDOR,CURR,ITEM,UNIT,START,END,NUMBER,PRICE' skip.
    end.
    export stream bf delimiter "," xxtmppc.
    if last-of(xxpc_file) then do:
       output stream bf close.
    end.
end.

/***将文件移动到指定的目录***/
for each xxtmppc no-lock break by xxpc_file:
    if first-of(xxpc_file) then do:
       assign fmv = "ok".
    end.
    if xxpc_chk <> "ok" then do:
       assign fmv = "err".
    end.
    if last-of(xxpc_file) then do:
          if fmv = "ok" then do:
             assign fmv = "mv " + sTxtDir + "/" + xxpc_file + " " + sTxtDir + "/" + fmv + "/".
          end.
          else do:
             for each code_mstr no-lock where code_fldname = "AX.QAD.Interface.MailList":
                 if fmv = "err" then do:
                    assign fmv = code_value.
                 end.
                 else do:
                    assign fmv = fmv + "," + code_value.
                 end.
             end.
             assign fmv = 'cat '+ sTxtDir + '/log/' + xxpc_file + '.log' + ' | mail -s "Pricelist AX vs QAD Error"' + ' ' + fmv.
          end.
          os-command silent value(fmv).
    end.
end.
