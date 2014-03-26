/* xxpild3.p - xxpppimt.p cim load                            */
/*V8:ConvertMode=Report                                       */
/* Environment: Progress:10.1B QAD:eb21sp7 Interface:Character*/
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy           */
/* REVISION END                                               */
/**** 需求
1）金额类型：报价（List）
2）数量类型：数量
3）手工：Yes
4)其他字段取系统缺省设置
****/

{mfdeclre.i}
{xxpild.i}
define variable vfile as character.
define variable cfile as character.
define variable vchk as character no-undo.
define stream bf.
for each xxtmppi where xxpi_chk = "" by xxpi_sn:
    assign vfile = "TMP_" + execname + "." + string(xxpi_sn,"999999").
    output stream bf to value(vfile + ".bpi").
    put stream bf unformat '"' xxpi_list '" "' xxpi_cs '" "'
        xxpi_part '" "' xxpi_curr '" "' xxpi_um '" ' xxpi_start skip.
    put stream bf unformat xxpi_expir skip.
    put stream bf unformat '- '.

    FOR EACH lngd_det no-lock where lngd_dataset = "pi_mstr"
         and lngd_field = "pi_amt_type" and lngd_lang = GLOBAL_user_lang
         AND lngd_key1 = "1":           /* ref:mglngdmt.p */
         put stream bf unformat '"'  lngd_translation '" '.
    END.
    FOR EACH lngd_det no-lock where lngd_dataset = "pi_mstr"
         and lngd_field = "pi_qty_type" and lngd_lang = GLOBAL_user_lang
         AND lngd_key1 = "1":
         put stream bf unformat '"'  lngd_translation '" '.
    END.
    put stream bf ' - - - - - Y' skip.
    put stream bf unformat trim(string(xxpi_amt)) skip.
    output stream bf close.

    cimrunprogramloop:
    do transaction:
       input from value(vfile + ".bpi").
       output to value(vfile + ".bpo") keep-messages.
       hide message no-pause.
          batchrun = yes.
          {gprun.i ""xxpppimt.p""}
          batchrun = no.
       hide message no-pause.
       output close.
       input close.
       assign vchk = "".
       FIND FIRST pi_mstr NO-LOCK WHERE pi_domain = global_domain and
                  pi_list = xxpi_list and
                  (pi_cs_code = xxpi_cs or
                  (pi_cs_code = "qadall--+--+--+--+--+" and xxpi_cs = "")) and
                  pi_part_code = xxpi_part and
                  pi_curr = xxpi_curr and
                  pi_um = xxpi_um and
                  pi_start = xxpi_start no-error.
       if available pi_mstr then do:
          if pi_expire = xxpi_expir and
             pi_amt_type = "1" and
             pi_qty_type = "1" and
             pi_list_price = xxpi_amt then do:
             assign vchk = "OK".
             os-delete value(vfile + ".bpi").
             os-delete value(vfile + ".bpo").
          end.
          else do:
            vchk  = "".
            assign cfile = vfile + ".bpo".
            {gprun.i ""xxgetcimerr.p"" "(input cfile,output vchk)"}
             undo cimrunprogramloop,next.
          end.
       end.
       else do:
            vchk  = "".
            assign cfile = vfile + ".bpo".
            {gprun.i ""xxgetcimerr.p"" "(input cfile,output vchk)"}
            undo cimrunprogramloop,next.
       end.
   end.  /* do transaction:  */
   assign xxpi_chk = vchk.
end.
