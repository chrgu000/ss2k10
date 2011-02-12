/* xxcompile.p - compile procedure - replaced by xxc.p                       */
/* REVISION: 0BYI LAST MODIFIED: 11/18/10   BY: zy 防止重复编译           *bi*/
/* REVISION: 0BYO LAST MODIFIED: 11/24/10   BY: zy 防止重复编译默认cancel *bo*/
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "0BYO"}
/*bi*/ define variable icomptimes as integer.
define temp-table tmp_fl
  fields fl_type as character
  fields fl_file as character.

/* INITIAL PARAMETER */
DEFINE VARIABLE vpropath      AS CHARACTER
       FORMAT "x(40)" LABEL "Compile Propath" NO-UNDO.
DEFINE VARIABLE vIniFile      AS CHARACTER
       FORMAT "x(40)" LABEL "Initial Parameter" NO-UNDO.
DEFINE VARIABLE vDatabaseSet  AS CHARACTER
       FORMAT "X(20)" LABEL "Database Set" NO-UNDO.
DEFINE VARIABLE vDestDir      AS CHARACTER
       FORMAT "X(40)" LABEL "Destination Directory" NO-UNDO.
DEFINE VARIABLE vLANGUAGE     AS CHARACTER
       FORMAT "X(4)":U  LABEL "Language Code"
       VIEW-AS COMBO-BOX INNER-LINES 5
       LIST-ITEMS "ch","us"
       DROP-DOWN
       SIZE 6 BY 1 NO-UNDO.
DEFINE VARIABLE vSourceDir    AS CHARACTER
       FORMAT "X(40)" LABEL "Source Directory"
       VIEW-AS FILL-IN SIZE 40 by 1 NO-UNDO.
      /* VIEW-AS FILL-IN SIZE 40 by 10 */
DEFINE VARIABLE vWorkFile     AS CHARACTER
       FORMAT "X(40)" LABEL "Compile List File"
       VIEW-AS FILL-IN SIZE 40 by 1 NO-UNDO.
/*bi DEFINE VARIABLE vClientDir    AS CHARACTER NO-UNDO.                     */
/*bi*/ DEFINE VARIABLE vClientDir AS CHARACTER NO-UNDO FORMAT "x(40)".

DEFINE BUTTON bComp    LABEL "Compile".
DEFINE BUTTON bmfgutil LABEL "Mfgutil".
DEFINE BUTTON bCLose   LABEL "Close".
DEFINE BUTTON bView    LABEL "View".
DEFINE BUTTON bGen     LABEL "Generate".
DEFINE BUTTON bEdit    LABEL "Edit".

DEFINE VARIABLE bproPath AS CHARACTER label "Compile ProPath"
       VIEW-AS EDITOR NO-BOX SIZE 54 BY 6 NO-UNDO.
define variable vproc  as character.
define variable vrfile as character.
define variable vdir   as character.
define variable verr   as character.

DEFINE VARIABLE logSdir AS LOGICAL INITIAL no
     LABEL ": Compile to --> "
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .83 NO-UNDO.

define stream crt.
RUN iniVar.
bProPath = replace(propath,",",chr(10)).
/* DISPLAY SELECTION FORM */
form
   vIniFile     COLON 22
   vSourceDir   COLON 22 bGen SKIP(1)
   vWorkFile    COLON 22 bView bEdit skip
   bpropath     COLON 22 SKIP(1)
   vLANGUAGE    COLON 22
   vDatabaseSet COLON 54
   vDestDir     COLON 22 SKIP(1)
   logSdir      COLON 17 SKIP(2)
   bcomp        COLON 12
   bMfgutil     COLON 34
   bCLose       COLON 58
   with frame a side-labels width 80 attr-space.
ENABLE bcomp bmfgutil bCLose bGen bView bEdit bProPath vLANGUAGE logSdir
       WITH FRAME a.

run loadLang.
ASSIGN bpropath:READ-ONLY IN FRAME a = TRUE.
/*bi ASSIGN logSdir:label in frame a = trim(logSdir:label) + " " + vClientDir.*/
/*bi*/ ASSIGN logSdir:label in frame a = trim(logSdir:label) + " "
/*bi*/        + substring(vclientDir,1,length(trim(vClientDir)) - 1).

DISPLAY vinifile vSourceDir vWorkFile bpropath vLANGUAGE vDatabaseSet
        vDestDir logSdir WITH FRAM A.
on CTRL-H of bGen in frame a do:
  message "Generate Compile File List" skip
          "[Generate] This command for Generate compile file list" skip
          "from compile File List content and Source Directory."
          view-as alert-box title "Help".
end.
on CTRL-H of bpropath in frame a do:
  message "Compile Propath:setting in mfgutil.ini" skip
          "[Compile] ProPath,You can use mfgutil setting this property."
          view-as alert-box title "Help".
end.
on CTRL-H of logSdir in frame a do:
  message "You can to compile procedure to qad ClientWorkingDirectory" skip
          "This propties setting in mfgutil.ini" skip
          "[ClientSetup] ClientWorkingDirectory,"
          "You can use mfgutil setting this property."
          view-as alert-box title "Help".
