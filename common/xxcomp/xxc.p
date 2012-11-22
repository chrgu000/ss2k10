/* xxc.p - compile procedure                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

/**below program*************************************************************
define variable srcDir as character.
define variable destDir as character.
define variable src as character.
assign src = "/home/qadfiy/zzdivmt.p".
assign srcDir = "/home/qadfiy".
assign destDir = "/home/qadfiy/p4shinetsu/us/zz".
propath = srcDir + "," + propath.
compile value(src) save into value(destDir).
propath = substring(propath,length(srcDir) + 1).
*****************************************************************************/

{mfdtitle.i "2CY8"}
{xxcompile.i "new"}
&SCOPED-DEFINE xxcomp_p_1 "SRC/XRC Directory"
&SCOPED-DEFINE xxcomp_p_2 "Compile File"
&SCOPED-DEFINE xxcomp_p_3 "To"
&SCOPED-DEFINE xxcomp_p_4 "Compile ProPath"
&SCOPED-DEFINE xxcomp_p_5 "Language Code"
&SCOPED-DEFINE xxcomp_p_6 "xref"
&SCOPED-DEFINE xxcomp_p_7 "Destination Directory"

define variable vFileName  as character extent 3.
define variable qadkey1    as character initial "xxcomp.p.parameter" no-undo.
define variable xrcKey1    as character initial "xxcomp.p.xrcdir" no-undo.
define variable filef      as character format "x(60)".
define variable filet      as character format "x(60)".
define variable del-yn     as logical.
define variable vClientDir as character no-undo.
define variable vchkPath   as logical   no-undo.
define new shared variable vxref as logical initial no no-undo.

define temp-table tmpfile
  fields fn as CHARACTER
  index fn is primary fn.

assign v_oldpropath = propath.
run inivar.
run iniForm.

form c-comp-pgms at 28 with frame tx no-labels width 80.
setFrameLabels(Frame tx:handle).

form
   skip(.1)
   xrcDir   colon 22 view-as fill-in size 50 by 1 label {&xxcomp_p_1}
   SKIP(1)
   filef    colon 22 view-as fill-in size 22 by 1 label {&xxcomp_p_2}
   filet    colon 50 view-as fill-in size 22 by 1 label {&xxcomp_p_3}
   skip(1)
   bproPath colon 22 label {&xxcomp_p_4}
   skip(1)
   lng      colon 22 label {&xxcomp_p_5}
   kbc_display_pause colon 50
   vxref colon 60 label {&xxcomp_p_6}
   skip(1)
   destDir  colon 22 view-as fill-in size 50 by 1 label {&xxcomp_p_7}
with Frame z side-labels width 80.
setFrameLabels(Frame z:handle).

/* ON value-changed OF lng in frame z DO:                                     */
/*    IF LASTKEY = KEYCODE("u") OR LASTKEY = KEYCODE("U") then do:            */
/*       assign lng:screen-value in frame z = "us".                           */
/*       assign lng.                                                          */
/*    end.                                                                    */
/*    IF LASTKEY = KEYCODE("c") OR LASTKEY = KEYCODE("C") then do:            */
/*       assign lng:screen-value in frame z = "ch".                           */
/*       assign lng.                                                          */
/*    end.                                                                    */
/*    IF LASTKEY = KEYCODE("t") OR LASTKEY = KEYCODE("T") then do:            */
/*       assign lng:screen-value in frame z = "tw".                           */
/*       assign lng.                                                          */
/*    end.                                                                    */
/* end.                                                                       */

ON ENTRY of destDir in FRAME Z DO:
   status input "Ctrl-] to change default value.".
end.

ON LEAVE of destDir in FRAME Z DO:
   status input "".
end.

ON ENTRY of filef in FRAME Z DO:
   status input "Ctrl-] to get file list.".
end.

ON LEAVE of filef in FRAME Z DO:
   assign filef.
   assign filet:screen-value = trim(filef).
   assign filet.
   status input "".
END.

ON "CTRL-]" OF destDir IN FRAME z DO:
   assign destDir.
   if destDir <> vClientDir then do:
      assign destDir:screen-value = trim(vClientDir).
      assign destDir.
   end.
   else do:
       find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                  usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
       if available usrw_wkfl then do:
          if opsys = "unix" then do:
            assign destDir:screen-value = trim(usrw_charfld[2]).
          end.
          else if opsys = "msdos" or opsys = "win32" then do:
            assign destDir:screen-value = trim(usrw_charfld[12]).
          end.
          assign destDir.
       end.
       release usrw_wkfl.
   end.
