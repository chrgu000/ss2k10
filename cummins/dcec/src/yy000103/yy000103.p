/* yy000103.p                                                                        */
/* $Revision:DCEC  $ BY: Cosesa Yang       DATE: 09/26/12     ECO: *SS-20120926.1*   */

/* DISPLAY TITLE */
{mfdtitle.i "120926.1"}

DEFINE VARIABLE codeValue   LIKE code_value.
DEFINE VARIABLE codeCmmt    LIKE code_cmmt.
DEFINE VARIABLE accessOk    AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE xxpwaction  AS CHARACTER FORMAT "x(8)" INIT "" NO-UNDO.
define variable xxpwconfirm   AS LOGICAL  INITIAL NO  NO-UNDO.
define variable del-yn as logical initial no.
define variable i as int .


form
    codeValue    colon 22 label "分类"
    codeCmmt     colon 22 label "说明"
    with frame F-A side-label width 80.
setFrameLabels(frame F-A:handle).

/*
form 
    xxpwaction colon 38 no-label
    SKIP(1)
    with frame F-E side-label width 80.
setFrameLabels(frame F-E:handle).*/

FORM 
    xxpower_line      COLUMN-LABEL "序号"
    xxpower_fr        COLUMN-LABEL "自"
    xxpower_to        COLUMN-LABEL "至"
    with row 5 centered overlay down frame F-B title "[A]添加 [D]删除 [Enter]修改" width 80.
setFrameLabels(frame F-B:handle).

FORM 
    xxpower_line      COLUMN-LABEL "序号"
    xxpower_fr        COLUMN-LABEL "自"
    xxpower_to        COLUMN-LABEL "至"
    with row 12 width 80 overlay center  frame F-C title xxpwaction DOWN.
setFrameLabels(frame F-C:handle).
 
mainloop:     
repeat:
     view frame F-A.
     view frame F-B.
     CLEAR FRAME F-B ALL NO-PAUSE.

     UPDATE codeValue with frame F-A editing:
      if frame-field = "codeValue" then do:
            {mfnp05.i code_mstr code_fldval "code_mstr.code_domain = global_domain and code_fldname = ""XX-DCEC0001"" "
                      ""yes""
                      code_value
                      "input codeValue"}
	      
            if recno <> ? then do:
                display code_value @ codeValue code_cmmt @ codeCmmt with frame F-A.
            end. /* IF RECNO <> ? */
	  end.
        else do:
           status input.
           readkey.
           apply lastkey.
        end.
      END.

  FIND FIRST code_mstr WHERE code_mstr.code_domain = global_domain AND code_value = input codeValue 
                             and code_fldname = "XX-DCEC0001" no-error.

  IF AVAILABLE code_mstr THEN DO:
        ASSIGN codeCmmt = code_cmmt.
	DISPLAY codeCmmt WITH FRAME F-A.
    END.
    ELSE DO:
         codeCmmt = "".
	 create code_mstr.
	 assign 
	        code_domain = global_domain
		code_fldname = "XX-DCEC0001"
	        code_value = input codeValue .
	
    END.
    update codeCmmt go-on("CTRL-D") WITH FRAME F-A.
	 assign code_cmmt = codeCmmt .
	  if lastkey = keycode("CTRL-D")
          then do:
	  find first xxpower_det where xxpower_det.xxpower_domain = global_domain and
	            xxpower_value = codeValue no-error.
           if avail xxpower_det then do :
            message "存在马力分组与产品类关系，不可直接删除！".
	    pause 3.
	   end.
	   else do:
	   message "确认是否删除？" update del-yn.
	    if del-yn  then do:
            delete code_mstr.          
            clear frame F-A.
	    next mainloop.
            end.
	   end.            
	  end.
	
 MainBlock:
    do on error undo,leave on endkey undo,leave:
         for first xxpower_det no-lock :
	 end.
        { yywobmfmmta.i
          &file = "xxpower_det"
          &where = "where (xxpower_det.xxpower_domain = global_domain and
	            xxpower_value = codeValue)"
          &frame = "F-B"
          &fieldlist = "
                          xxpower_line
                          xxpower_fr        
                          xxpower_to
                       "
          &prompt     = "xxpower_line"
	  &index      = "USE-INDEX xxpower_value"
          &midchoose  = "color messages"
          &predisplay = "~ run xxpro-m-predisplay. ~ "
	  &inskey     = "A"
          &inscode    = "~ run xxpro-m-add. ~  " 
	  &delkey     = "D"
          &delcode    = "~ run xxpro-m-delete. ~ "  
          &updkey     = "Enter"
          &updcode    = "~ run xxpro-m-update. ~ "  
	  
        }

    end. /*MAIN BLOCK */
end.

/*----------------------------------------------------------*/

