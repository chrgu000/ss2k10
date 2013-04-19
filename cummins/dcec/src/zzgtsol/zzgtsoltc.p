  {mfdeclre.i}
  {zzgtsolt.i}
  define stream bf.
  define variable rid as RECID.
  define variable zkacct like sod_acct initial "600202".
  find first code_mstr no-lock where code_domain = global_domain
         and code_fldname = "ZZGTSOL-ACCT" AND CODE_VALUE = "*" NO-ERROR.
  IF AVAILABLE CODE_MSTR THEN DO:
     ASSIGN ZKACCT = code_cmmt.
  END.
  for each sotax no-lock break by sotax_nbr by sotax_line desc:
      if first-of(sotax_nbr) then do:
        assign cimmfname = execname + "." + trim(sotax_nbr).
        output stream bf to value(cimmfname + ".bpi").
        put stream bf unformat '"' trim(sotax_nbr) '"' skip.
        put stream bf unformat "-" skip.
        put stream bf unformat "-" skip.
        put stream bf unformat "-" skip.
        put stream bf unformat "-" skip.
        put stream bf unformat "-" skip.
        put stream bf unformat "N - - - - - - - - - - N" skip.
        if sotax_part = "ZK" then do:
           put stream bf unformat "." skip.
           put stream bf unformat "S" skip.
           put stream bf unformat trim(string(sotax_line)) skip.
           find first sod_det no-lock where sod_domain = global_domain
                  and sod_nbr = sotax_nbr and sod_line = sotax_line no-error.
           if not available sod_det then do:
              put stream bf unformat '"' trim(sotax_part) '"' skip.
           end.
           put stream bf unformat "-" skip.
           put stream bf unformat "-1" skip.
           find first sod_det no-lock where sod_domain = global_domain
                  and sod_nbr = sotax_nbr and sod_line = sotax_line no-error.
           if available sod_det then do:
              put stream bf unformat "Y" skip.
           end.
           else do:
                put stream bf unformat "-" skip.
           end.
           if sotax_part = "ZK" then do:
                put stream bf unformat trim(string(abs(sotax_tot + sotax_tax))) skip.
           end.
           else do:
                put stream bf unformat trim(string(abs(sotax_tot))) skip.
           end.
           put stream bf unformat "-" skip.
           if sotax_desc1 = "" then do:
              put stream bf unformat "-" skip. /*物料无库存*/
           end.
           else do:
              put stream bf unformat '"' sotax_desc1 '"' skip. /*物料无库存*/
           end.
           put stream bf unformat '- - - - - "' trim(ZKACCT) '" "' trim(sotax_sub) '"' skip.
           put stream bf unformat "-" skip.
        end.
           put stream bf unformat "." skip.
           put stream bf unformat "." skip.
           put stream bf unformat "- - - - - - - Y" skip.
        end.
/*           if sotax_part = "ZK" then do:  */
              put stream bf unformat trim(string(sotax_line)) skip.
              put stream bf unformat trim(string(sotax_tot + sotax_tax,"->>>>>>>>>9.99")) " " trim(string(sotax_tot)) " " trim(string(sotax_tax)) skip.
/*           end.          */
           if last-of(sotax_nbr) then do:
           put stream bf unformat "." skip.
           put stream bf unformat '- - '.
               find first so_mstr no-lock where so_domain = global_domain
                      and so_nbr = sotax_nbr no-error.
               if available so_mstr and so_stat = "" then do:
                  put stream bf unformat '- '.
               end.
           put stream bf unformat '- - "' sotax_inv '" N Y' skip.

          output stream bf close.
          input from value(cimmfname + ".bpi").
          output to value(cimmfname + ".bpo").
          batchrun = yes.
             {gprun.i ""soivmt.p""}
          batchrun = no.
          output close.
          input close.
          os-delete value(cimmfname + ".bpi").
          os-delete value(cimmfname + ".bpo").
      end.
  end.
