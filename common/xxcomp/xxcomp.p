/* xxcomp.p - compile procedure                                              */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 14Y1 LAST MODIFIED: 04/01/11 BY:ZY 参数记录在qad_wkfl           */
/* REVISION: 14YB LAST MODIFIED: 04/11/11 BY:zy Add EB common             *EB*/
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "14YB"}
define variable filepath as character format "x(54)".
define variable destpath as character format "x(54)".
define variable filefrom as character format "x(24)".
define variable fileto   as character format "x(24)".
define variable lang     as character format "x(2)".
define variable v_tmp    as character format "x(40)".
define variable v_tmp2   as character format "x(40)".
define variable compcfg  as character format "x(80)".
define variable ii as integer.
define variable v_format as character.
define variable vdevice  as character.
define variable vsysusr  as character.
define variable compilepath  as character format "x(60)" extent 5
       label "Compile Propath".
define variable compilepath1 as character format "x(60)".
define variable compilepath2 as character format "x(60)".
define variable compilepath3 as character format "x(60)".
define variable compilepath4 as character format "x(60)".
define variable compilepath5 as character format "x(60)".
define variable compilepathlength as integer initial 60.
define variable tmp_compilepath1  as character.
define variable tmp_compilepath2  as character.
define variable tmp_compilepath3  as character.
define variable tmp_compilepath4  as character.
define variable tmp_compilepath5  as character.
define variable jj as integer.
define variable old_propath as character.
define variable old_compilepath as character.
DEFINE VARIABLE delParam AS LOGICAL NO-UNDO initial no.
if old_compilepath = "" then do:
      run getQADPath(output old_compilepath).
      assign old_compilepath = ".," + old_compilepath + ","
                             + old_compilepath + "/bbi,"
                             + old_compilepath + "/xrc".
end.
define temp-table tt
       field tt_file as char.

form
    filepath     colon 22 label "Source Directory" skip(1)
    filefrom     colon 16 label "File"
    fileto       colon 49 label {t001.i} skip(1)
    compilepath1 colon 16 label "Compile Propath"
    compilepath2 colon 16 no-label
    compilepath3 colon 16 no-label
    compilepath4 colon 16 no-label
    compilepath5 colon 16 no-label
    skip(1)
    lang         colon 22 label "Language Code" skip
    destpath     colon 22 label "Destination Directory"
with frame a side-labels width 80 title "Compile Program".
setFrameLabels(frame a:handle).
view frame a.

on value-changed of lang in frame a do:
   IF LASTKEY = KEYCODE("u") OR LASTKEY = KEYCODE("U") then do:
      assign lang:screen-value in frame a = "us".
      assign lang.
   end.
   IF LASTKEY = KEYCODE("c") OR LASTKEY = KEYCODE("C") then do:
      assign lang:screen-value in frame a = "ch".
      assign lang.
   end.
   IF LASTKEY = KEYCODE("t") OR LASTKEY = KEYCODE("T") then do:
      assign lang:screen-value in frame a = "tw".
      assign lang.
   end.
end.
ON "CTRL-D" OF destpath IN FRAME a DO:
   {mfmsg01.i 11 2 delParam}
   if delParam then do:
      for each qad_wkfl where
/*eb*/         qad_domain = "xxcomp_param" and
               qad_key1 = "xxcomp_param" exclusive-lock:
          delete qad_wkf.
      end.
      return.
   end.
end.
on Entry of destpath in frame a do:
   status input "Ctrl-] to change default value.".
   {pxmsg.i &MSGTEXT='"Ctrl-D to delete saved param."' &ERRORLEVEL=1}
end.
on Leave of destpath in frame a do:
   status input "".
end.
ON "CTRL-]" OF destpath IN FRAME a DO:
   define variable qadpath as character.
   run getQADPath(output qadpath).
   if destpath <> qadpath then do:
      assign destpath:screen-value = qadpath.
      assign destpath.
   end.
   else do:
       find first qad_wkfl where
/*eb*/       qad_domain = "xxcomp_param" and
             qad_key1 = "xxcomp_param" and qad_key2= trim(vdevice) and
             qad_key3 = trim(vsysusr) and qad_key4 = trim(global_userid)
             exclusive-lock no-error.
       if available qad_wkfl then do:
          assign destpath:screen-value = qad_charfld[6].
          assign destpath.
       end.
   end.
