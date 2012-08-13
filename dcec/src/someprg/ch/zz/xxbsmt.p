/*Cai Jing * ABF BIN-ON-SHELF MAINT * 2010-3-28*/
{mfdtitle.i}

DEF VAR bin LIKE xxbs_bin.
DEF VAR date1 LIKE xxbs_date .
DEF VAR yn AS LOG .


FORM 
    bin COLON 20 SKIP
    date1 COLON 20 SKIP
    xxbs_shelf COLON 20 SKIP
WITH FRAME a SIDE-LABELS WIDTH 80 THREE-D .

REPEAT:
    CLEAR FRAME a NO-PAUSE .
    yn = NO .

    PROMPT-FOR bin date1 WITH FRAME a EDITING:
        {mfnp.i xxbs_det bin xxbs_bin bin xxbs_bin xxbs_bin}
        IF recno <> ? THEN DISPLAY xxbs_bin @ bin LABEL "零件号" xxbs_date @ date1 LABEL "日期" xxbs_shelf LABEL "数量" WITH FRAME a .
                          
    END.

    ASSIGN bin date1.


   FIND pt_mstr  WHERE pt_part = bin NO-LOCK NO-ERROR.
         if not available pt_mstr then do:
	  							message "零件不存在，请重新输入" view-as alert-box.
	  						    next-prompt bin with frame a.
	  							undo, retry.
	  						end.
    
    DO TRANSACTION ON ERROR UNDO ,LEAVE :
        FIND xxbs_det WHERE xxbs_bin = bin AND xxbs_date = date1
            USE-INDEX xxbs_bin EXCLUSIVE-LOCK NO-ERROR .
        IF NOT AVAILABLE xxbs_det THEN DO :
            CREATE xxbs_det .
            xxbs_bin = bin .
            xxbs_date = date1.
        END.

        stSTATUS = stline[2].
        STATUS INPUT ststatus.

        UPDATE xxbs_shelf GO-ON("F5" "CTRL-D") WITH FRAME a .
    
        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D") THEN DO:
            yn = YES.
            MESSAGE "确认删除这条记录吗?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE yn.
            IF yn THEN DO:
                DELETE xxbs_det.
                NEXT .
            END.
        END. /*if delete*/
    END. /*do transaction*/


FOR EACH xxbs_det WHERE xxbs_date >= TODAY NO-LOCK:
    DISP xxbs_bin LABEL "零件号" xxbs_date LABEL "日期" xxbs_shelf LABEL "数量" .
END.

END. /*repeat*/


