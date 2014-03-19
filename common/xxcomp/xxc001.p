/* xxc001.p - COMPILATION PROGRAM  - modify from utcomp1.p                   */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 18YU LAST MODIFIED: 08/30/11 BY: zy fix log display bug         */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxcompile.i}
define variable incmf as logical.
define variable qadkey1   as character initial "xxcomp.p.parameter" no-undo.
define variable proc_name as character format "x(18)" label "File".
define variable proc_ver  as character format "x(10)".
define variable i         as integer   format ">>>9" label "PROCESSED".
define variable err       as integer   format ">>>9" label "Errors".
define variable rfile     as character format "x(24)".
define variable dirname   as character format "x(15)".
define variable yn        as logical.
define variable okProg    as character.
define variable c-comp    as character format "x(12)" no-undo.
define variable m0-comp   as character format "x(40)" no-undo.
define shared variable vtriggers as character format "x(30)" no-undo.
define shared variable cut_paste   as character format "x(70)" no-undo.
define shared variable vxref as logical no-undo.
define shared variable vLISTING as logical initial no no-undo.
define temp-table t_log
       fields tt_i as integer
       fields tt_j as integer
       fields tt_log as character
       index tt_i is primary tt_i
       index tt_j tt_j.
define stream crt.
define stream cmp.

assign c-comp = trim(getTermLabel("COMPILING",12)) + " ".

output stream crt to terminal.
output stream cmp to terminal.

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
   m0-comp no-label
with overlay frame m0 column 35 down no-labels
     title color normal (getFrameTitle("CAPS_COMPILE_PROGRAMS",25)) width 46.

hide all no-pause.
hide stream crt all no-pause.
hide stream cmp all no-pause.
view stream crt frame tt.
view stream crt frame a.
view stream crt frame b.
view stream cmp frame m0.
display c-comp-pgms with frame tt.

/*create .r dir*/
os-delete value(vWorkLog) no-error.
output to value(vWorkLog) append.
input from value(vWorkFile) no-echo no-map.
repeat:
  set proc_name.
  run createDestDir(input destDir, input lng, input proc_name).
end.
input close.
output close.

output to value(vWorkLog) append.
put unformat dbname " START:" today " " string(time,"hh:mm:ss") skip.
output close.
/* assign m0-comp = c-comp.          */
/* display m0-comp with frame m0.    */

i = 0.
err = 0.
input from value(vWorkFile) no-echo no-map.
assign incmf = no.
repeat:
   hide message no-pause.
   pause 0 no-message.

   set proc_name.
   assign i = i + 1.
   assign c-comp = trim(trim(getTermLabel("COMPILING",12)))
                 + substring(fill(".",20),1,i MODULO 20).
   hide frame m0.
   view frame m0.
   if substring(proc_name,1,2) = "mf" then assign incmf = yes.
