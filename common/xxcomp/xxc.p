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
assign srcDir = "/home/qadfiy,".
assign destDir = "/home/qadfiy/p4shinetsu/us/zz".
propath = srcDir + propath.
compile value(src) save into value(destDir).
propath = substring(propath,length(srcDir) + 1).
*****************************************************************************/

{mfdtitle.i "25YA"}
{xxcompile.i "new"}
&SCOPED-DEFINE xxcomp_p_1 "SRC/XRC Directory"
&SCOPED-DEFINE xxcomp_p_2 "Compile File"
&SCOPED-DEFINE xxcomp_p_3 "To"
&SCOPED-DEFINE xxcomp_p_4 "Compile ProPath"
&SCOPED-DEFINE xxcomp_p_5 "Language Code"
&SCOPED-DEFINE xxcomp_p_6 "Destination Directory"

define variable vFileName  as character extent 3.
define variable qadkey1    as character initial "xxcomp.p.parameter" no-undo.
define variable bpropath   as character /*V8! bgcolor 15 */
                view-as editor size 50 by 7.
define variable filef      as character format "x(60)".
define variable filet      as character format "x(60)".
define variable del-yn     as logical.
define variable vClientDir as character no-undo.

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
   skip(1)
   destDir  colon 22 view-as fill-in size 50 by 1 label {&xxcomp_p_6}
with Frame z side-labels width 80.
setFrameLabels(Frame z:handle).

ON value-changed OF lng in frame z DO:
   IF LASTKEY = KEYCODE("u") OR LASTKEY = KEYCODE("U") then do:
      assign lng:screen-value in frame z = "us".
      assign lng.
   end.
   IF LASTKEY = KEYCODE("c") OR LASTKEY = KEYCODE("C") then do:
      assign lng:screen-value in frame z = "ch".
      assign lng.
   end.
   IF LASTKEY = KEYCODE("t") OR LASTKEY = KEYCODE("T") then do:
      assign lng:screen-value in frame z = "tw".
      assign lng.
   end.
end.

ON ENTRY of destDir in FRAME Z DO:
   status input "Ctrl-] to change default value.".
end.

ON LEAVE of destDir in FRAME Z DO:
   status input "".
end.

ON ENTRY of filef in FRAME Z DO:
   status input "Ctrl-] to get file list.".
end.
/*
ON LEAVE of filef in FRAME Z DO:
   assign filef.
   assign filet:screen-value = trim(filef) + hi_char.
   status input "".
END.
*/
ON Leave of filet in FRAME Z DO:
   assign filet.
   if index(filet,hi_char) = 0 then assign filet:screen-value = filet + hi_char.
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

/*
ON RETURN of xrcdir in frame z DO:
   assign xrcdir.
   assign xrcdir = lower(trim(xrcDir)).
   run setcomppropath.
   display bpropath with frame z.
end.
*/

ON "CTRL-]" OF fileF IN FRAME z DO:
  assign xrcdir.
  for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
           usrw_key1 = "xxvifile.p":
      delete usrw_wkfl.
  end.
  INPUT FROM OS-DIR(xrcdir).
  REPEAT:
      CREATE usrw_wkfl. {xxusrwdom.i}.
      IMPORT usrw_key4 usrw_key2 usrw_key5.
      assign usrw_key1 = "xxvifile.p"
             usrw_key3 = global_userid.
  END.
  INPUT CLOSE.
  for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
           usrw_key1 = "xxvifile.p" AND
           usrw_key5 <> "F":
      delete usrw_wkfl.
  end.
END.

ON "CTRL-]" of fileT in frame z do:
   APPLY "CTRL-]":u TO xrcDir.
END.

assign c-comp-pgms = getTermLabel("CAPS_COMPILE_PROGRAMS",20).
display c-comp-pgms with frame tx.
display xrcDir filef filet bproPath lower(lng) @ lng kbc_display_pause destdir
        with Frame z.
