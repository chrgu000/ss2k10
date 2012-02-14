/* xxc001.p - COMPILATION PROGRAM  - modify from utcomp1.p                   */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 18YU LAST MODIFIED: 08/30/11 BY: zy fix log display bug         */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
define variable proc_name as character format "x(18)" label "File".
define variable i         as integer   format ">>>9" label "PROCESSED".
define variable err       as integer   format ">>>9" label "Errors".
define variable rfile     as character format "x(24)".
define variable dirname   as character format "x(15)".
define variable yn        as logical.
define variable c-comp    as character format "x(12)" no-undo.
define temp-table t_log   fields tt_log as character.
define stream crt.
define shared variable c-comp-pgms as character format "x(20)" no-undo.
define shared variable vWorkFile as character.
define shared variable destDir as character format "x(40)".
define shared variable lng     as character format "x(2)".
define shared variable kbc_display_pause as integer.
assign c-comp = getTermLabel("COMPILING",8) + " ".

output stream crt to terminal.

form c-comp-pgms at 12 with frame tt no-labels width 34.

form i space(1)
     err
with frame a side-labels width 34.
setFrameLabels(frame a:handle).

form
   c-comp no-label
   proc_name no-label
with frame b down no-labels width 34.

form
   c-comp format "x(40)"
with overlay frame m0 column 35 24 down
       title color normal (getFrameTitle("COMPILE_LOG",25)) no-labels width 46.

hide all no-pause.
hide stream crt all no-pause.
view stream crt frame tt.
view stream crt frame a.
view stream crt frame b.
view stream crt frame m0.
display c-comp-pgms with frame tt.

/*create .r dir*/
os-delete utcompile.log no-error.
output to utcompile.log append.
input from value(vWorkFile) no-echo no-map.
repeat:
  set proc_name.
  run createDestDir(input destDir, input lng, input proc_name).
end.
input close.
output close.

output to "utcompile.log" append.
put unformat dbname " START:" today " " string(time,"hh:mm:ss") skip.
output close.

display c-comp with frame m0.

i = 0.
err = 0.
input from value(vWorkFile) no-echo no-map.
repeat:
   hide message no-pause.
   pause 0 no-message.

   set proc_name.
   assign i = i + 1.

   display trim(c-comp) + substring(fill(".",30),1,i MODULO 30)
           @ c-comp with frame m0.
   run getDestFileName(input destDir, input lng, input proc_name,
                       output dirname).

   /* COMPILE PROCEDURE */
   {pxmsg.i &MSGNUM=4852 &ERRORLEVEL=1 &MSGARG1=proc_name}

   display stream crt c-comp proc_name with frame b.
   pause 0.
   down stream crt 1 with frame b.
   output to "utcompile.log" append.
          put unformat "compile:" + proc_name.
          if opsys = "unix" then do:
            put skip.
          end.
          else  if opsys = "msdos" or opsys = "win32" then do:
            put " copy:".
          end.
          compile value(proc_name) no-attr-space save into value(".").
   output close.
   if opsys = "unix" then do:
      assign rfile = "." + "/"
                   + substring(proc_name , 1 ,index(proc_name,".")) + "r".
   end.
   else if opsys = "msdos" or opsys = "win32" then do:
      assign rfile = "." + "~\"
                   + substring(proc_name , 1 ,index(proc_name,".")) + "r".
   end.
   if search(rfile) = ? then do:
      if search(proc_name) <> ? then err = err + 1.
   end.
   display stream crt i err with frame a.
   output to utcompile.log append.
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
hide message no-pause.
pause 0 no-message.

output to utcompile.log append.
   put unformat dbname " END:" today " " string(time,"hh:mm:ss").
   if err = 0 then do:
      put unformat skip(2).
      put unformat "********************************************" skip.
      put unformat "******           OO      KK  KK       ******" skip.
      put unformat "******         OO  OO    KK KK        ******" skip.
      put unformat "******         OO  OO    KKK          ******" skip.
      put unformat "******         OO  OO    KK KK        ******" skip.
      put unformat "******           OO      KK  KK       ******" skip.
      put unformat "********************************************" skip.
   end.
output close.

empty temp-table t_log no-error.
input from utcompile.log.
repeat:
  create t_log.
  import delimiter "|" tt_log.
end.
input close.

hide frame m0.
hide frame m.
hide frame n.
if err = 0 and kbc_display_pause <= 9 then do:
   for each t_log where tt_log <> "" with overlay frame m column 35
       title color normal (getFrameTitle("COMPILE_LOG",25)) no-labels width 46:
       display tt_log format "x(44)".
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

   if kbc_display_pause > 0 and err = 0 then pause kbc_display_pause.
   assign yn = no.
   if err > 0 or kbc_display_pause >= 10 then do:
      {pxmsg.i &MSGNUM=1723 &ERRORLEVEL=1 &CONFIRM=yn}
   end.
   if yn then do:
      if opsys = "unix" then do:
         unix silent vi utcompile.log.
      end.
      if opsys = "msdos" or opsys = "win32" then do:
          dos silent notepad.exe utcompile.log.
       end.
   end.
   hide all no-pause.
os-delete utcompile.log no-error.
os-delete value(vworkfile) no-error.

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
        assign vdir = destDir + "~\triggers".
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
          assign vdir = destDir + "~\" + ilng + "~\" + substring(icompfile,1,2).
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
        odir = idestdir + "~\triggers".
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
          odir = idestdir + "~\" + ilng + "~\" + substring(icompfile,1,2).
       end.
     end.
  end.
end procedure.