/*   display stream cmp m0-comp with frame m0. */
   proc_ver = "".
   if opsys = "UNIX" then do:
      run getVer(input xrcDir + "/" + proc_name,output proc_ver).
   end.
   else if opsys = "msdos" or opsys = "win32" then do:
      run getVer(input xrcDir + "~\" + proc_name,output proc_ver).
   end.
   if proc_ver <> "" then assign cut_paste = proc_name.
   assign m0-comp = trim(proc_name) + " [v:" + proc_ver + "] ... ".
   if i <> 1 then do:
      down with frame m0.
      pause 0.
   end.
   display m0-comp + trim(getTermLabel("COMPILING",12)) @ m0-comp with frame m0.
   pause 0.
   run getDestFileName(input destDir, input lng, input proc_name,
                       output dirname).

   /* COMPILE PROCEDURE */
   {pxmsg.i &MSGNUM=4852 &ERRORLEVEL=1 &MSGARG1=proc_name}

   display stream crt trim(getTermLabel("COMPILING",12)) + "...." @ c-comp
                      proc_name with frame b.
   pause 0.
   down stream crt 1 with frame b.
   output to value(vWorkLog) append.
          put unformat "compile:" + proc_name + " Ver:" + proc_ver.
          if opsys = "unix" then do:
            put skip.
          end.
          else if opsys = "msdos" or opsys = "win32" then do:
            put " copy:".
          end.
          assign propath =xrcDir + "," + replace(bpropath,chr(10),",") when bpropath <> "".
          if vxref then do:
             if vLISTING then do:
                compile value(proc_name) no-attr-space save into value(".") xref value(proc_name + ".xref") LISTING value(proc_name + ".lst").
             end.
             else do:
                compile value(proc_name) no-attr-space save into value(".") xref value(proc_name + ".xref").
             end.
          end.
          else do:
             if vLISTING then do:
                compile value(proc_name) no-attr-space save into value(".")  LISTING value(proc_name + ".lst").
             end.
             else do:
                compile value(proc_name) no-attr-space save into value(".").
             end.
          end.
          assign propath = v_oldpropath.
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
      if proc_name <> "" then err = err + 1.
      assign m0-comp = m0-comp + trim(getTermLabel("COMPILE_ERROR",20)).
      display m0-comp with frame m0.
      pause 0.
   end.
   else do:
      if okprog = "" then assign okProg = proc_name.
                     else assign okProg = okProg + ";" + proc_name.
      assign m0-comp = m0-comp + trim(getTermLabel("COMPLETED",20)).
      display m0-comp with frame m0.
      pause 0.
   end.
   display stream crt i err with frame a.
   output to value(vWorkLog) append.
     if opsys = "unix" then do:
        unix silent value("cp " + rfile + " " + dirname).
     end.
     else if opsys = "msdos" or opsys = "win32" then do:
        dos silent value("copy " + rfile + " " + dirname).
     end.
     os-delete value(rfile) no-error.
   output close.
end.
assign propath = v_oldpropath.
input close.
hide message no-pause.
pause 0 no-message.

output to value(vWorkLog) append.
   put unformat dbname " END:" today " " string(time,"hh:mm:ss") skip.
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
input from value(vWorkLog).
i = 1.
repeat:
  create t_log.
  import delimiter "|" tt_log.
  assign tt_i = i.
  i = i + 1.
end.
input close.

for each t_log by tt_i descend:
    assign tt_j = tt_i.
    if (index(okprog,"compile:") > 0 or index(okprog,"END:") > 0) and
        index(tt_log,"compile:") > 0 then do:
       assign tt_j = 0.
    end.
    assign okprog = tt_log.
end.

assign okprog = "".
hide frame m0.
hide frame m.
hide frame n.
if err = 0 and kbc_display_pause <= 9 then do:
   for each t_log where tt_log <> "" with overlay frame m column 35
       title color normal (getFrameTitle("CAPS_COMPILE_PROGRAMS",25))
       no-labels width 46:
       display tt_log format "x(44)".
   end.
end.
else do:
   hide frame tt.
   hide frame a.
   hide frame b.
   for each t_log where tt_log <> "" and tt_j > 0 with overlay
       frame n column 1 title color
       normal(getFrameTitle("CAPS_COMPILE_PROGRAMS",25)) no-labels width 80
       by tt_j:
       if index(tt_log,"compile:") > 0 or index(tt_log,"END:") > 0 then do:
          display fill("-",78) @ tt_log.
          down with frame n.
       end.
       display tt_log format "x(78)".
   end.
end.

/* Compile complete */
   {pxmsg.i &MSGNUM=4853 &ERRORLEVEL=1}
   bell.

   if kbc_display_pause > 0 and err = 0 then pause kbc_display_pause.
   assign yn = no.
   if err > 0 or kbc_display_pause >= 10 then do:
          find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                     usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
          if available usrw_wkfl then do:
             assign yn = usrw_logfld[1].
          end.
      {pxmsg.i &MSGNUM=1723 &ERRORLEVEL=1 &CONFIRM=yn}
       find first usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                  usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
       if available usrw_wkfl then do:
          assign usrw_logfld[1] = yn.
       end.
       if yn then do:
          if opsys = "unix" then do:
             unix silent vi value(vWorkLog).
          end.
          if opsys = "msdos" or opsys = "win32" then do:
              dos silent notepad.exe value(vWorkLog).
           end.
       end.
   end.
   else do:
      if incmf then do:
          find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                     usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
          if available usrw_wkfl then do:
             assign yn = usrw_logfld[2].
          end.
         {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=yn}
       find first usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
              usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
       if available usrw_wkfl then do:
          assign usrw_logfld[2] = yn.
       end.
       if yn then do:
         quit.
       end.
      end.
   end.
   hide all no-pause.
   os-delete value(vWorkLog) no-error.
   os-delete value(vworkfile) no-error.

procedure createDestDir:
  define input parameter iDestDir as character.
  define input parameter ilng as character.
  define input parameter icompFile as character.

  define variable vdir as character.

  if substring(icompFile,length(icompFile) - 1,2) = ".t" then do:
     if opsys = "unix" then do:
        assign vdir = iDestDir + "/" + trim(vtriggers).
        FILE-INFO:FILE-NAME = vdir.
        if FILE-INFO:FILE-TYPE = ? then unix silent mkdir value(vdir).
     end.
     else if opsys = "msdos" or opsys = "win32" then do:
        assign vdir = destDir + "~\" + trim(vtriggers).
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
        odir = idestdir + "/" + trim(vtriggers).
     end.
     else if opsys = "msdos" or opsys = "win32" then do:
        odir = idestdir + "~\" + trim(vtriggers).
     end.
  end.
  else do:
     if substring(icompfile,1,2) = "mf" then do:
        if opsys = "unix" then do:
             odir = idestdir + "/"  + ilng.
        end.
        else if opsys = "msdos" or opsys = "win32" then do:
             odir = idestdir + "~\" + ilng.
        end.
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

procedure getVer:
  define input parameter iProc as character.
  define output parameter oVer as character.
  define variable txt as character.
  assign txt = "" oVer = "".
  input from value(iProc).
  repeat:
      import unformat txt.
      if index(txt,'~{') > 0 and
         index(txt,'}') > 0 and
         index(txt,'"') > 0 and
         index(txt,'mfdtitle.i') > 0 and
         index(txt,'*') = 0 then do:
         assign over = trim(ENTRY(2,txt,'"')) no-error.
         leave.
      end.
  end.
  input close.
end procedure.
