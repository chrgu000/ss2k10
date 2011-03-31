{mfdtitle.i "f+"}
def var filepath as char format "x(30)" init "/root/test".
def var destpath as char format "x(30)" init "/app/mfgpro/eb21sp5".
def var filefrom as char format "x(10)".
def var fileto   as char format "x(10)".
def var lang     as char format "x(2)" init "ch".
def var v_tmp as char format "x(40)".
def var v_tmp2 as char format "x(40)".
def var compcfg as char format "x(80)".
def var ii as inte.
def var v_format as char.

def var compilepath as char  format "x(60)" extent 5 label "Compile Propath".
def var compilepath1 as char format "x(60)".
def var compilepath2 as char format "x(60)".
def var compilepath3 as char format "x(60)".
def var compilepath4 as char format "x(60)".
def var compilepath5 as char format "x(60)".
def var compilepathlength as inte init 60.
def var tmp_compilepath1 as char.
def var tmp_compilepath2 as char.
def var tmp_compilepath3 as char.
def var tmp_compilepath4 as char.
def var tmp_compilepath5 as char.
def var jj as inte.
def var old_propath as char.
def var old_compilepath as char.

def temp-table tt
    field tt_file as char.

form
    filepath colon 23 label "Source Directory" skip(1)
    filefrom colon 16 label "File"
    fileto   colon 49   label "To"     skip(1)
    compilepath1 colon 16 label "Compile Propath"
    compilepath2 colon 16 no-label
    compilepath3 colon 16 no-label
    compilepath4 colon 16 no-label
    compilepath5 colon 16 no-label
    skip(1)
    lang     colon 22 label "Language Code" skip
    destpath colon 22 label "Destination Directory"
    with frame a side-labels width 80 title "Compile Program".

    view frame a.
    /*提起参数文档*/
        unix silent value ( "cd" ).
        unix silent value ( "rm -f comp.tmp").
        unix silent value ( "pwd > comp.tmp").
  input from comp.tmp.
             import unformatted v_tmp2.
        input close.
    compcfg = "".
  FILE-INFO:FILE-NAME = v_tmp2 + "/comp.txt".
  if FILE-INFO:FILE-TYPE <> ? then do:
    /*读参数文件*/
    input from value(v_tmp2 + "/comp.txt" ) NO-CONVERT.
                     import unformatted compcfg.
    input close.

    /*message entry(1,compcfg,"@") VIEW-AS ALERT-BOX. */
    assign filepath   = entry(1,compcfg,"@").
    assign filefrom   = entry(2,compcfg,"@").
    assign fileto   = entry(3,compcfg,"@").
    assign old_compilepath  = entry(4,compcfg,"@").
    assign lang   = entry(5,compcfg,"@").
    assign destpath   = entry(6,compcfg,"@").
  end.