end.

ON RETURN of xrcdir in frame z DO:
   assign xrcdir.
   assign xrcdir = lower(trim(xrcDir)).
   run setbpropath.
   display bpropath with frame z.
end.

ON CURSOR-UP of xrcdir in frame z do:
   assign xrcDir.
   find first usrw_wkfl no-lock where
           {xxusrwdom.i} {xxand.i}
            usrw_key1 = xrcKey1 and usrw_key2 = input xrcDir and
            usrw_key3 = opsys no-error.
   IF recid(usrw_wkfl) = ? THEN
      find first usrw_wkfl no-lock where
           {xxusrwdom.i} {xxand.i}
            usrw_key1 = xrcKey1 and usrw_key2 <= input xrcDir and
            usrw_key3 = opsys no-error.
   else do:
      if usrw_key2 = input xrcDir then
         find prev usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                   usrw_key1 = xrcKey1 and usrw_key2 <= input xrcDir and
                   usrw_key3 = opsys no-error.
      else
         find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                    usrw_key1 = xrcKey1 and usrw_key2 <= input xrcDir and
                    usrw_key3 = opsys no-error.
   end.
   if available usrw_wkfl then do:
      display usrw_key2 @ xrcDir
      			  trim(usrw_charfld[6]) @ filef
              trim(usrw_charfld[7]) @ filet
      			  with frame Z.
   end.

end.

ON CURSOR-DOWN of xrcdir in frame z do:
   assign xrcDir.
   find first usrw_wkfl no-lock where
           {xxusrwdom.i} {xxand.i}
            usrw_key1 = xrcKey1 and usrw_key2 = input xrcDir and
            usrw_key3 = opsys no-error.
   IF recid(usrw_wkfl) = ? THEN
      find first usrw_wkfl no-lock where
           {xxusrwdom.i} {xxand.i}
            usrw_key1 = xrcKey1 and usrw_key2 >= input xrcDir and
            usrw_key3 = opsys no-error.
    else do:
      if usrw_key2 = INPUT xrcDir then
         find next usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                   usrw_key1 = xrcKey1 and usrw_key2 >= input xrcDir and
                   usrw_key3 = opsys no-error.
      else
         find Last usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                    usrw_key1 = xrcKey1 and usrw_key2 >= input xrcDir and
                    usrw_key3 = opsys no-error.
   end.
   if available usrw_wkfl then do:
      display usrw_key2 @ xrcDir
      				trim(usrw_charfld[6]) @ filef
              trim(usrw_charfld[7]) @ filet
              with frame Z.
   end.
   APPLY LASTKEY.
   next-prompt xrcDir with frame z.
end.

   ON F9 of xrcdir in frame z do:
     APPLY "CURSOR-UP":U TO xrcdir .
   END.
/*                                                                           */
/* ON F10 of xrcdir in frame z do:                                           */
/*   APPLY "CURSOR-DOWN":U TO xrcdir IN FRAME Z.                             */
/* END.                                                                      */

ON "CTRL-]" OF fileF IN FRAME z DO:
  assign xrcdir.
  {gprun.i ""xxgetfilelst.p"" "(input xrcDir, input 50)"}
END.

ON "CTRL-]" of fileT in frame z do:
    assign xrcdir.
   {gprun.i ""xxgetfilelst.p"" "(input xrcDir, input 50)"}
END.

on "CTRL-]" of bPropath in frame z do:
   assign bpropath = replace(propath,",",chr(10)).
   run setbpropath.
   display bpropath with frame z.
end.

assign c-comp-pgms = getTermLabel("CAPS_COMPILE_PROGRAMS",20).
display c-comp-pgms with frame tx.
display xrcDir filef filet bproPath lower(lng) @ lng kbc_display_pause vxref
       destdir with Frame z.
