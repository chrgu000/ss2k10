/* xxcompil.p - COMPILATION PROGRAM  - modify from utcomp1.p                 */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 0BYJ LAST MODIFIED: 11/19/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */
{mfdeclre.i}
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

/*create .r dir*/
output to utcompil0.log.
input from value(vWorkFile) no-echo no-map.
repeat:
  set proc_name.
  run createDestDir(input destDir, input lng, input proc_name).
end.
input close.
output close.

output to "utcompil.log".
display dbname today string(time,"hh:mm:ss").
output close.
i = 0.
err = 0.
input from value(vWorkFile) no-echo no-map.
repeat:
   hide message no-pause.
   pause 0 no-message.

   set proc_name.
   assign i = i + 1.

   run getDestFileName(input destDir, input lng, input proc_name,
                       output dirname).

   /* COMPILE PROCEDURE */
   {pxmsg.i &MSGNUM=4852 &ERRORLEVEL=1 &MSGARG1=proc_name}

   display stream crt c-comp proc_name with frame b.
   pause 0.
   down stream crt 1 with frame b.
   output to "utcompil.log" append.
          put unformat "compile:" + proc_name skip.
          compile value(proc_name) no-attr-space save into value(destdir).
   output close.
/*    compile value(proc_name) save into value(dirname).*/
   if opsys = "unix" then do:
      assign rfile = destdir + "/"
                   + substring(proc_name , 1 ,index(proc_name,".")) + "r".
   end.
   else if opsys = "msdos" or opsys = "win32" then do:
      assign rfile = destdir + "\\"
                + substring(proc_name , 1 ,index(proc_name,".")) + "r".
   end.
   if search(rfile) = ? then do:
      if search(proc_name) <> ? then err = err + 1.
   end.
   display stream crt i err with frame a.
   output to utcompil0.log.
     if opsys = "unix" then do:
        unix silent value("mv " + rfile + " " + dirname).
     end.
     else if opsys = "msdos" or opsys = "win32" then do:
        dos silent value("copy " + rfile + " " + dirname).
        dos silent value("del " + rfile).
     end.
   output close.
end.
input close.

/* MOVE LAST .R FILES, APPLEHELP.R AND MF*.R
local-msg-arg = dirname + "*.r".
{pxmsg.i &MSGNUM=4851 &ERRORLEVEL=1 &MSGARG1=local-msg-arg}
local-msg-arg = "ap/applhelp.r, mf*.r".
{pxmsg.i &MSGNUM=4851 &ERRORLEVEL=1 &MSGARG1=local-msg-arg}
*/
hide message no-pause.
pause 0 no-message.
/* output to utdir.log.  */
/* {xxcompil.i}          */

output to utcompil0.log.
if opsys = "unix" then do:
   unix silent value("mv ap/applhelp.r .").
   unix silent value("mv src/mf*.r .").
end.
else if opsys = "msdos" or opsys = "win32" then do:
   dos silent value("copy ap~\applhelp.r applhelp.r").
   dos silent value("del ap~\applhelp.r").
   dos silent value("copy src~\mf*.r").
   dos silent value("del src~\mf*.r").
end.
output close.

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
hide all no-pause.

/*  os-delete comp.txt no-error.                   */
/*  os-delete comp.tmp no-error.                   */
/*  os-delete utdir.log no-error.                  */
    os-delete utcompil.log no-error.
    os-delete value(vworkfile) no-error.
    os-delete utcompil0.log no-error.

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

procedure createDestDir:
  define input parameter iDestDir as character.
  define input parameter ilng as character.
  define input parameter icompFile as character.

  define variable vdir as character.

  if substring(icompFile,length(icompFile) - 1,2) = ".t" then do:
     if opsys = "unix" then do:
        assign vdir = iDestDir + "/triggers".
        FILE-INFO:FILE-NAME = vdir.
        if FILE-INFO:FILE-TYPE = ? then unix silent mkdir value(vdir).
     end.
     else if opsys = "msdos" or opsys = "win32" then do:
        assign vdir = destDir + "\\triggers".
        FILE-INFO:FILE-NAME = vdir.
        if FILE-INFO:FILE-TYPE = ? then dos silent mkdir value(vdir).
     end.
  end.
  else do:
     if substring(icompfile,1,2) <> "mf" then do:
       if opsys = "unix" then do:
          assign vdir = iDestDir + "/" + ilng.
          FILE-INFO:FILE-NAME = vdir.
          if FILE-INFO:FILE-TYPE = ? then unix silent mkdir value(vdir).
          assign vdir = iDestDir + "/" + ilng + "/" + substring(icompfile,1,2).
          FILE-INFO:FILE-NAME = vdir.
          if FILE-INFO:FILE-TYPE = ? then unix silent mkdir value(vdir).
       end.
       else if opsys = "msdos" or opsys = "win32" then do:
          assign vdir = destDir + "\\" + ilng + "\\" + substring(icompfile,1,2).
          FILE-INFO:FILE-NAME = vdir.
          if FILE-INFO:FILE-TYPE = ? then dos silent mkdir value(vdir).
       end.
     end.
  end.
end procedure.

procedure getDestFileName:
  define input parameter iDestDir as character.
  define input parameter ilng as character.
  define input parameter icompFile as character.
  define output parameter odir as character.

  if substring(icompFile,length(icompFile) - 1,2) = ".t" then do:
     if opsys = "unix" then do:
        odir = idestdir + "/triggers".
     end.
     else if opsys = "msdos" or opsys = "win32" then do:
        odir = idestdir + "\\triggers".
     end.
  end.
  else do:
     if substring(icompfile,1,2) = "mf" then do:
            odir = idestdir.
     end.
     else do:
       if opsys = "unix" then do:
          odir = idestdir + "/"  + ilng + "/" + substring(icompfile,1,2).
       end.
       else if opsys = "msdos" or opsys = "win32" then do:
          odir = idestdir + "\\" + ilng + "\\" + substring(icompfile,1,2).
       end.
     end.
  end.
end procedure.
