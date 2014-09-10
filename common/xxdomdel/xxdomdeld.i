/*if {1} = "1" then leve dom_mstfr else delete dom_mstr.                      */

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
   ASSIGN outstring  = "disable triggers for load of " + _file-name + ".".
   PUT STREAM deletecmds unformat outstring Skip.
   ASSIGN outstring  = "assign aaa = 0.".
   PUT STREAM deletecmds unformat outstring Skip.
/**
   ASSIGN outstring = "for each " + _file-name.
   if yn then outstring = outstring + ' exclusive-lock '.
         else outstring = outstring + ' no-lock '.
   outstring = outstring + "where " + _file-name + "." + _field-name + " = v_domain:".
***/
   assign outstring = "repeat:".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "find first " + _file-name + ' exclusive-lock '.
   assign outstring = outstring + "where " + _file-name + "."
                    + _field-name + " = '" + dom + "' no-error.".
   PUT STREAM deletecmds unformat space(3) outstring SKIP.
   assign outString = 'if available ' + _file-name + ' then do:'.
   PUT STREAM deletecmds unformat space(3) outstring SKIP.
/*   assign outstring = "do transaction:".            */
/*   PUT STREAM deletecmds unformat outstring SKIP.   */
   PUT STREAM deletecmds unformat space(6) 'delete ' _file-name '.' SKIP.
   PUT STREAM deletecmds unformat space(6) 'release ' _file-name '.' skip.
/*   assign outstring = "end. /* do transaction:*/".  */
/*   PUT STREAM deletecmds unformat outstring SKIP.   */
   PUT STREAM deletecmds unformat space(6) "assign aaa = aaa + 1." SKIP.
   PUT STREAM deletecmds unformat space(6) 'assign cnt = cnt + 1.' skip.
   assign outstring = "v_msg = tpe + 'Tabel " + _file-name  + ": '".
   assign outstring = outstring + " + trim(string(aaa)) + '/' + trim(string(cnt)) + ' records.'.".
   PUT STREAM deletecmds unformat space(6) outstring SKIP.
   assign outstring = "if aaa mod 10 = 0 then display v_msg with frame a.".
   PUT STREAM deletecmds unformat space(6) outstring SKIP.
   assign outstring = "v_msg = tpe + 'Tabel " + _file-name  + ": '.".
   PUT STREAM deletecmds unformat space(6) outstring SKIP.
   assign outstring = "end.".
   PUT STREAM deletecmds unformat space(3) outstring SKIP.
   assign outstring = "else leave.".
   PUT STREAM deletecmds unformat space(3) outstring SKIP.
   assign outstring = "v_msg = tpe + 'Tabel " + _file-name  + ": '.".
   PUT STREAM deletecmds unformat "end. /*repeat*/" SKIP.
   assign outstring = "v_msg = v_msg + trim(string(aaa)) + '/' + trim(string(cnt)) + ' records.'.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "display v_msg with frame a.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "put stream bf unformat string(today,'99/99/99') "
                    + "' ' string(time,'HH:MM:SS') ' '.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "put stream bf unformat tpe 'Tabel " + _file-name
                    + ": ' trim(string(aaa)) '/' trim(string(cnt)) ' records.' skip.".
   PUT STREAM deletecmds unformat outstring SKIP(1).
END.