ENABLE  xrcDir filef filet bproPath lng kbc_display_pause vxref destdir
        WITH Frame z.
{xxchklv.i 'MODEL-CAN-RUN' 10}
mainLoop:
repeat:
do on error undo, retry:
   update destDir xrcDir fileF fileT bpropath lng kbc_display_pause vxref destdir
   go-on("F5" "CTRL-D") with Frame z.
   if not can-find (first lng_mstr no-lock where lng_lang = lng) then do:
      {mfmsg.i 7656 3}
      next-prompt lng with frame z.
      undo,retry.
   end.
   if fileT + hi_char < fileF then do:
      {mfmsg.i 4479 9}
      next-prompt fileF with frame z.
      undo,retry.
   end.
   FILE-INFO:FILE-NAME = xrcDir.
   if FILE-INFO:FILE-TYPE = ? then do:
       status input "No such direction ,Please Try it again !".
       next-prompt xrcDir with frame z.
       undo,retry.
   end.
   FILE-INFO:FILE-NAME = destDir.
   if FILE-INFO:FILE-TYPE = ? then do:
       status input "No such direction ,Please Try it again !".
       next-prompt destDir with frame z.
       undo,retry.
   end.
   run checkBpropath(output vchkPath).
   if not vchkPath then do:
      status input "ProPath settings error ,Please Try it again !".
      next-prompt destDir with frame z.
      undo,retry.
   end.
   assign xrcDir = lower(trim(xrcDir)).
   assign xrcdir destdir.
   display bpropath with frame z.
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
      del-yn = yes.
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=2 &CONFIRM=del-yn}
      if del-yn then do:
          clear frame z.
          os-delete value(vWorkLog) no-error.
          os-delete value(vWorkFile) no-error.
          for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                   usrw_key1 = qadkey1 and usrw_key2 = global_userid:
            delete usrw_wkfl.
          end.
          for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                   usrw_key1 = "xxvifile.p":
            delete usrw_wkfl.
          end.
          for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                   usrw_key1 = xrcKey1 and usrw_key3 = opsys:
            delete usrw_wkfl.
          end.
          leave.
      end.
   end. /* if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") */

   if xrcdir <> "" and destdir <> "" then do:
      find first usrw_wkfl where {xxusrwdom.i} {xxand.i}
                 usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
           if not available usrw_wkfl then do:
              create usrw_wkfl.
              assign
                 {xxusrwdom.i}
                 usrw_key1 = qadkey1
                 usrw_key2 = global_userid.
           end.
           run recordUsrwwkfl.
      find first usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                 usrw_key1 = xrcKey1 and usrw_key2 = xrcDir no-error.
           if not available usrw_wkfl then do:
              create usrw_wkfl.
              assign {xxusrwdom.i}
                     usrw_key1 = xrcKey1
                     usrw_key2 = xrcDir.
           end.
              assign usrw_key3 = opsys.
           run recordUsrwWkfl.
    end. /* if xrcdir <> "" and destdir <> "" then do: */

end.

/*generate vworkfile.*/
empty temp-table tmpfile no-error.
input from OS-DIR(xrcDir).
repeat:
   import delimiter " " vFilename.
   if vFileName[3] = "F" and
      index(".p.w.t.P.W.T"
           ,substring(vFileName[1],length(vFileName[1]) - 1)) > 0 and
      vFileName[1] >= filef and (vFileName[1] <= filet + hi_char)
   then do:
      create tmpfile.
      assign fn = vFileName[1].
   end.
end.
input close.

output to value(vWorkFile).
  for each tmpfile no-lock by fn:
      export fn.
  end.
output close.
assign bpropath.
{gprun.i ""xxc001.p""}
os-delete value(vWorkLog) no-error.
os-delete value(vworkfile) no-error.
leave.
end. /*mainLoop*/

PROCEDURE iniForm:
    define variable vDir as character.
    define variable vpropath as character.
    /*read form variabls from usrw_wkfl*/
    find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
               usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
    if available usrw_wkfl then do with frame z:
        assign xrcdir = trim(usrw_charfld[1]) when usrw_charfld[1] <> ""
               bpropath = usrw_charfld[3] when usrw_charfld[3] <> ""
               destDir = trim(usrw_charfld[5]) when usrw_charfld[5] <> ""
               filef = trim(usrw_charfld[6])
               filet = trim(usrw_charfld[7])
               kbc_display_pause = usrw_intfld[1]
               vxref = usrw_logfld[1].
        if opsys = "msdos" or opsys = "win32" then do:
           assign xrcdir = usrw_charfld[11]
                  bpropath = usrw_charfld[13]
                  destDir = trim(usrw_charfld[15]).
        end.
    end.
    assign xrcDir DestDir fileF filet kbc_display_pause vxref.
    assign lng = lower(global_user_lang).
    if bpropath = "" then do:
       assign bpropath = replace(v_oldpropath,",",chr(10)).
    end.
    run setbpropath.
