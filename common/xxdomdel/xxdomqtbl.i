
   ASSIGN outstring  = "disable triggers for load of qtbl_ext.".
   PUT STREAM deletecmds unformat outstring Skip.
   ASSIGN outstring  = "aaa = 0.".
   PUT STREAM deletecmds unformat outstring Skip.

   assign outstring = "for each qtbl_ext".
   if yn then outstring = outstring + ' exclusive-lock '.
         else outstring = outstring + ' no-lock '.
   assign outstring = outstring + "where qtbl_ext.qtbl_key1 = v_domain:".
   PUT STREAM deletecmds unformat outstring Skip.
   ASSIGN outstring  = "Assign aaa = aaa + 1.".
   PUT STREAM deletecmds unformat space(4) outstring SKIP.
   if yn then
      PUT STREAM deletecmds unformat space(4) "delete qtbl_ext." SKIP.
   assign outstring = "v_msg = tpe + 'Tabel qtbl_ext: '".
   assign outstring = outstring + " + trim(string(aaa)) + '/'".
   PUT STREAM deletecmds unformat space(4) outstring SKIP.
   assign outstring = "+ trim(string(cnt)) + ' records.'.".
   PUT STREAM deletecmds unformat space(10) outstring SKIP.
   assign outstring = "if aaa mod 10 = 0 then display v_msg with frame a.".
   PUT STREAM deletecmds unformat space(4) outstring SKIP.
   assign outstring = "end. /* for each qtbl_ext */".
   PUT STREAM deletecmds unformat outstring SKIP.

   put stream deletecmds unformat 'assign cnt = cnt + aaa.' skip.
   assign outstring =  "put stream bf unformat string( today,""99/99/99"" ) ".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = " + ' ' + string( time, ""HH:MM:SS"" ) + ' '.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "put stream bf unformat tpe 'Tabel qtbl_ext: '"
                    + "trim(string(aaa)) '/' trim(string(cnt)) ' records.' skip.".
   PUT STREAM deletecmds unformat outstring SKIP(1).