ENABLE  xrcDir filef filet bproPath lng kbc_display_pause destdir
        WITH Frame z.
{xxchklv.i 'MODEL-CAN-RUN' 10}
mainLoop:
repeat:
do on error undo, retry:
   update destDir xrcDir fileF fileT bpropath lng kbc_display_pause destdir
   go-on("F5" "CTRL-D") with Frame z.
   assign fileT = trim(fileT) + hi_char.
   if not can-find (first lng_mstr no-lock where lng_lang = lng) then do:
      {mfmsg.i 7656 3}
      next-prompt lng with frame z.
      undo,retry.
   end.
   if fileT < fileF then do:
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
 /*  if index(propath,destDir) = 0 then do:                                   */
 /*     message "Destination directory Error,Pleaes check propath setting!".  */
 /*     message "Destination directory must in propath list.".                */
 /*     next-prompt destDir with frame z.                                     */
 /*     undo,retry.                                                           */
 /*  end.                                                                     */
   assign xrcDir = lower(trim(xrcDir)).
   assign xrcdir destdir.
   run setcomppropath.
   display bpropath with frame z.
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
      del-yn = yes.
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=2 &CONFIRM=del-yn}
      if del-yn then do:
          clear frame z.
          os-delete utcompile.log no-error.
          os-delete utcompile.wrk no-error.
          for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                   usrw_key1 = qadkey1 and usrw_key2 = global_userid:
            delete usrw_wkfl.
          end.
          for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                   usrw_key1 = "xxvifile.p":
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
        if not locked(usrw_wkfl) then do:
           assign usrw_charfld[3] = filef
                  usrw_charfld[4] = trim(filet)
                  usrw_intfld[1] = kbc_display_pause.
           if opsys = "msdos" or opsys = "win32" then do:
              assign usrw_charfld[11] = xrcdir
                     usrw_charfld[12] = trim(destDir) when destDir <> ""
                                       and destDir <> vClientDir
                     usrw_charfld[15] = trim(destDir).
           end.
           else if opsys = "unix" then do:
              assign usrw_charfld[1] = xrcdir
                     usrw_charfld[2] = trim(destDir)
                                when destDir <> "" and destDir <> vClientDir
                     usrw_charfld[5] = trim(destDir).
           end.
        end.
        release usrw_wkfl.
    end.
end.

/*generate vworkfile.*/
empty temp-table tmpfile no-error.
input from OS-DIR(xrcDir).
repeat:
   import delimiter " " vFilename.
   if vFileName[3] = "F" and
      index(".p.w.t.P.W.T"
           ,substring(vFileName[1],length(vFileName[1]) - 1)) > 0 and
      vFileName[1] >= filef and (vFileName[1] <= filet or filet = "")
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
run setcomppropath.
{gprun.i ""xxc001.p""}
os-delete utcompile.log no-error.
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
           destDir = trim(usrw_charfld[5]) when usrw_charfld[5] <> ""
           filef = trim(usrw_charfld[3])
           filet = substring(usrw_charfld[4],1,length(usrw_charfld[4]) - 1)
           kbc_display_pause = usrw_intfld[1].
    if opsys = "msdos" or opsys = "win32" then do:
       assign xrcdir = usrw_charfld[11]
              destDir = trim(usrw_charfld[15]).
    end.
end.

assign xrcDir DestDir fileF filet kbc_display_pause.
assign lng = lower(global_user_lang).
run setcomppropath.

END PROCEDURE.  /* PROCEDURE iniForm: */

procedure setcomppropath:
   define variable vpropath as character.
   assign xrcdir = lower(trim(xrcDir)).
   assign destdir = lower(trim(destdir)).
   assign vpropath = replace(v_oldpropath,".,","").
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
   assign v_comppropath = bpropath.
   assign bProPath = replace(trim(propath),",",chr(10)).
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
            assign xrcDir = vdir + "/xrc"
                   DestDir = vDir
                   vClientDir = vDir
                   kbc_display_pause = 5.
            leave.
        end.
        ASSIGN vpropath = SUBSTRING(vpropath,INDEX(vpropath,",") + 1).
    END.
END PROCEDURE. /* PROCEDURE iniVar*/