PROCEDURE xxpro-m-predisplay.
    message "已完成记录更新。".
    hide message no-pause.     
END PROCEDURE.

PROCEDURE xxpro-m-update.
    
   find xxpower_det where recid(xxpower_det) = w-rid[Frame-line(F-B)]
    no-lock no-error.

    if not available xxpower_det then leave .
    RUN xxpro-access-check(OUTPUT accessOk).
    IF accessOk = NO THEN LEAVE.

    find xxpower_det where recid(xxpower_det) = w-rid[Frame-line(F-B)]
    no-error.
     update xxpwaction = "修改".
    clear frame F-C ALL no-pause.
    display
        xxpower_line
	xxpower_fr
	xxpower_to
    with frame F-C.
    UPDATE
        xxpower_line
	xxpower_fr
	xxpower_to
    with frame F-C.

    do i = 1 to length(input xxpower_line):
     if substring(input xxpower_line,i,1) <> "0" and substring(input xxpower_line,i,1) <> "1"
        and substring(input xxpower_line,i,1) <> "2" and substring(input xxpower_line,i,1) <> "3"
        and substring(input xxpower_line,i,1) <> "4" and substring(input xxpower_line,i,1) <> "5"
        and substring(input xxpower_line,i,1) <> "6" and substring(input xxpower_line,i,1) <> "7"
        and substring(input xxpower_line,i,1) <> "8" and substring(input xxpower_line,i,1) <> "9"
         then do: 
	   message "序号只能为数值或为空！".
	   next-prompt xxpower_line.
	   undo,retry.
	   end.
    end.
    
    HIDE FRAME F-C NO-PAUSE.
END PROCEDURE.

PROCEDURE xxpro-m-add.

    RUN xxpro-access-check(OUTPUT accessOk).
    IF accessOk = NO THEN LEAVE.

    update xxpwaction = "添加".
    clear frame F-C ALL no-pause.

    REPEAT WITH FRAME F-C:
       prompt-for 
           xxpower_line
	   xxpower_fr
	   xxpower_to
       WITH FRAME F-C.
       
       do i = 1 to length(input xxpower_line):
     if substring(input xxpower_line,i,1) <> "0" and substring(input xxpower_line,i,1) <> "1"
        and substring(input xxpower_line,i,1) <> "2" and substring(input xxpower_line,i,1) <> "3"
        and substring(input xxpower_line,i,1) <> "4" and substring(input xxpower_line,i,1) <> "5"
        and substring(input xxpower_line,i,1) <> "6" and substring(input xxpower_line,i,1) <> "7"
        and substring(input xxpower_line,i,1) <> "8" and substring(input xxpower_line,i,1) <> "9"
         then do: 
	   message "序号只能为数值或为空！".
	   next-prompt xxpower_line.
	   undo,retry.
	   end.
     end.


       find first xxpower_det where xxpower_det.xxpower_domain = global_domain
	and xxpower_value = codeValue and input xxpower_line = xxpower_line 
	and input xxpower_fr = xxpower_fr and input xxpower_to = xxpower_to no-error.

       if available xxpower_det then do :
            message "已存在相同记录,请重新输入！".
	    NEXT-PROMPT xxpower_line.
            UNDO,RETRY.
           end.
      

       create xxpower_det.
       assign
           xxpower_domain = global_domain
           xxpower_value = codeValue
	   xxpower_dttm = datetime(TODAY,TIME)
           xxpower_line  = input xxpower_line
	   xxpower_fr    = input xxpower_fr
	   xxpower_to    = input xxpower_to.
	  w-newrecid = recid(xxpower_det).
       DOWN 1 WITH FRAME F-C.
   END.
   HIDE FRAME F-C NO-PAUSE.
END PROCEDURE.

PROCEDURE xxpro-m-delete.

    find xxpower_det where recid(xxpower_det) = w-rid[Frame-line(F-B)]
    no-lock no-error.
    if not available xxpower_det THEN LEAVE.
    RUN xxpro-access-check(OUTPUT accessOk).
    IF accessOk = NO THEN LEAVE.

    find xxpower_det where recid(xxpower_det) = w-rid[Frame-line(F-B)]
    no-error.
    assign xxpwconfirm = NO.
    {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=xxpwconfirm}
    if xxpwconfirm and available xxpower_det then  do:
        delete xxpower_det.
    end. 

END PROCEDURE.

/********************/
PROCEDURE xxpro-access-check:
    DEFINE OUTPUT PARAMETER accessOk AS LOGICAL.
    accessOk = NO.
    FIND FIRST code_mstr WHERE  code_mstr.code_domain = global_domain
    AND code_fldname = "XX-DCEC0001" AND code_value = codeValue NO-LOCK NO-ERROR.
    IF AVAILABLE code_mstr THEN accessOk = YES.
END PROCEDURE.
