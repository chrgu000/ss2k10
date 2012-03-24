/* xxc.p - compile procedure                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10 BY: zy language be lower case      */
/* REVISION: 14YP LAST MODIFIED: 04/25/11 BY: zy Add EB common            *EB*/
/* REVISION: 19Y2 LAST MODIFIED: 09/02/11 BY: zy fix mfgutil.ini get methed  */
/* REVISION: 19YG LAST MODIFIED: 09/16/11 BY: zy auto fill filet text        */
/* REVISION: 21YA LAST MODIFIED: 01/10/12 BY: zy save variable to usrw_wkfl  */
/* REVISION END                                                              */

{mfdtitle.i "23YA"}

&SCOPED-DEFINE xxcomp_p_1 "SRC/XRC Directory"
&SCOPED-DEFINE xxcomp_p_2 "Compile File"
&SCOPED-DEFINE xxcomp_p_3 "To"
&SCOPED-DEFINE xxcomp_p_4 "Compile ProPath"
&SCOPED-DEFINE xxcomp_p_5 "Language Code"
&SCOPED-DEFINE xxcomp_p_6 "Destination Directory"

define new shared variable c-comp-pgms as character format "x(20)" no-undo.
define new shared variable vWorkFile   as character initial "utcompile.wrk".
define new shared variable destDir     as character format "x(50)".
define new shared variable lng         as character format "x(2)".
define new shared variable kbc_display_pause as integer initial 1 format ">9".
define variable vFileName  as character extent 3.
define variable qadkey1    as character initial "xxcomp.p.parameter" no-undo.
define variable xrcDir     as character format "x(50)" no-undo.
define variable vpropath   as character.
define variable bpropath   as character /*V8! bgcolor 15 */
                view-as editor size 50 by 7.
define variable filef      as character format "x(22)".
define variable filet      as character format "x(22)".
define variable vClientDir as character no-undo.
define temp-table tmpfile
  fields fn as CHARACTER
  index fn is primary fn.

run inivar.
run iniForm.

form c-comp-pgms at 28 with frame tx no-labels width 80.
setFrameLabels(Frame tx:handle).

{xxchklv.i execname 300}

form
   skip(.1)
   xrcDir   colon 22 label {&xxcomp_p_1}
   SKIP(1)
   filef    colon 22 label {&xxcomp_p_2}
   filet    colon 50 label {&xxcomp_p_3}
   skip(1)
   bproPath colon 22 label {&xxcomp_p_4}
   skip(1)
   lng      colon 22 label {&xxcomp_p_5}
   kbc_display_pause colon 50
   skip(1)
   destDir  colon 22 label {&xxcomp_p_6}
with Frame z side-labels width 80.
setFrameLabels(Frame z:handle).

on value-changed of lng in frame z do:
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
on Entry of destDir in frame z do:
   status input "Ctrl-] to change default value.".
end.
on Leave of destDir in frame z do:
   status input "".
end.
ON Leave of filef in FRAME Z DO:
   assign filef.
   assign filet:screen-value = filef + hi_char.
END.

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

ON "F5" of destDir in Frame Z Do:
   apply "CTRL-D":U to destDir.
END.

ON "CTRL-D" OF destDir IN FRAME z DO:
   define variable yn as logical.
   assign yn = no.
   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=2 &CONFIRM=yn}
   if yn then do:
       find first usrw_wkfl where {xxusrwdom.i} {xxand.i}
                  usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
       if available usrw_wkfl then do:
          assign usrw_charfld[1] = ""
                 usrw_charfld[2] = ""
                 usrw_charfld[3] = ""
                 usrw_charfld[4] = ""
                 usrw_charfld[5] = ""
                 usrw_charfld[11] = ""
                 usrw_charfld[12] = ""
                 usrw_charfld[13] = ""
                 usrw_charfld[14] = ""
                 usrw_charfld[15] = ""
                 usrw_intfld[1] = 0.
          delete usrw_wkfl.
       end.
       assign xrcDir = ""
              destDir = ""
              filef = ""
              filet = ""
              lng = lower(global_user_lang)
              kbc_display_pause = 0.
       clear frame z.
   end.
END.

on RETURN of xrcdir in frame z do:
   assign xrcdir.
   assign xrcdir = lower(trim(xrcDir)).
   FILE-INFO:FILE-NAME = xrcdir.
   if FILE-INFO:FILE-TYPE <> "DRW" then do:
      message "Directory [" + xrcdir + "] not found!".
      next-prompt xrcDir with frame z.
      undo,retry.
   end.
   else do:
      message "".
      run setpropath.
      assign bpropath = replace(trim(bpropath),",",chr(10)).
   end.
   display bpropath with frame z.
end.

ON "CTRL-]" OF xrcdir IN FRAME z /* Fill 1 */
DO:
  assign xrcdir.
  for each usrw_wkfl exclusive-lock where usrw_key1 = "xxvifile.p":
      delete usrw_wkfl.
  end.
/*  if xrcdir = "" then assign xrcdir:screen-value = ".". */
  assign xrcdir.
  INPUT FROM OS-DIR(xrcdir).
  REPEAT:
      CREATE usrw_wkfl.
      IMPORT usrw_key4 usrw_key2 usrw_key5.
      assign usrw_key1 = "xxvifile.p"
             usrw_key3 = global_userid.
  END.
  INPUT CLOSE.

  for each usrw_wkfl exclusive-lock where usrw_key1 = "xxvifile.p"
       and usrw_key5 <> "F":
      delete usrw_wkfl.
  end.
END.

assign c-comp-pgms = getTermLabel("CAPS_COMPILE_PROGRAMS",20).
display c-comp-pgms with frame tx.
display xrcDir filef filet bproPath lower(lng) @ lng kbc_display_pause destdir
        with Frame z.
