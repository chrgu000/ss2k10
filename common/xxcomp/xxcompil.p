/* xxcompil.p - COMPILATION PROGRAM  - modify from utcomp1.p                 */
/* REVISION: 0BYJ LAST MODIFIED: 11/19/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "0BYJ"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define variable proc_name as character format "x(24)".
define variable i         as integer   format ">>>9" label "Files processed".
define variable err       as integer   format ">>>9" label "Errors".
define variable rfile     as character format "x(24)".
define variable pfile     as character format "x(24)".
/* define variable utdir     as character. */
define variable dirname   as character format "x(15)".
define variable yn        as logical.
/* define variable msg_temp  like msg_desc. */
define variable msg_tmp2  like msg_desc.
define variable msg_indx  as integer.
define variable c-comp    as character format "x(12)" no-undo.
define variable local-msg-arg as character format "x(24)" no-undo.
define variable vcompmsg      as character format "x(38)" no-undo.
define temp-table t_log   fields tt_log as character.
define stream crt.
define variable vtoDir as character.
define shared variable c-comp-pgms as character format "x(20)" no-undo.
define shared variable vWorkFile as character.
define shared variable destDir as character format "x(40)".
define shared variable lng     as character format "x(2)".

assign c-comp = getTermLabel("COMPILING",11) + " ".

output stream crt to terminal.

form c-comp-pgms at 12 with frame tt no-labels width 40.

form i space(2)
     err
with frame a side-labels width 40.
setFrameLabels(frame a:handle).

form
   c-comp no-label
   proc_name
with frame b down no-labels width 40.

hide all no-pause.
hide stream crt all no-pause.
view stream crt frame tt.
view stream crt frame a.
view stream crt frame b.
display c-comp-pgms with frame tt.

output to "utcompil.log".
input from value(vWorkFile) no-echo no-map.
display dbname today string(time,"hh:mm:ss").
i = 0.
err = 0.
repeat:
   hide message no-pause.
   pause 0 no-message.

   set proc_name.
   assign i = i + 1.

   /* FIND PROCEDURE AND SET .R FILE NAME */
   if search("src/" + proc_name) <> ? then do:
      proc_name = "src/" + proc_name.
   end.

   if index(proc_name,".p") > 0 then do:
      rfile = substring(proc_name,1,index(proc_name,".p") - 1) + ".r".
   end.
   else do:
      rfile = proc_name + ".r".
      if opsys = "msdos" or opsys = "win32" then
         proc_name = proc_name + ".p".
   end.

   /* MOVE .R FILES IF NECESSARY */
   pfile = proc_name.
   do while index(pfile,"/") > 0:
      pfile = substring(pfile,index(pfile,"/") + 1,24).
   end.

   if i = 1 then dirname = substring(pfile,1,2).

   if substring(pfile,1,2) <> dirname then do:
      local-msg-arg = dirname + "*.r".
      {pxmsg.i &MSGNUM=4851 &ERRORLEVEL=1 &MSGARG1=local-msg-arg}
      output to utdir.log.
      {xxcompil.i}
      output to utcompil.log append.
      dirname = substring(pfile,1,2).
   end.

   /* COMPILE PROCEDURE */
   {pxmsg.i &MSGNUM=4852 &ERRORLEVEL=1 &MSGARG1=proc_name}

   display stream crt c-comp proc_name with frame b.
   pause 0.
   down stream crt 1 with frame b.

   compile value(proc_name) no-attr-space save into value(destDir).
   if search(rfile) = ? then
      if search(proc_name) <> ? then err = err + 1.

   display stream crt i err with frame a.

end.
input close.
/* MOVE LAST .R FILES, APPLEHELP.R AND MF*.R */
local-msg-arg = dirname + "*.r".
{pxmsg.i &MSGNUM=4851 &ERRORLEVEL=1 &MSGARG1=local-msg-arg}
local-msg-arg = "ap/applhelp.r, mf*.r".
{pxmsg.i &MSGNUM=4851 &ERRORLEVEL=1 &MSGARG1=local-msg-arg}

hide message no-pause.
pause 0 no-message.
output to utdir.log.
{xxcompil.i}

if opsys = "unix" then do:
   unix silent value("mv ap/applhelp.r .").
   unix silent value("mv src/mf*.r .").
end.
else
   if opsys = "msdos" or opsys = "win32" then do:
   dos silent value("copy ap~\applhelp.r applhelp.r").
   dos silent value("del ap~\applhelp.r").
   dos silent value("copy src~\mf*.r").
   dos silent value("del src~\mf*.r").
end.

output to utcompil.log append.
  display string(time,"hh:mm:ss").
  if err = 0 then do:
     put unformat skip(2).
     put unformat "**************************************" skip.
     put unformat "******       OO      KK  KK     ******" skip.
     put unformat "******     OO  OO    KK KK      ******" skip.
     put unformat "******     OO  OO    KKK        ******" skip.
     put unformat "******     OO  OO    KK KK      ******" skip.
     put unformat "******       OO      KK  KK     ******" skip.
     put unformat "**************************************" skip.
  end.
output close.

empty temp-table t_log no-error.
input from utcompil.log.
repeat:
  create t_log.
  import delimiter "|" tt_log.
end.
input close.

hide frame m.
hide frame n.
if err = 0 then do:
   for each t_log where tt_log <> "" with overlay frame m column 41
       title color normal (getFrameTitle("COMPILE_LOG",25)) no-labels width 40:
       display tt_log format "x(38)".
   end.
end.
else do:
   hide frame tt.
   hide frame a.
   hide frame b.
   for each t_log where tt_log <> "" with overlay frame n column 1 title color
       normal(getFrameTitle("COMPILE_LOG",25)) no-labels width 80:
       display tt_log format "x(78)".
   end.
end.

/* Compile complete */
{pxmsg.i &MSGNUM=4853 &ERRORLEVEL=1}
bell.

assign yn = no.
{pxmsg.i &MSGNUM=1723 &ERRORLEVEL=1 &CONFIRM=yn}
if  yn then do:
   if opsys = "unix" then do:
      unix silent vi utcompil.log.
   end.
   if opsys = "msdos" or opsys = "win32" then do:
       dos silent notepad.exe utcompil.log.
    end.
end.
os-delete utdir.log no-error.
os-delete utcompil.log no-error.
os-delete value(vworkfile) no-error.
hide all no-pause.
/* if err > 0 then pause 100. */
/* else pause 2.              */
/* if err > 0 then do:                                                       */
/*    local-msg-arg = "utcompil.log".                                        */
/*    /* Error messages are listed in the file */                            */
/*    {pxmsg.i &MSGNUM=3796 &ERRORLEVEL=1 &MSGARG1=local-msg-arg}            */
/*    pause.                                                                 */
/* end. /* IF ERR > 0 */                                                     */
/* else                                                                      */
/*    pause 20.                                                              */