end.
  /*提起参数文档*/
  unix silent value ( "cd" ).
  unix silent value ( "rm -f comp.tmp").
  unix silent value ( "pwd > comp.tmp").
  input from comp.tmp.
        import unformatted v_tmp2.
  input close.
    compcfg = "".
/*  FILE-INFO:FILE-NAME = v_tmp2 + "/comp.txt".                              */
/*  if FILE-INFO:FILE-TYPE <> ? then do:                                     */
/*    /*读参数文件*/                                                         */
/*    input from value(v_tmp2 + "/comp.txt" ) NO-CONVERT.                    */
/*                     import unformatted compcfg.                           */
/*    input close.                                                           */
/*                                                                           */
/*    /*message entry(1,compcfg,"@") VIEW-AS ALERT-BOX. */                   */
/*    assign filepath   = entry(1,compcfg,"@").                              */
/*    assign filefrom   = entry(2,compcfg,"@").                              */
/*    assign fileto   = entry(3,compcfg,"@").                                */
/*    assign old_compilepath  = entry(4,compcfg,"@").                        */
/*    assign lang   = entry(5,compcfg,"@").                                  */
/*    assign destpath   = entry(6,compcfg,"@").                              */
/*  end.                                                                     */
run getUserInfo(output vsysusr,output vdevice).
assign lang = lc(global_user_lang).
find first qad_wkfl where
/*eb*/     qad_domain = "xxcomp_param" and
           qad_key1 = "xxcomp_param" and qad_key2= trim(vdevice) and
           qad_key3 = trim(vsysusr) and qad_key4 = trim(global_userid)
           no-lock no-error.
if available qad_wkfl then do:
   assign filePath = qad_charfld[1]
          filefrom = qad_charfld[2]
          fileto   = qad_charfld[3]
          old_compilepath = qad_charfld[4]
          lang = qad_charfld[5].
          if qad_charfld[6] <> "" then
             destpath = qad_charfld[6].
          else do:
             run getQADPath(output destpath).
          end.
end.
else do:
   run getQADPath(output destpath).