main-loop:
repeat with frame a :
  if fileto <> "" and substr(fileto,length(fileto) - 1 ,2) = "zz" then fileto = substr(fileto,1,length(fileto) - 2 ).
  display
  filepath
  filefrom
  fileto

  lang
  destpath
  with frame a.

  DO jj = 1 to 5:
    compilepath[jj] = substring(old_compilepath, (jj - 1) * compilepathlength + 1 ,compilepathlength ).
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

        if fileto = "zzzz88" then fileto = "".
  if fileto <> "" and substr(fileto,length(fileto) - 1 ,2) = "zz" then fileto = substr(fileto,1,length(fileto) - 2 ).
        update filefrom fileto.
        if fileto = "" then fileto = "zzzz88".
        if fileto = filefrom then fileto = fileto + "zz".

  /*Update 编译路径，默认是 Filepath + 参数文件值 ，如果参数值为空则取propath--BEGIN*/
  comppath:
  repeat on endkey  undo main-loop , retry main-loop:
    if old_compilepath = "" then old_compilepath = filepath.
    DO jj = 1 to 5:
      compilepath[jj] = substring(old_compilepath, (jj - 1) * compilepathlength + 1 ,compilepathlength ).
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
            compilepath2 = substr(substring(tmp_compilepath1,60) + compilepath2,1,60).
            if length(input compilepath3) >= 60 then do:
            tmp_compilepath3 = compilepath3.
            compilepath3 = substr(substring(tmp_compilepath2,60) + compilepath3 ,1,60).
            if length(input compilepath4) >= 60 then do:
            tmp_compilepath4 = compilepath4.
            compilepath4 = substr(substring(tmp_compilepath3,60) + compilepath4 ,1,60).
            if length(input compilepath5) >= 60 then do:
            tmp_compilepath5 = compilepath5.
            compilepath5 = substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
            END.
            else compilepath5 = substring(tmp_compilepath4,60) + compilepath5.
            END.
            else compilepath4 = substring(tmp_compilepath3,60) + compilepath4.
            END.
            else compilepath3 = substring(tmp_compilepath2,60) + compilepath3.
            END.
            else compilepath2 = substring(tmp_compilepath1,60) + compilepath2.

          end.
          display  compilepath2 compilepath3 compilepath4 compilepath5 with frame a.
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
            compilepath3 = substr(substring(tmp_compilepath2,60) + compilepath3 ,1,60).
            if length(input compilepath4) >= 60 then do:
            tmp_compilepath4 = compilepath4.
            compilepath4 = substr(substring(tmp_compilepath3,60) + compilepath4 ,1,60).
            if length(input compilepath5) >= 60 then do:
            tmp_compilepath5 = compilepath5.
            compilepath5 = substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
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
            compilepath4 = substr(substring(tmp_compilepath3,60) + compilepath4 ,1,60).
            if length(input compilepath5) >= 60 then do:
            tmp_compilepath5 = compilepath5.
            compilepath5 = substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
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
              compilepath5 = substr(substring(tmp_compilepath4,60) + compilepath5 ,1,60).
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
        if ( lastkey >= 40 and lastkey <= 123 )
           then do:
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
    if substring(old_compilepath,length(old_compilepath),1) = "," then  /*去掉最少一个逗号*/
      assign old_compilepath = substring(old_compilepath,1,length(old_compilepath) - 1).
    DO jj = 1 to length(old_compilepath):
      if substring(old_compilepath,jj,1) = "," then ii = ii + 1.
    END.  /* END DO */
    DO jj = 1 to ii + 1 :
      FILE-INFO:FILE-NAME = entry(jj,old_compilepath,",").
      if FILE-INFO:FILE-TYPE = ? and entry(jj,old_compilepath,",") <> "." then do:
        message "No such direction , " + entry(jj,old_compilepath,",") + " Please try again!" VIEW-AS ALERT-BOX.
        next comppath.
      end.
    END.  /* END DO */
    /*判断输入的路径是否有效--END*/
    assign propath = old_compilepath + "," + propath.
    leave comppath.
  end.
  /*Update 编译路径，默认是 Filepath + 参数文件值 ，如果参数值为空则取propath--END*/
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
        for each tt where tt_file <> "" and tt_file >= filefrom and tt_file <= fileto :
    tt_file = trim(tt_file).
             if (index(tt_file,".p") = 0 and index(tt_file,".w") = 0 and
                index(tt_file,".P") = 0 and index(tt_file,".W") = 0) or (
     substring(tt_file,length(tt_file) - 1 ,2) <> ".p" and
     substring(tt_file,length(tt_file) - 1 ,2) <> ".P" and
     substring(tt_file,length(tt_file) - 1 ,2) <> ".w" and
     substring(tt_file,length(tt_file) - 1 ,2) <> ".W"  )
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
      for each tt where tt_file <> "" and tt_file >= filepath + "/" + filefrom and tt_file <= filepath + "/" + fileto :
        v_tmp = destpath + "/" + lang.
        FILE-INFO:FILE-NAME = v_tmp.
        if FILE-INFO:FILE-TYPE = ? then do:
          unix silent value ( "mkdir " + v_tmp ).
        end.
        v_tmp = destpath + "/" + lang + "/" + substring(tt_file,ii + 2 ,2).

        status input "Compiling " + tt_file.
        FILE-INFO:FILE-NAME = v_tmp.
        if FILE-INFO:FILE-TYPE = ? then do:
          unix silent value ( "mkdir " + v_tmp ).
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

  run gen_comp.  /*重新生成参数文件*/

procedure gen_comp :
  unix silent value ( "rm -f " + v_tmp2 + "/comp.txt" ).
  output to value(v_tmp2 + "/comp.txt" ).
  ii = length(filepath).
  v_format = "x("  + string(ii) + ")".
  put filepath format v_format at 1.   put "@".

  if filefrom <> "" then do:
    ii = length(filefrom).
    v_format = "x("  + string(ii) + ")".
    put filefrom format v_format.    put "@".
  end.
  else put "@".

  if filefrom <> "" then do:
    if fileto <> "" and substr(fileto,length(fileto) - 1 ,2) = "zz" then fileto = substr(fileto,1,length(fileto) - 2 ).
    ii = length(fileto).
    v_format = "x("  + string(ii) + ")".
    put fileto format v_format.    put "@".
  end.
  else put "@".
  ii = length(old_compilepath).
  v_format = "x("  + string(ii) + ")".
  put old_compilepath format v_format.   put "@".

  ii = length(lang).
  v_format = "x("  + string(ii) + ")".
  put lang format v_format.    put "@".

  ii = length(destpath).
  v_format = "x("  + string(ii) + ")".
  put destpath format v_format.
  put skip.

   output close.
end.
