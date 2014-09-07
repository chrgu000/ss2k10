/*Binary Dump/Load Program: Create binary dump/load scripts */
/*Enable Large File: proutil mfgprod -C enablelargefile     */
{mfdtitle.i "11YK"}
DEFINE VARIABLE dir-name AS CHARACTER view-as fill-in size 40 by 1
                format "x(120)" NO-UNDO initial "/mnt/hgfs/xrc/dl".
DEFINE VARIABLE dumpdb AS CHARACTER view-as fill-in size 40 by 1
                format "x(120)" NO-UNDO initial "/qad/2011se/db/mfgprod".
DEFINE VARIABLE loaddb AS CHARACTER view-as fill-in size 40 by 1
                format "x(120)" NO-UNDO initial "/qad/2011se/db/mfgtest".
DEFINE VARIABLE dumpfile as character view-as fill-in size 40 by 1
                format "x(120)" initial "dump.sh" no-undo.
define variable loadfile as character view-as fill-in size 40 by 1
                format "x(120)" initial "load.sh" no-undo.
DEFINE VARIABLE yfile as CHARACTER view-as fill-in size 40 by 1
                format "x(120)" NO-UNDO initial "TMP_yes.tmp".
DEFINE VARIABLE front-old AS CHARACTER NO-UNDO.
DEFINE VARIABLE front-new AS CHARACTER NO-UNDO.
DEFINE VARIABLE outstring AS CHARACTER NO-UNDO FORMAT "X(100)".
DEFINE VARIABLE delim AS CHARACTER NO-UNDO FORMAT "X(1)".
DEFINE VARIABLE tabls as CHARACTER view-as fill-in size 30 by 1
                format "x(120)" NO-UNDO.

define variable yn as logical initial no.
{xxtblst.i}

DEFINE STREAM dumpcmds.
DEFINE STREAM loadcmds.
form
   dumpdb   colon 20 label "Dump DB"
   loaddb   colon 20 label "Load DB"
   dumpfile colon 20 label "dump file"
   loadfile colon 20 label "load file"
   tabls colon 20 label "Selectd Table" "ALL/Key"
   dir-name colon 20 label "Dump diretory"
with frame a side-labels width 80 attr-space.
repeat with frame a:
display dumpdb loaddb dumpfile loadfile tabls dir-name.
update dumpdb loaddb dumpfile loadfile tabls dir-name.

if opsys = "unix" then do:
   ASSIGN delim = "/".
end.
else if opsys = "msdos" or opsys = "win32" then do:
   ASSIGN delim = "~\".
end.

OUTPUT STREAM dumpcmds TO value(yfile).
put stream dumpcmds "yes" skip.
OUTPUT STREAM dumpcmds close.

ASSIGN front-old = "proutil " + dumpdb
       front-new = "proutil " + loaddb.
   scroll_loopb:
   do on error undo,retry:
      empty temp-table tablst no-error.
         for each qaddb._File no-lock:
             create tablst.
             assign tab_name = _FILE-NAME
                    tab_desc = _File._desc.
             if tabls = "All" or index(tabls,_file-name) > 0
                or index(_file-name,tabls) > 0 then
                assign tab_sel = "*".
         end.
      {swselect.i
         &detfile      = tablst
         &scroll-field = tab_name
         &framename    = "selfld"
         &framesize    = 8
         &selectd      = yes
         &sel_on       = ""*""
         &sel_off      = """"
         &display1     = tab_sel
         &display2     = tab_name
         &display3     = tab_desc
         &exitlabel    = scroll_loopb
         &exit-flag    = "true"
         &record-id    = recid(tablst)
         }
         setFrameLabels(frame selfld:handle).

         message 'This operat will create dump and load scripts.Are you sure?' update yn.

     if keyfunction(lastkey) = "END-ERROR" or keyfunction(lastkey) = "F4"  then do:
        hide frame selfld.
        undo scroll_loopb, retry scroll_loopb.
     end.
   end.
      assign yn = no.
      if yn and can-find(first tablst no-lock where tab_sel = "*") then do:
          OUTPUT STREAM dumpcmds TO value(dumpfile).
          OUTPUT STREAM loadcmds TO value(loadfile).
          FOR EACH _file WHERE _file-num > 0 AND _file-num < 32768,
              each tablst no-lock where tab_name = _file-name and tab_sel = "*" :
              ASSIGN outstring = front-old + " -C dump " + _file-name + " " + dir-name.
              PUT STREAM dumpcmds outstring SKIP.
              ASSIGN outstring = front-new + " -C load " + dir-name
                               + delim + _file-name + ".bd < " + yfile.
              PUT STREAM loadcmds outstring SKIP.
          END.
          ASSIGN outstring = front-new + " -C idxbuild all".
          PUT STREAM loadcmds outstring SKIP.
          OUTPUT STREAM dumpcmds CLOSE.
          OUTPUT STREAM loadcmds CLOSE.
      end.
end.