end.
on CTRL-H of bMfgutil in frame a do:
  message "You can to enjoy mfgutil tools but before you use this tools" skip
          "the propath must include path $workdir/xmfgusrc" skip
          view-as alert-box title "Help".
end.
on CTRL-H of bView in frame a do:
  message "You can to show compile procedure list." skip
          view-as alert-box title "Help".
end.
on CTRL-H of bEdit in frame a do:
  message "You can to edit compile procedure list with vi or" skip
          "to generate it use mfgutil tool"
          view-as alert-box title "Help".
end.

/*bi*/ on Leave of bcomp in frame a do:
/*bi*/    assign icomptimes = 0.
/*bi*/ end.

ON 'Choose':U OF bcomp
DO:
    define variable ret as logical.
    session:set-wait-stat("genreal").
    assign logsdir vlanguage.
/*bi*/ assign ret = ?.
/*bi*/ if icomptimes > 0 then do:
/*bi*/    message "Compile General Question!" fill(" ",16) skip(1)
/*bi*/        "You alerdy compiled" trim(string(icomptimes,">9")) "times."
/*bi          fill(" ",12) skip                                              */
/*bo*/        fill(" ",12) skip(1)
/*bo          "Compile it again?" fill(" ",24)                               */
/*bo           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO                     */
/*bo*/        "Compile it again(yes/no)" fill(" ",16) skip
/*bo*/        "or quit This procedure(cancel)?" fill(" ",10)
/*bo*/         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
/*bi*/         title "Compile Repeat" UPDATE ret.
/*bo      if not ret then return.                                            */
/*bo*/    case ret:
/*bo*/         when false then return.
/*bo*/         when true  then.
/*bo*/         otherwise  apply "window-close" to frame a.
/*bo*/    end case.
/*bi*/ end.
/*bi*/ icomptimes = icomptimes + 1.
    if search(vworkfile) <> ? then do:
    input from value(vworkfile).
    repeat:
        unix silent cd /var/tmp.
        import vproc.
        assign vproc = lower(vproc).
        if index(vproc,"/") = 0 then
           vproc  = vsourcedir + "/" + vproc.
           vrfile = vproc.
        do while index(vrfile,"/") > 0:
           assign vrfile = substring(vrfile,index(vrfile,"/") + 1).
        end.
        assign vrfile = substring(vrfile,1,index(vrfile,".")) + "r".
        assign vdir = vDestDir + "/" + vLANGUAGE + "/" + substring(vrfile,1,2).
        status input "Compile:" + vproc + "...".
        if search(vproc) <> ? then do:
            unix silent value("rm -f " + vdir + "/" + vrfile).
            compile value(vproc) save into "/var/tmp".
        end.
        else do:
            message "procedure " + vproc + ' not fond!' view-as alert-box.
        end.
        status input "Compile:" + vproc + ".....".
        if search("/var/tmp/" + vrfile) <> ? then do:
            if logSdir then do:
               assign vdir = vClientDir + "/"
                           + vLANGUAGE + "/" + substring(vrfile,1,2).
            end.
            unix silent mkdir -p value(vdir).
            unix silent value("mv /var/tmp/" + vrfile + " " + vdir).
        end.
        status input "Compile:" + vproc + "......".
    end. /* repeat: input from wkfl */
    input close.
    session:set-wait-stat("").
    status input "Compile Complete! Last compile:" + vproc.
    end. /* if search(vworkfile) <> ? then do: */
    else do:
/*bi*/ assign icomptimes = 0.
       assign ret = yes.
/*bi   message "Compile General Error                " skip(1)               */
/*bi*/ message "Compile General Error!" fill(" ",14) skip(1)
               "Generate Compile File List not found." skip
/*bi           "Generate it?                          "                      */
/*bi*/         "Generate it?" fill(" ",25)
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                title "Compile Error" UPDATE ret.
       if ret then do:
          Apply "choose":U to bgen.
       end.
    end.
END.

ON 'Choose':U of bGen do:
  define variable vfn as character.
  define variable vfd as character.
  define variable vft as character.
  assign vSourceDir vWorkFile.
  empty temp-table tmp_fl no-error.
  if search(vworkfile) <> ? then do:
    input from value(vWorkFile).
    repeat:
      create tmp_fl.
      import fl_file.
      assign fl_type = "F".
    end.
    input close.
  end.
  input from os-dir(vSourceDir).
  repeat:
    import vfn vfd vft.
    if vft = "F" and index(".p.w.t",substring(vfn,length(vfn) - 1,2)) > 0 then
    DO:
      if not can-find(first tmp_fl no-lock where vfn = fl_file) then do:
        create tmp_fl.
        assign fl_type = "D"
               fl_file = vfn.
      end.
    END.
  end.
  input close.
  output to value(vWorkFile).
     for each tmp_fl no-lock where fl_file <> ""
         break by fl_file by fl_type descend:
         if first-of(fl_file) then do:
            if index(".p.w.t",substring(fl_file,length(fl_file) - 1,2)) > 0
            then do:
              if search(fl_file) <> ? or
                 search(vSourceDir + "/" + fl_file) <> ?  then do:
                 put unformat fl_file skip.
              end.
            end.
         end.
     end.
  output close.
  Apply "choose":U to bView.