end.
main-loop:
repeat with frame a :
  display filepath
          filefrom
          fileto
          lang
          destpath
  with frame a.

  DO jj = 1 to 5:
    compilepath[jj] = substring(old_compilepath,
                                (jj - 1) * compilepathlength + 1,
                                compilepathlength ).
  END.  /* END DO */
  compilepath1 = compilepath[1].
  compilepath2 = compilepath[2].
  compilepath3 = compilepath[3].
  compilepath4 = compilepath[4].
  compilepath5 = compilepath[5].

  display compilepath1
          compilepath2
          compilepath3
          compilepath4
          compilepath5
    with frame a.

  old_propath =  propath.
    update filepath.
    FILE-INFO:FILE-NAME = filepath.
    if FILE-INFO:FILE-TYPE = ? then do:
        message "No such direction ,Please input it again !".
        next.
    end.
    else do:
        assign filepath = FILE-INFO:FULL-PATHNAME.
        disp filepath.
        if index(old_compilepath,filepath) = 0 then do:
           run getQADPath(output old_compilepath).
           assign old_compilepath = ".," + filepath + "," + old_compilepath
                                  + ","  + old_compilepath + "/bbi,"
                                  + old_compilepath + "/xrc".
        end.
        if fileto = CHR(255) then fileto = "".
        update filefrom fileto.
        if fileto = "" then fileto = CHR(255).
        if fileto = filefrom then fileto = fileto + CHR(255).

 /*Update 编译路径，默认是 Filepath + 参数文件值 ，如果参数值为空则取propath */
  comppath:
  repeat on endkey  undo main-loop , retry main-loop:
    if old_compilepath = "" then old_compilepath = filepath.
    DO jj = 1 to 5:
      compilepath[jj] = substring(old_compilepath,
                                  (jj - 1) * compilepathlength + 1,
                                  compilepathlength).
    END.  /* END DO */
    compilepath1 = compilepath[1].
    compilepath2 = compilepath[2].
    compilepath3 = compilepath[3].
    compilepath4 = compilepath[4].
    compilepath5 = compilepath[5].
    jj = 1.
    update
      compilepath1
      compilepath2
      compilepath3
      compilepath4
      compilepath5
      with frame a editing:
      if jj = 1 then do:  apply chr(20).  jj = 2.   end.
      if frame-field = "compilepath1" then do:
        status input.
        readkey.
        if ( lastkey >= 40 and lastkey <= 123 )
           then do:
          if length(input compilepath1) >= 60 then do:
            tmp_compilepath1 = input compilepath1.
            if length(input compilepath2) >= 60 then do:
            tmp_compilepath2 = compilepath2.
            compilepath2 =
                substr(substring(tmp_compilepath1,60) + compilepath2,1,60).
            if length(input compilepath3) >= 60 then do:
            tmp_compilepath3 = compilepath3.
            compilepath3 =
                substr(substring(tmp_compilepath2,60) + compilepath3 ,1,60).
            if length(input compilepath4) >= 60 then do:
            tmp_compilepath4 = compilepath4.
            compilepath4 =
                substr(substring(tmp_compilepath3,60) + compilepath4 ,1,60).
            if length(input compilepath5) >= 60 then do:
            tmp_compilepath5 = compilepath5.
            compilepath5 =
                substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
            END.
            else compilepath5 = substring(tmp_compilepath4,60) + compilepath5.
            END.
            else compilepath4 = substring(tmp_compilepath3,60) + compilepath4.
            END.
            else compilepath3 = substring(tmp_compilepath2,60) + compilepath3.
            END.
            else compilepath2 = substring(tmp_compilepath1,60) + compilepath2.

          end.
          display compilepath2 compilepath3 compilepath4 compilepath5
          with frame a.
        end.  /*if ( chr(lastkey) >= "a" and ch*/
        apply lastkey.
      end.
      else if frame-field = "compilepath2" then do:
        status input.
        readkey.
        if ( lastkey >= 40 and lastkey <= 123 )
           then do:
            if length(input compilepath2) >= 60 then do:
               tmp_compilepath2 = input compilepath2.
            if length(input compilepath3) >= 60 then do:
               tmp_compilepath3 = compilepath3.
               compilepath3 =
                   substr(substring(tmp_compilepath2,60) + compilepath3 ,1,60).
            if length(input compilepath4) >= 60 then do:
               tmp_compilepath4 = compilepath4.
               compilepath4 =
                   substr(substring(tmp_compilepath3,60) + compilepath4 ,1,60).
            if length(input compilepath5) >= 60 then do:
               tmp_compilepath5 = compilepath5.
               compilepath5 =
                  substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
            END.
            else compilepath5 = substring(tmp_compilepath4,60) + compilepath5.
            END.
            else compilepath4 = substring(tmp_compilepath3,60) + compilepath4.
            END.
            else compilepath3 = substring(tmp_compilepath2,60) + compilepath3.
            END.

          display  compilepath3 compilepath4 compilepath5 with frame a.
        end.  /*if ( chr(lastkey) >= "a" and ch*/
        apply lastkey.
      end.
      else if frame-field = "compilepath3" then do:
        status input.
        readkey.
        if ( lastkey >= 40 and lastkey <= 123 )
           then do:

            if length(input compilepath3) >= 60 then do:
            tmp_compilepath3 = input compilepath3.

            if length(input compilepath4) >= 60 then do:
               tmp_compilepath4 = compilepath4.
               compilepath4 =
                  substr(substring(tmp_compilepath3,60) + compilepath4 ,1,60).
            if length(input compilepath5) >= 60 then do:
               tmp_compilepath5 = compilepath5.
               compilepath5 =
                  substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
            END.
            else compilepath5 = substring(tmp_compilepath4,60) + compilepath5.
            END.
            else compilepath4 = substring(tmp_compilepath3,60) + compilepath4.
            END.

          display  compilepath4 compilepath5 with frame a.
        end.  /*if ( chr(lastkey) >= "a" and ch*/
        apply lastkey.
      end.
      else if frame-field = "compilepath4" then do:
        status input.
        readkey.
        if ( lastkey >= 40 and lastkey <= 123 )
           then do:

            if length(input compilepath4) >= 60 then do:
              tmp_compilepath4 = input compilepath4.

              if length(input compilepath5) >= 60 then do:
                 tmp_compilepath5 = compilepath5.
                 compilepath5 =
                    substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
              END.
              else compilepath5 = substring(tmp_compilepath4,60) + compilepath5.
            END.

          display   compilepath5 with frame a.
        end.  /*if ( chr(lastkey) >= "a" and ch*/
        apply lastkey.
      end.
      else if frame-field = "compilepath5" then do:
        status input.
        readkey.
        if ( lastkey >= 40 and lastkey <= 123 ) then do:
             .
        end.  /*if ( chr(lastkey) >= "a" and ch*/
        apply lastkey.
      end.
      else do:
        status input.
        readkey.
        apply lastkey.
      end.
    end.

    old_compilepath = "".

      old_compilepath = old_compilepath
        + trim(compilepath1)
        + trim(compilepath2)
        + trim(compilepath3)
        + trim(compilepath4)
        + trim(compilepath5).
    /*判断输入的路径是否有效--BEGIN*/
    if old_compilepath = "" then do:
      message "You must input valid directory." view-as alert-box.
      next comppath.
    end.
    ii = 0.
    /*去掉最少一个逗号*/
    if substring(old_compilepath,length(old_compilepath),1) = "," then
      assign old_compilepath =
             substring(old_compilepath,1,length(old_compilepath) - 1).
    DO jj = 1 to length(old_compilepath):
      if substring(old_compilepath,jj,1) = "," then ii = ii + 1.
    END.  /* END DO */
    DO jj = 1 to ii + 1 :
      FILE-INFO:FILE-NAME = entry(jj,old_compilepath,",").
      if FILE-INFO:FILE-TYPE = ? and entry(jj,old_compilepath,",") <> "."
      then do:
        message "No such direction , " + entry(jj,old_compilepath,",")
              + " Please try again!" VIEW-AS ALERT-BOX.
        next comppath.
      end.
    END.  /* END DO */
    /*判断输入的路径是否有效--END*/
    assign propath = old_compilepath + "," + propath.
    leave comppath.
  end.
 /*Update 编译路径，默认是 Filepath + 参数文件值 ，如果参数值为空则取propath-*/
        /*input from comp.tmp.
             import unformatted v_tmp.
        input close.*/
        for each tt :   delete tt.  end.
        unix silent value ( "ls -1 " + filepath + " > " + v_tmp2 + "/comp.lst").
        input from value(v_tmp2 + "/comp.lst").
             repeat:
                 create tt.
                 import tt.
             end.
        input close.
        output to value(v_tmp2 + "/comp.lst").
        for each tt where tt_file <> "" and tt_file >= filefrom
             and tt_file <= fileto :
             tt_file = trim(tt_file).
             if (index(tt_file,".p") = 0 and index(tt_file,".w") = 0 and
                index(tt_file,".P") = 0 and index(tt_file,".W") = 0) or (
                substring(tt_file,length(tt_file) - 1 ,2) <> ".p" and
                substring(tt_file,length(tt_file) - 1 ,2) <> ".P" and
                substring(tt_file,length(tt_file) - 1 ,2) <> ".w" and
                substring(tt_file,length(tt_file) - 1 ,2) <> ".W")
                then do:
                     delete tt.
             end.
             else do:
                 if substr(filepath,length(filepath),1) = "/" then
                      assign tt_file = filepath + tt_file.
                 else assign tt_file = filepath + "/" + tt_file.
                 FILE-INFO:FILE-NAME = tt_file.
                 if substr(FILE-INFO:FILE-TYPE,1,1) = "D"
                        then do:    /*是目录就不取*/
                     delete tt.
                 end.
                 else do:
                     ii = length(tt_file).
                     v_format = "x("  + string(ii) + ")".
                     put tt_file format v_format at 1.
                 end.
             end.
        end.
        output close.
  /*开始逐个编译--BEGIN*/
  repeat on endkey  undo main-loop , retry main-loop with frame a :
    update lang destpath.
    FILE-INFO:FILE-NAME = destpath.
    if FILE-INFO:FILE-TYPE = ? then do:
      message "No such direction ,Please input it again !".
      next.
    end.
    else do:
      assign destpath = FILE-INFO:FULL-PATHNAME.
      disp destpath.
      ii = length(filepath).
      for each tt where tt_file <> "" and tt_file >= filepath + "/" + filefrom
           and tt_file <= filepath + "/" + fileto:
        v_tmp = destpath + "/" + lc(lang).
        FILE-INFO:FILE-NAME = v_tmp.
        if FILE-INFO:FILE-TYPE = ? then do:
          unix silent value ( "mkdir " + v_tmp).
        end.
        v_tmp = destpath + "/" + lc(lang) + "/" + substring(tt_file,ii + 2 ,2).

        status input "Compiling " + tt_file.
        FILE-INFO:FILE-NAME = v_tmp.
        if FILE-INFO:FILE-TYPE = ? then do:
          unix silent value ( "mkdir " + v_tmp).
        end.
        compile value(tt_file) save into value(v_tmp) /*no-error*/.

        /*message string(error-status:error ).
            pause.
            IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0 THEN
            DO:
              MESSAGE ERROR-STATUS:NUM-MESSAGES
               " errors occurred during compile program." SKIP
               "Do you want to view them?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
               UPDATE view-errs AS LOGICAL.

              IF view-errs THEN
              DO jj = 1 TO ERROR-STATUS:NUM-MESSAGES:
          MESSAGE ERROR-STATUS:GET-NUMBER(jj)
            ERROR-STATUS:GET-MESSAGE(jj).
              END.
            END.*/
        /*if compiler:error THEN DO:
          MESSAGE "Compilation error in" COMPILER:FILENAME "at line"
                        COMPILER:ERROR-ROW "column" COMPILER:ERROR-COL.
            pause.
        END.*/  /* THEN DO */


      end.
      leave.
    end.
  end.
  /*开始逐个编译--END*/
    end.
    assign propath = old_propath.