END PROCEDURE.  /* PROCEDURE iniForm: */

procedure setbpropath:
    define variable vpropath as character.
    assign xrcdir = lower(trim(xrcDir)).
    assign destdir = lower(trim(destdir)).
    assign vpropath = replace(replace(bpropath,chr(10),","),".,","").
    if index(vpropath,xrcdir) <> 0 and xrcdir <> "" then do:
       assign vpropath = trim(replace(vpropath,xrcdir + ",","")).
    end.
    if index(vpropath,destdir) <> 0 and destdir <> "" then do:
       assign vpropath = trim(replace(vpropath,destdir + ",","")).
    end.
    if xrcdir <> "" and destdir <> "" then do:
         assign bpropath = xrcdir + "," + destdir + ",.," + vpropath.
         if destDir = "." then
            assign v_incdestpropath = ".," + vpropath.
         else
            assign v_incdestpropath = destDir + ",.," + vpropath.
    end.
    assign bProPath = replace(trim(bpropath),",",chr(10)).
end procedure.

PROCEDURE iniVar:
/* -----------------------------------------------------------
   Purpose: initial variable vClientDir.
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
    define variable vdir as character no-undo.
    define variable vpropath as character no-undo.
    define variable vverfile as character no-undo.
    define variable vlocfile as character no-undo.
    if opsys = "unix" then do:
      assign v_DirSepChr = "/".
    end.
    else if opsys = "msdos" or opsys = "win32" then do:
      assign v_DirSepChr = "~\".
    end.
    assign vpropath = trim(v_oldpropath).
    /* read mfgutil.ini */
    DO WHILE index(vpropath,",") > 0:
        ASSIGN vdir = substring(vpropath,1,INDEX(vpropath,",") - 1).
        assign vverfile = vdir + v_DirSepChr + "version.mfg"
               vlocfile = vdir + v_DirSepChr + "locale.dat".
        if search(vverfile) <> ? and
           search(vlocfile) <> ? then do:
            assign xrcDir = vdir + v_DirSepChr + "xrc"
                   DestDir = vDir
                   vClientDir = vDir
                   kbc_display_pause = 5.
            leave.
        end.
        ASSIGN vpropath = SUBSTRING(vpropath,INDEX(vpropath,",") + 1).
    END.
END PROCEDURE. /* PROCEDURE iniVar*/

procedure checkBpropath:
    define output parameter oresult as logical.
    assign oresult = yes.
    define variable vpath as character.
    define variable vbpath as character.
    assign vbpath = bpropath.
    do while index(vbpath,chr(10)) > 0:
       assign vpath = substring(vbpath,1,index(vbpath,chr(10)) - 1).
       vbpath = substring(vbpath,index(vbpath,chr(10)) + 1).
       FILE-INFO:FILE-NAME = vpath.
       if FILE-INFO:FILE-TYPE = ? and search(vpath) = ? then do:
          message "Propath settings error!" skip(1) vpath
                  view-as alert-box.
          oresult = no.
          leave.
       end.
    end.
end procedure.

procedure recordUsrwWkfl:
/*	assign filef filet kbc_display_pause vxref bpropath destDir in frame z. */
  if not locked(usrw_wkfl) then do:
      assign usrw_key5 = string(today,"9999-99-99") + " "
                       + string(time,"HH:MM:SS")
             usrw_charfld[6] = filef
             usrw_charfld[7] = replace(filet,"hi_char","")
             usrw_intfld[1] = kbc_display_pause
             usrw_logfld[1] = vxref.
      if opsys = "msdos" or opsys = "win32" then do:
         assign usrw_charfld[11] = xrcdir
                usrw_charfld[12] = trim(destDir) when destDir <> ""
                                  and destDir <> vClientDir
                usrw_charfld[13]  = bpropath
                usrw_charfld[15] = trim(destDir).
      end.
      else if opsys = "unix" then do:
         assign usrw_charfld[1] = xrcdir
                usrw_charfld[2] = trim(destDir)
                           when destDir <> "" and destDir <> vClientDir
                usrw_charfld[3] = bpropath
                usrw_charfld[5] = trim(destDir).
       end.
   end.
   release usrw_wkfl.
end Procedure.
