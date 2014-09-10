/*if {1} = "1" then leve dom_mstr else delete dom_mstr.                      */

for each _field no-lock where _field-name matches "*_domain",
    each _file no-lock where _file-recid = recid(_file) and
         _file-num > 0 and _file-num < 32768
    break by _file-name:
    if {1} = "1" then do:
       if _file-name = "dom_mstr" then next.
    end.
    else do:
       if _file-name <> "dom_mstr" then next.
    end.
/*   ASSIGN outstring  = "disable triggers for load of " + _file-name + ".". */
/*   PUT STREAM deletecmds unformat outstring Skip.                          */
   ASSIGN outstring  = "assign aaa = 0.".
   PUT STREAM deletecmds unformat outstring Skip.
/*   assign outstring = "do transaction:".                                   */
/*   PUT STREAM deletecmds unformat outstring SKIP.                          */
   ASSIGN outstring = "for each " + _file-name + ' no-lock '.
   outstring = outstring + "where " + _file-name + "." + _field-name
             + " = '" + dom + "':".
   PUT STREAM deletecmds unformat outstring SKIP.
   PUT STREAM deletecmds unformat space(4) "assign aaa = aaa + 1." SKIP.
   PUT STREAM deletecmds unformat space(4) 'assign cnt = cnt + 1.' skip.
   /*
   if yn then
        PUT STREAM deletecmds unformat  "delete " + _file-name + "." SKIP.
   */
   assign outstring = "v_msg = tpe + 'Tabel " + _file-name  + ": '".
   assign outstring = outstring + " + trim(string(aaa)) + '/' + trim(string(cnt)) + ' records.'.".
   PUT STREAM deletecmds unformat space(4) outstring SKIP.
   assign outstring = "if aaa mod 10 = 0 then display v_msg with frame a.".
   PUT STREAM deletecmds unformat space(4) outstring SKIP.
   assign outstring = "v_msg = tpe + 'Tabel " + _file-name  + ": ' ".
   PUT STREAM deletecmds unformat "end." SKIP.
   assign outstring = outstring + "+ trim(string(aaa)) + '/' + trim(string(cnt)) + ' records.'.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "display v_msg with frame a.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "put stream bf unformat string(today,'99/99/99')"
                    + " ' ' string(time,'HH:MM:SS') ' '.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "put stream bf unformat tpe 'Tabel " + _file-name
                    + ": ' trim(string(aaa)) '/' trim(string(cnt)) ' records.' skip.".
   PUT STREAM deletecmds unformat outstring SKIP(1).
END.