end.
os-delete comp.tmp.
os-delete comp.lst.

if not delParam then do:
   run gen_comp.  /*重新生成参数文件*/
end.

procedure gen_comp:
  define variable vdestpath as character.
  find first qad_wkfl where
/*eb*/       qad_domain = "xxcomp_param" and
             qad_key1 = "xxcomp_param" and qad_key2 = trim(vdevice) and
             qad_key3 = trim(vsysusr) and qad_key4 = trim(global_userid)
             exclusive-lock no-error.
  if not available qad_wkfl then do:
     create qad_wkfl.
     assign
/*eb*/      qad_domain = "xxcomp_param"
            qad_key1 = "xxcomp_param"
            qad_key2 = trim(vdevice)
            qad_key3 = trim(vsysusr)
            qad_key4 = trim(global_userid).
  end.
   assign qad_key5 = mfguser
          qad_charfld[1] = filePath
          qad_charfld[2] = filefrom
          qad_charfld[3] = if fileto = "" then CHR(255) else fileto
          qad_charfld[4] = old_compilepath
          qad_charfld[5] = lang.
   run getQADPath(output vdestpath).
   if vdestpath <> destpath then qad_charfld[6] = destpath.
end procedure.

procedure getQADPath:
  define output parameter vpropath as character.
  define variable vdir as character.
  define variable vfile as character.
  assign vpropath = propath.
  DO WHILE index(vpropath,",") > 0:
    ASSIGN vdir = substring(vpropath,1,INDEX(vpropath,",") - 1).
    if index(vdir,"bbi") > 0 or index(vdir,"xrc") > 0 or index(vdir,"src") > 0
    then do:
       assign vfile = substring(vdir,1,length(vdir) - 3) + "mfgutil.ini".
       IF SEARCH(vfile) <> ? and substring(vfile,1,1) <> "." THEN DO:
          ASSIGN vpropath = SUBSTRING(vpropath,1,INDEX(vpropath,",") - 5).
          leave.
       END.
    end.
    ASSIGN vpropath = SUBSTRING(vpropath,INDEX(vpropath,",") + 1).
  END.
end procedure.

procedure getUserInfo:
    define output parameter osysusr as character.
    define output parameter odevice as character.
    FOR EACH mon_mstr NO-LOCK WHERE mon_sid = mfguser,
        EACH qaddb._connect NO-LOCK WHERE mon__qadi01 = _Connect-Usr:
      assign osysusr = _connect-name
             odevice = _connect-device.
    END.
end procedure.