end.

on 'Choose':U of bEdit do:
  unix "vi " + value(vWorkFile).
end.

ON 'Choose':U OF bCLose DO:
     APPLY "WINDOW-CLOSE":U TO current-window.
     return.
END.

ON 'Choose':U OF bmfgutil DO:
    define variable vdir as character.
    assign vdir = propath.
    hide frame a.
    hide frame dtitle.
    unix silent cd value(VClientDir).
    do while length(vdir) > 1:
       if search(substring(vdir,1,index(vdir,",") - 1) + "/xmfgusrc/mfgutil.p")
          <> ? then do:
          assign vdir = substring(vdir,1,index(vdir,",") - 1)
                      + "/xmfgusrc/mfgutil.p".
          leave.
       end.
       if index(vdir,",") > 0 then
          assign vdir = substring(vdir,index(vdir,",") + 1).
       else
          assign vdir = "".
    end.
    if search(vdir) <> ? then do:
       assign vdir = search(vdir).
       run value(vdir).
    end.
    hide frame dtitle.
    view frame a.
END.

ON 'Choose':U of bView do:
    define variable vtxt as character.
    define variable msg  as character.
    define variable v1   as character.
    define variable i    as integer.
    i = 0.
    assign msg = ""
           verr = "".
    if search(vworkfile) <> ? then do:
    input from value(vWorkFile).
    repeat:
       import v1.
       if verr = v1 or index(msg,v1) > 0 then next.
       assign verr = v1.
       if length(trim(v1)) > 14 then
          assign v1 = substring(v1,1,11) + "*." + substring(v1,length(v1),1).
          assign vTxt = vTxt + trim(substring(v1,1,14))
                      + substring("              ",1,14 - length(v1)).
       i = i + 1.
       if i = 5  then do:
          msg = msg + vtxt + chr(10).
          vtxt = "".
          i = 0.
       end.
    end.
    input close.
    if vtxt <> "" then do:
       assign v1 = "".
       do i = 1 to 80:
          v1 = v1 + " ".
       end.
       msg = msg + trim(vtxt) + substring(v1, 1 , 70 - length(trim(vtxt))).
    end.
    if length(trim(msg)) > 1274  then do:
/*bi     assign msg = substring(msg,1,1263) + "......        " .             */
/*bi*/   assign msg = substring(msg,1,1263) + "......" + fill(" ",8).
    end.
    if length(trim(msg)) <= 70 then do:
        assign msg = trim(msg).
    end.
        message msg View-as alert-box info title "Compile File List".
    end.
    else do:
        message "Compile List File not found." view-as alert-box error.
    end.
END.
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.

/*原{xxcomp.i} */
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
       vpropath = PROPATH.
/* 找mfgutil.ini档 */
DO WHILE index(vpropath,",") > 0:
    ASSIGN vdir = substring(vpropath,1,INDEX(vpropath,",") - 1).
    if index(vdir,"src") > 0 or index(vdir,"bbi") > 0 or index(vdir,"xrc") > 0
    then do:
       assign vfile = substring(vdir,1,length(vdir) - 3) + "mfgutil.ini".
       IF SEARCH(vfile) <> ? and substring(vfile,1,1) <> "." THEN DO:
          leave.
       END.
    END.
    ASSIGN vpropath = SUBSTRING(vpropath,INDEX(vpropath,",") + 1).
END.
IF SEARCH(vfile) <> ? THEN DO:
    ASSIGN vIniFile = vFile.
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
           IF vdatabaseset = "" THEN
              vDatabaseSet = getKey(INPUT "Databaseset",INPUT vinput).
           IF vDestDir   = "" THEN
              vDestDir   = getKey(INPUT "DestDir",INPUT vinput).
           IF vLANGUAGE  = "" THEN
              vLANGUAGE  = getKey(INPUT "LANGUAGE",INPUT vinput).
           IF vSourceDir = "" THEN
              vSourceDir = getKey(INPUT "SourceDir",INPUT vinput).
           IF vWorkFile  = "" THEN
              vWorkFile  = getKey(INPUT "WorkFile",INPUT vinput).
           IF VClientDir = "" THEN
              vClientDir = substring(vfile,1,index(vfile,"mfgutil.ini") - 1).
              /* getKey(INPUT "ClientWorkingDirectory",INPUT vinput). */
        END.
    END.
    INPUT CLOSE.
    ASSIGN vpropath = PROPATH.
END.
END PROCEDURE.

PROCEDURE loadLang:
do with frame a:
  assign vLANGUAGE:List-Items = "".
/*bi FOR EACH LNG_MSTR NO-LOCK:                                              */
/*bi*/ FOR EACH LNG_MSTR NO-LOCK WHERE lng_lang <> "":
      vLANGUAGE:ADD-LAST(lng_lang).
  END.
end.
END PROCEDURE.
