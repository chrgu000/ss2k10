/*xxedut001.p - transfer message file*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

DEFINE VARIABLE v_tpid   AS CHARACTER FORMAT "x(20)" LABEL "EDI ID" NO-UNDO.
DEFINE VARIABLE v_name   AS CHARACTER FORMAT "x(40)" LABEL "名称" NO-UNDO.
DEFINE VARIABLE v_group  AS CHAR.
DEFINE VARIABLE v_key1   AS CHAR.

DEFINE TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_flag    AS LOGICAL LABEL "发送" INITIAL YES
    FIELDS ttt1_fname   AS CHARACTER FORMAT "x(30)" LABEL "文件名称"
    FIELDS ttt1_type    AS CHARACTER FORMAT "x(10)"  LABEL "类型"
    FIELDS ttt1_group   AS CHAR      FORMAT "x(12)" LABEL "传输组"
    FIELDS ttt1_ddir    AS CHARACTER FORMAT "x(80)" LABEL "原始文件路径"
    FIELDS ttt1_wdir    AS CHARACTER FORMAT "x(80)" LABEL "传输工作路径"
    FIELDS ttt1_bdir    AS CHARACTER FORMAT "x(80)" LABEL "备份文件路径"
    FIELDS ttt1_ldir    AS CHARACTER FORMAT "x(80)" LABEL "传输日志路径"
    FIELDS ttt1_batname AS CHARACTER FORMAT "x(80)" LABEL "传输脚本"
    FIELDS ttt1_prg     AS CHAR
    .

DEFINE TEMP-TABLE ttt2
    FIELDS ttt2_group AS CHAR
    FIELDS ttt2_dir   AS CHAR
    FIELDS ttt2_prg   AS CHAR.

DEFINE STREAM s1.

DEFINE FRAME WaitingFrame 
        "传输处理中，请稍候..." 
        SKIP
        v_name NO-LABEL
        SKIP
WITH VIEW-AS DIALOG-BOX.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    edtp_tp_id
    edtp_tp_name
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D 1 COLUMN.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", 
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

REPEAT:
    v_key1 = "XXEDADDPM".
    PROMPT-FOR edtp_tp_id WITH FRAME a EDITING:
        IF FRAME-FIELD = "edtp_tp_id" THEN DO:
            {mfnp.i
             edtp_mstr
             edtp_tp_id
             edtp_tp_id
             edtp_tp_id
             edtp_tp_id
             edtp_tp_id}

            if recno <> ? then
            display
                edtp_tp_id
                edtp_tp_name
            with frame a.
        END.
        ELSE DO:
            status input.
            readkey.
            apply lastkey.
        END.
    END.
    ASSIGN v_tpid = INPUT FRAME a edtp_tp_id.

    FIND FIRST edtp_mstr WHERE edtp_tp_id = v_tpid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE edtp_mstr THEN DO:
        MESSAGE "无效的EDI ID".
        UNDO, RETRY.
    END.
    DISPLAY edtp_tp_name WITH FRAME a.

    RUN xxpro-initial.
    RUN xxpro-get-fname.
    RUN xxpro-view.
    RUN xxpro-process.
END.

/****************/
PROCEDURE xxpro-initial:
    FOR EACH ttt1:
        DELETE ttt1.
    END.
    FOR EACH ttt2:
        DELETE ttt2.
    END.
