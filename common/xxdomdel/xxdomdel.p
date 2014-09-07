
DEFINE VARIABLE outstring AS CHARACTER NO-UNDO FORMAT "X(100)".
define variable vpath as character initial '/mnt/hgfs/xrc/'.
define variable log as character no-undo format "x(40)".
define variable dom as character no-undo.
define variable pfile as character no-undo.
define variable keepdom as character format "x(50)" no-undo.
DEFINE VARIABLE deldom  AS CHARACTER FORMAT "X(50)" no-undo.
define variable yn as logical initial no.

DEFINE STREAM deletecmds.
   form
      space(1)
      keepdom colon 20 label "Hold domain"
      deldom colon 20 label "Enable Del"
      log colon 20 label "logFile" skip(1)
      dom colon 20 label "Delete"
      yn colon 20 label "delete"
   with frame a1 side-labels width 80 attr-space.

repeat with frame a1:
   assign log = vpath + "TMP_deldomlog".
   assign dom = "" keepdom = "" deldom = "".
   for each dom_mstr no-lock where:
     if dom_active or dom_type = "system" then do:
        if keepdom = "" then keepdom = dom_domain.
                        else keepdom = keepdom + "," + dom_domain.
     end.
     else do:
          if deldom = "" then deldom = dom_domain.
             else deldom = deldom + "," + dom_domain.
          if dom = "" then assign dom = dom_domain.
     end.
   end.
   disp keepdom deldom log dom yn.
   update dom yn.
   find first dom_mstr no-lock where dom_domain = dom no-error.
   if not available dom_mstr then do:
      message "domain not exist" .
      undo,retry.
   end.
   else do:
      if lookup(dom,keepdom,",") > 0 or
         dom_active or
         dom_type = "system" then do:
           message "Domain " + dom + " can not be delete".
           undo,retry.
      end.
   end.

   if yn then
      pfile = vpath + "TMP_deldom_" + dom + "_del.p".
   else
      pfile = vpath + "TMP_deldom_" + dom + "_cnt.p".
   output STREAM deletecmds to value(pfile).

   ASSIGN outstring = "def var v_domain as char initial '" + dom + "'.".
   PUT STREAM deletecmds unformat outstring SKIP.
   ASSIGN outstring = "def var aaa as int.".
   PUT STREAM deletecmds unformat outstring SKIP.
   ASSIGN outstring = "def var ric as RECID.".
   PUT STREAM deletecmds unformat outstring SKIP.
   if yn then
      put stream deletecmds unformat "def var tpe as character initial 'Delete '." skip.
   else
      put stream deletecmds unformat "def var tpe as character initial 'Count '." skip.
   PUT STREAM deletecmds unformat "def stream bf." SKIP.
   ASSIGN outstring = "def var domain_dllog as char.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "def var v_msg as char.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "form domain_dllog colon 10 format 'x(60)' label 'Log' "
                    + " v_msg colon 10 format ""x(60)"" no-label with frame a side-label width 80.".
   PUT STREAM deletecmds unformat outstring skip .

   PUT STREAM deletecmds unformat "do with frame a:" skip.
   ASSIGN outstring = "domain_dllog = '" + log + "_' + v_domain" + " + '_'" + " + trim(tpe) + '.log'.".
   PUT STREAM deletecmds unformat outstring SKIP.
   PUT STREAM deletecmds unformat "display domain_dllog v_msg with frame a." skip.

   ASSIGN outstring = "output stream bf to value (domain_dllog).".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring =  "put  stream bf unformat string( today,""99/99/99"" ) "
                          + " + ' ' + string( time, ""HH:MM:SS"" ) + ' Start:' skip.".
   PUT STREAM deletecmds unformat outstring SKIP.

