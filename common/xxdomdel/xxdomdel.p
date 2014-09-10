/* xxdomdel.p - domain delete.                                               */

DEFINE VARIABLE outstring AS CHARACTER NO-UNDO FORMAT "X(100)".
define variable vpath as character initial './'.
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
      deldom colon  20 label "Enable Del"
      log colon     20 label "LogFile" skip(1)
      dom colon     20 label "Domain"
      yn colon      20 label "Delete"
   with frame a1 side-labels width 80 attr-space.

repeat with frame a1:
   assign log = vpath + "TMP_deldomlog".
   assign dom = "" keepdom = "" deldom = "".
   for each dom_mstr no-lock where:
     if dom_active or dom_type = "system" then do:
        if keepdom = "" then keepdom = dom_domain.
        else do:
              if length(keepdom + "," + dom_domain) <= 49 then
              keepdom = keepdom + "," + dom_domain.
        end.
     end.
     else do:
          if deldom = "" then deldom = dom_domain.
          else do:
             if length(deldom + "," + dom_domain) <= 49 then
             deldom = deldom + "," + dom_domain.
          end.
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
      if (lookup(dom,keepdom,",") > 0 or dom_active or dom_type = "system")
       and yn then do:
           message "Domain " + dom + " can not be delete".
           undo,retry.
      end.
   end.

   if yn then
      pfile = vpath + "TMP_deldom_" + dom + "_del.p".
   else
      pfile = vpath + "TMP_deldom_" + dom + "_cnt.p".
   output STREAM deletecmds to value(pfile).

   ASSIGN outstring = "def var v_domain as character initial '" + dom + "'.".
   PUT STREAM deletecmds unformat outstring SKIP.
   ASSIGN outstring = "def var aaa as int.".
   PUT STREAM deletecmds unformat outstring SKIP.
   ASSIGN outstring = "def var cnt as int.".
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
/****
   assign outstring = "form domain_dllog colon 10 format 'x(60)' label 'Log' "
                    + " v_msg colon 10 format ""x(60)"" no-label with frame a side-label width 80.".
   PUT STREAM deletecmds unformat outstring skip .
****/
   put stream deletecmds unformat 'form' skip.
   put stream deletecmds unformat space(4) 'domain_dllog '.
   put stream deletecmds unformat 'colon 10 format "x(60)" label "Log"' skip.
   put stream deletecmds unformat space(4) 'v_msg colon 10 format "x(60)" no-label' skip.
   put stream deletecmds unformat 'with frame a side-label width 80.' skip(1).
   PUT STREAM deletecmds unformat "do with frame a:" skip.
   ASSIGN outstring = "domain_dllog = '" + log + "_' + v_domain" + " + '_'" + " + trim(tpe) + '.log'.".
   PUT STREAM deletecmds unformat outstring SKIP.
   PUT STREAM deletecmds unformat 'ASSIGN CNT = 0.' SKIP.
   PUT STREAM deletecmds unformat "display domain_dllog v_msg with frame a." skip.
   ASSIGN outstring = "output stream bf to value (domain_dllog).".
   PUT STREAM deletecmds unformat outstring SKIP.
   assign outstring = "put stream bf unformat string(today,'99/99/99')"
                    + " ' ' string(time,'HH:MM:SS')".
   if yn then outString = outstring + " ' Delete Domain [" + dom + "]'".
   assign outstring = outString + " ' Start:' skip.".
   PUT STREAM deletecmds unformat outstring SKIP(1).
    {xxdomqtbl.i}
   if yn then do:
     {xxdomdeld.i '1'} /*delete table except dom_mstr*/
     {xxdomdeld.i '2'} /*delete table dom_mstr*/
   end.
   else do:
      {xxdomdelc.i '1'}
      {xxdomdelc.i '2'}
   end.
   assign outstring = "put stream bf unformat string(today,'99/99/99')"
                    + " + ' ' + string( time, ""HH:MM:SS"" ) + ' End:' skip.".
   PUT STREAM deletecmds unformat outstring SKIP.
   PUT STREAM deletecmds unformat "end. /*do with frame a:*/" skip.
   put stream deletecmds unformat "hide frame a." skip.
   OUTPUT STREAM deletecmds CLOSE.
   run value(pfile).
end.