END PROCEDURE.
/****************/
PROCEDURE xxpro-get-fname:
    DEFINE VARIABLE v_data AS CHAR EXTENT 5.
    v_group = "".
    FIND FIRST edtp_mstr WHERE edtp_tp_id = v_tpid NO-LOCK NO-ERROR.
    FOR EACH edtpd_det NO-LOCK WHERE edtpd_tp_id = edtp_tp_id
        AND edtpd_doc_in = NO:
        FIND FIRST ttt2 WHERE ttt2_group = edtpd_dtg_name NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttt2 THEN DO:
            CREATE ttt2.
            ASSIGN ttt2_group = edtpd_dtg_name.
            FIND FIRST edtg_mstr WHERE edtg_dtg_name = edtpd_dtg_name NO-LOCK NO-ERROR.
            IF AVAILABLE edtg_mstr THEN DO:
                ASSIGN 
                    ttt2_dir = edtg_dest_dir
                    ttt2_prg = edtg__qadc01.
            END.
        END.
    END.
    FOR EACH ttt2 WHERE ttt2_dir <> "" AND ttt2_prg <> "":
        FIND FIRST usrw_wkfl WHERE usrw_key1 = v_key1 AND usrw_key2 = ttt2_prg NO-LOCK NO-ERROR.
        IF NOT AVAILABLE usrw_wkfl THEN NEXT.

        INPUT FROM OS-DIR(ttt2_dir).
        REPEAT:
            v_data = "".
            IMPORT v_data[1] v_data[2] v_data[3].
            IF v_data[3] = "F" THEN DO:
                CREATE ttt1.
                ASSIGN 
                    ttt1_fname = v_data[1]
                    ttt1_ddir  = ttt2_dir.
                ASSIGN 
                    ttt1_group = ttt2_group
                    ttt1_prg   = ttt2_prg
                    ttt1_wdir  = usrw_charfld[2]
                    ttt1_bdir  = usrw_charfld[3]
                    ttt1_ldir  = usrw_charfld[4]
                    ttt1_bat   = usrw_charfld[5].
                IF ttt1_ldir = "" THEN ttt1_ldir = ttt2_dir.
            END.
        END.
        INPUT CLOSE.
    END.
    FOR EACH ttt1:
        INPUT CLOSE.
        INPUT FROM VALUE(ttt1_ddir + "\" + ttt1_fname).
        REPEAT:
            v_data = "".
            IMPORT UNFORMATTED v_data[1].
            IF SUBSTRING(v_data[1],1,4) = "UNH1" THEN DO:
                ASSIGN ttt1_type = SUBSTRING(v_data[1],5,10).
                LEAVE.
            END.
        END.
        INPUT CLOSE.
        /*FIND FIRST CODE_mstr WHERE CODE_fldname = "prefix-" + v_tpid
            AND CODE_value = ""*/
    END.
END PROCEDURE.
/****************/
PROCEDURE xxpro-view:
    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE ttt1:HANDLE.
    FIND FIRST ttt1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttt1 THEN LEAVE.
    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yyedut001", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "传输文件清单",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "ttt1_flag",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
END PROCEDURE.
/****************/
PROCEDURE xxpro-process:
    DEF VAR v_fullname AS CHAR EXTENT 5.

    FIND FIRST ttt1 WHERE ttt1_flag = YES NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttt1 THEN DO:
        MESSAGE "没有要传输的文件" VIEW-AS ALERT-BOX BUTTONS OK.  
    END.
    ELSE DO:
        MESSAGE "确认" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
        IF choice = NO THEN LEAVE.
        FOR EACH ttt1 WHERE ttt1_flag = YES:
            v_fullname = "".
            v_fullname[1] = ttt1_ddir + "\" + ttt1_fname.
            v_fullname[2] = ttt1_wdir + "\" + ttt1_fname.
            v_fullname[3] = ttt1_bdir + "\" + ttt1_fname.
            /*put to work dir*/
            IF v_fullname[1] <> v_fullname[2] THEN DO:
                OS-COPY VALUE(v_fullname[1]) VALUE(v_fullname[2]).
            END.
            /*backup*/
            IF v_fullname[1] <> v_fullname[3] THEN DO:
                OS-COPY VALUE(v_fullname[1]) VALUE(v_fullname[3]).
                IF SEARCH(v_fullname[1]) <> ? AND SEARCH(v_fullname[3]) <> ? THEN OS-DELETE VALUE(v_fullname[1]).
            END.
            /*create log*/
            RUN xxpro-log (INPUT RECID(ttt1)).
        END.
        MESSAGE "传输完毕" VIEW-AS ALERT-BOX BUTTONS OK.  
    END.
END PROCEDURE.
/****************/
PROCEDURE xxpro-log:
    DEFINE INPUT PARAMETER p_recid AS RECID.
    
    FIND FIRST ttt1 WHERE RECID(ttt1) = p_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttt1 THEN LEAVE.
    v_name = ttt1_fname.
    
    VIEW FRAME waitingframe.
    DISPLAY v_name WITH FRAME  waitingframe.
    PAUSE 1 NO-MESSAGE.
    FIND FIRST usrw_wkfl WHERE usrw_key1 = "EDI-TRF-LOG"
        AND usrw_key2 = ttt1_fname
        NO-ERROR.
    IF NOT AVAILABLE usrw_wkfl THEN DO:
        CREATE usrw_wkfl.
        ASSIGN usrw_key1 = "EDI-TRF-LOG"
               usrw_key2 = ttt1_fname.
    END.
    ASSIGN 
        usrw_charfld[1] = GLOBAL_userid
        usrw_datefld[1]  = TODAY
        usrw_decfld[1]  = TIME.

    HIDE FRAME waitingframe NO-PAUSE.


END PROCEDURE.