ENABLE  xrcDir filef filet bproPath lng kbc_display_pause destdir
        WITH Frame z.

mainLoop:
repeat:
do on error undo, retry:
   update destDir xrcDir fileF fileT bpropath lng kbc_display_pause destdir
   with Frame z.
   assign fileT = fileT + hi_char.
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
       message "No such direction ,Please Try it again !".
       next-prompt xrcDir with frame z.
       undo,retry.
   end.
   FILE-INFO:FILE-NAME = destDir.
   if FILE-INFO:FILE-TYPE = ? then do:
       message "No such direction ,Please Try it again !".
       next-prompt destDir with frame z.
       undo,retry.
   end.
   if index(propath,destDir) = 0 then do:
      message "Destination directory Error,Pleaes check propath setting!".
      message "Destination directory must in propath list.".
      next-prompt destDir with frame z.
      undo,retry.
   end.
   assign xrcDir = lower(trim(xrcDir)).
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
                     usrw_charfld[2] = trim(destDir) when destDir <> ""
                                      and destDir <> vClientDir
                     usrw_charfld[5] = trim(destDir).
           end.
        end.
        release usrw_wkfl.
    end.
end.
assign ProPath = replace(trim(bpropath),chr(10),",").

/*generate vworkfile.*/
empty temp-table tmpfile no-error.
input from OS-DIR (xrcDir).
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
run setpropath.
{gprun.i ""xxc001.p""}
leave.
end. /*mainLoop*/

PROCEDURE iniForm:
/*read form variabls from usrw_WKFL*/
find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
           usrw_key1 = qadkey1 and usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
    assign xrcdir  = trim(usrw_charfld[1]) when usrw_charfld[1] <> ""
           destDir = trim(usrw_charfld[5]) when usrw_charfld[5] <> ""
           filef   = trim(usrw_charfld[3])
           filet   = substring(usrw_charfld[4],1,length(usrw_charfld[4]) - 1)
           kbc_display_pause = usrw_intfld[1].
    if opsys = "msdos" or opsys = "win32" then do:
       assign xrcdir  = usrw_charfld[11]
              destDir = trim(usrw_charfld[15]).
    end.
end.
assign lng = lower(global_user_lang).
run setpropath.
if destdir <> "" and index(bpropath,destdir) = 0
   then do:
       assign bpropath = xrcdir + "," + trim(propath).
       assign propath = bpropath.
   end.
   else do:
       assign bpropath = trim(propath).
   end.
bProPath = replace(trim(propath),",",chr(10)).
END PROCEDURE.

procedure setpropath:
assign xrcdir = lower(trim(xrcDir)).
if xrcdir <> "" and index(bpropath,xrcdir + chr(10)) = 0
   then do:
        assign bpropath = xrcdir + "," + trim(propath).
        assign bpropath = replace(bpropath,".,","").
        assign bpropath = ".," + bpropath.
        assign propath  = bpropath.
   end.
   else do:
        assign bpropath = trim(propath).
   end.
end procedure.

/* get propties */
FUNCTION getKey RETURNS CHARACTER(ikey AS CHARACTER,iSource AS CHARACTER):
    DEFINE VARIABLE ret AS CHARACTER NO-UNDO.
    IF index(isource,ikey)>0 THEN DO:
        ASSIGN ret = substring(isource,INDEX(isource,"=") + 1).
    END.
    RETURN ret.
END.

/* read system parameter from mfgutil.ini */
PROCEDURE iniVar:
DEFINE VARIABLE vincomp AS LOGICAL.
DEFINE VARIABLE vfile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE vdir    AS CHARACTER NO-UNDO.
DEFINE VARIABLE vinput  AS CHARACTER NO-UNDO.

ASSIGN vfile = ""
       vpropath = trim(propath).
/* read mfgutil.ini */
DO WHILE index(vpropath,",") > 0:
    ASSIGN vdir = substring(vpropath,1,INDEX(vpropath,",") - 1).
    if index(vdir,"bbi") > 0 then do:
       assign vfile = substring(vdir,1,length(vdir) - 3) + "mfgutil.ini".
       IF SEARCH(vfile) <> ? and substring(vfile,1,1) <> "." and
          index(vpropath,substring(vdir,1,length(vdir) - 3) + "xrc") > 0
       THEN DO:
          leave.
       END.
    END.
    ASSIGN vpropath = SUBSTRING(vpropath,INDEX(vpropath,",") + 1).
END.
IF SEARCH(vfile) <> ? THEN DO:
    INPUT FROM VALUE(vfile).
    REPEAT:
        IMPORT vinput.
        IF INDEX(vinput,"[") > 0 THEN DO:
            IF vinput = "[Compile]" or vinput= "[ClientSetup]" THEN DO:
                ASSIGN vincomp = YES.
            END.
            ELSE DO:
                ASSIGN vincomp = NO.
            END.
        END.
        IF vincomp THEN DO:
           IF destDir   = "" THEN
              destDir   = getKey(INPUT "DestDir",INPUT vinput).
           IF xrcDir    = "" THEN
              xrcDir    = getKey(INPUT "SourceDir",INPUT vinput).
           IF vWorkFile  = "" THEN
              vWorkFile  = getKey(INPUT "WorkFile",INPUT vinput).
           IF VClientDir = "" THEN
              vClientDir = substring(vfile,1,index(vfile,"mfgutil.ini") - 2).
              /* getKey(INPUT "ClientWorkingDirectory",INPUT vinput). */
        END.
    END.
    INPUT CLOSE.
END.
END PROCEDURE.