for each _field no-lock where _field-name matches "*_domain",
    each _file no-lock where _file-recid = recid(_file) and
         _file-num > 0 and _file-num < 32768
    break by _file-name:
   ASSIGN outstring  = "disable triggers for load of " + _file-name + ".".
   PUT STREAM deletecmds unformat outstring Skip.
   ASSIGN outstring  = "aaa = 0.".
   PUT STREAM deletecmds unformat outstring Skip.
   assign outstring = " do transaction:".
   PUT STREAM deletecmds unformat outstring SKIP.
   ASSIGN outstring = "for each " + _file-name.
   if yn then outstring = outstring + ' exclusive-lock '.
         else outstring = outstring + ' no-lock '.
   outstring = outstring + "where " + _file-name + "." + _field-name + " = v_domain:".
   PUT STREAM deletecmds unformat outstring SKIP.
   ASSIGN outstring  = "aaa = aaa + 1.".
   PUT STREAM deletecmds unformat outstring SKIP.

   if yn then
        PUT STREAM deletecmds unformat  "delete " + _file-name + "." SKIP.
   assign outstring = "v_msg = tpe + 'Tabel " + _file-name  + " ' ".
   assign outstring = outstring + " + string( aaa ) +  ' records '.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "display v_msg with frame a.".
   PUT STREAM deletecmds unformat outstring SKIP.

   assign outstring = "end."     .
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "end. /* do transaction:*/".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring =  "put stream bf unformat string(today,'99/99/99') "
                    + " + ' ' + string( time, ""HH:MM:SS"" ) + ' '.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "put stream bf unformat tpe 'Tabel " + _file-name + " ' aaa ' records' skip.".
   PUT STREAM deletecmds unformat outstring SKIP.
END.

   ASSIGN outstring  = "disable triggers for load of qtbl_ext .".
   PUT STREAM deletecmds unformat outstring Skip.
   ASSIGN outstring  = "aaa = 0.".
   PUT STREAM deletecmds unformat outstring Skip.
   assign outstring = "do transaction:".
   PUT STREAM deletecmds unformat outstring Skip.
   assign outstring = "for each qtbl_ext".
   if yn then outstring = outstring + ' exclusive-lock '.
         else outstring = outstring + ' no-lock '.
   assign outstring = outstring + "where qtbl_ext.qtbl_key1 = v_domain:".
   PUT STREAM deletecmds unformat outstring Skip.
   ASSIGN outstring  = "aaa = aaa + 1.".
   PUT STREAM deletecmds unformat outstring SKIP.
   if yn then
      PUT STREAM deletecmds unformat  "delete " + _file-name + "." SKIP.
   assign outstring = "v_msg = tpe + 'Tabel qtbl_ext ' ".
   assign outstring = outstring + " + string( aaa ) +  ' records '.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "display v_msg with frame a.".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "end. /* for each qtbl_ext */".
   PUT STREAM deletecmds unformat outstring SKIP.

   assign outstring = "end. /* do transaction */".
   PUT STREAM deletecmds unformat outstring SKIP.

   assign outstring =  "put stream bf unformat string( today,""99/99/99"" ) "
                    + " + ' ' + string( time, ""HH:MM:SS"" ) + ' '.".
   PUT STREAM deletecmds unformat outstring SKIP.

   assign outstring = "put stream bf unformat tpe 'Tabel qtbl_ext ' aaa ' records' skip.".
   PUT STREAM deletecmds unformat outstring SKIP.

   assign outstring =  "put  stream bf unformat string( today,""99/99/99"" ) "
                     + " + ' ' + string( time, ""HH:MM:SS"" ) + ' End:' skip.".
   PUT STREAM deletecmds unformat outstring SKIP.

   assign outstring = "output stream bf close."     .
   PUT STREAM deletecmds unformat outstring SKIP.
   PUT STREAM deletecmds unformat "end. /*do with frame a:*/" skip.
   put stream deletecmds unformat "hide frame a." skip.
   OUTPUT STREAM deletecmds CLOSE.

   run value(pfile).

end.
