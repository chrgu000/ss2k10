/* xxc.p - compile procedure                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10 BY: zy language be lower case      */
/* REVISION: 14YP LAST MODIFIED: 04/25/11 BY: zy Add EB common            *EB*/
/* REVISION: 19Y2 LAST MODIFIED: 09/02/11 BY: zy fix mfgutil.ini get methed  */
/* REVISION: 19YG LAST MODIFIED: 09/16/11 BY: zy auto fill filet text        */
/* REVISION END                                                              */

{mfdtitle.i "1BY3"}

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
define variable vFileName  as character extent 3.
define variable qadkey1    as character initial "xxcomp.p.parameter" no-undo.
define variable xrcDir     as character format "x(50)" no-undo.
define variable vpropath   as character.
define variable bpropath   as character view-as editor no-box size 50 by 7.
/****gui format
define variable bpropath   as character bgcolor 15 view-as editor size 50 by 7.
****/
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
       find first qad_wkfl no-lock where
/*EB          qad_domain = global_domain and                                 */
              qad_key1 = qadkey1 and qad_key2 = global_userid no-error.
       if available qad_wkfl then do:
          if opsys = "unix" then do:
            assign destDir:screen-value = trim(qad_charfld[2]).
          end.
          else if opsys = "msdos" or opsys = "win32" then do:
            assign destDir:screen-value = trim(qad_charfld1[2]).
          end.
          assign destDir.
       end.
       release qad_wkfl.
   end.
end.

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

assign c-comp-pgms = getTermLabel("CAPS_COMPILE_PROGRAMS",20).
display c-comp-pgms with frame tx.
display xrcDir filef filet bproPath lower(lng) @ lng destdir with Frame z.
ENABLE  xrcDir filef filet bproPath lng destdir WITH Frame z.

mainLoop:
repeat:
do on error undo, retry:
   update destDir xrcDir fileF fileT bpropath lng destdir with Frame z.
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
   find first qad_wkfl where
/*EB          qad_domain = global_domain and                                 */
              qad_key1 = qadkey1 and qad_key2 = global_userid no-error.
        if not available qad_wkfl then do:
           create qad_wkfl.
           assign
/*EB          qad_domain = global_domain                                     */
              qad_key1 = qadkey1
              qad_key2 = global_userid.
        end.
        if not locked(qad_wkfl) then do:
           assign qad_charfld[3] = filef
                  qad_charfld[4] = trim(filet).
           if opsys = "msdos" or opsys = "win32" then do:
              assign qad_charfld1[1] = xrcdir
                     qad_charfld1[2] = trim(destDir) when destDir <> ""
                                       and destDir <> vClientDir
                     qad_charfld1[5] = trim(destDir).
           end.
           else if opsys = "unix" then do:
              assign qad_charfld[1] = xrcdir
                     qad_charfld[2] = trim(destDir) when destDir <> ""
                                      and destDir <> vClientDir
                     qad_charfld[5] = trim(destDir).
           end.
        end.
        release qad_wkfl.
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
{gprun.i ""xxc001.p""}

leave.
end. /*mainLoop*/

PROCEDURE iniForm:
/*优先取QAD_WKFL存储的*/
find first qad_wkfl no-lock where
/*EB          qad_domain = global_domain and                                 */
              qad_key1 = qadkey1 and qad_key2 = global_userid no-error.
if available qad_wkfl then do:
    assign xrcdir  = trim(qad_charfld[1]) when qad_charfld[1] <> ""
           destDir = trim(qad_charfld[5]) when qad_charfld[5] <> ""
           filef   = trim(qad_charfld[3])
           filet   = substring(qad_charfld[4],1,length(qad_charfld[4]) - 1).
    if opsys = "msdos" or opsys = "win32" then do:
       assign xrcdir  = qad_charfld1[1]
              destDir = trim(qad_charfld1[5]).
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

/* 读取属性值 */
FUNCTION getKey RETURNS CHARACTER(ikey AS CHARACTER,iSource AS CHARACTER):
    DEFINE VARIABLE ret AS CHARACTER NO-UNDO.
    IF index(isource,ikey)>0 THEN DO:
        ASSIGN ret = substring(isource,INDEX(isource,"=") + 1).
    END.
    RETURN ret.
END.

/* 从mfgutil.ini读取系统参数 */
PROCEDURE iniVar:
DEFINE VARIABLE vincomp AS LOGICAL.
DEFINE VARIABLE vfile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE vdir    AS CHARACTER NO-UNDO.
DEFINE VARIABLE vinput  AS CHARACTER NO-UNDO.

ASSIGN vfile = ""
       vpropath = trim(propath).
/* 找mfgutil.ini档 */
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
