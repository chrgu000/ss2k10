/* DISPLAY TITLE */
{mfdtitle.i "f+"}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.


DEF VAR v_date1 AS DATE.
DEF VAR v_date2 AS DATE.
DEF VAR v_trfid AS CHAR.

DEF TEMP-TABLE xxwk1 RCODE-INFORMATION
    FIELDS xxwk1_trfid AS CHAR LABEL "传输控制码"
    FIELDS xxwk1_date  AS DATE LABEL "日期"
    FIELDS xxwk1_time  AS CHAR LABEL "时间"
    FIELDS xxwk1_sname AS CHAR LABEL "日志文件" FORMAT "x(30)"
    FIELDS xxwk1_fname AS CHAR LABEL "日志文件全路径" FORMAT "x(80)"
    INDEX xxwk1_idx1 xxwk1_date xxwk1_time.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_trfid    LABEL "传输控制码"     COLON 15
    v_date1    LABEL "日期"  COLON 15
    v_date2    LABEL "至"     COLON 40
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

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

define variable v_key          as character.
v_key = "XXEDADDPM".
DEF VAR v_dirbox AS CHAR.


REPEAT :
    IF v_date1 = low_date THEN v_date1 = ?.
    IF v_date2 = hi_date THEN v_date2 = ?.
    UPDATE 
        v_trfid
        v_date1
        v_date2
        WITH FRAME a.
    IF v_date1 = ? THEN v_date1 = low_date.
    IF v_date2 = ? THEN v_date2 = hi_date.
    FIND FIRST usrw_wkfl WHERE usrw_key1 = v_key AND usrw_key2 = v_trfid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE usrw_wkfl THEN DO:
        MESSAGE "No ID defined".
        UNDO, RETRY.
    END.
    v_dirbox = usrw_charfld[4].
    RUN xxpro-bud (INPUT v_dirbox).
    RUN xxpro-report.
END.

/****************/
PROCEDURE xxpro-bud:
    DEF INPUT PARAMETER p_dirbox AS CHAR NO-UNDO.
    DEF VAR v_data AS CHAR EXTENT 10.
    DEF VAR v_fdate AS DATE.
    DEF VAR v_ftime AS CHAR.

    FOR EACH xxwk1:
        DELETE xxwk1.
    END.

    IF p_dirbox = "" THEN LEAVE.

    INPUT FROM OS-DIR(p_dirbox).
    REPEAT:
        v_data = "".
            IMPORT v_data[1] v_data[2] v_data[3].
            IF v_data[3] = "F" THEN DO:
                v_data[10] = ENTRY(2,v_data[1], ".").
                v_fdate = DATE(INTEGER(SUBSTRING(v_data[10],5,2)), 
                               INTEGER(SUBSTRING(v_data[10],7,2)),
                               INTEGER(SUBSTRING(v_data[10],1,4))
                               ).
                v_ftime = ENTRY(3,v_data[1], ".").
                IF v_fdate < v_date1 OR v_fdate > v_date2 THEN NEXT.

                CREATE xxwk1.
                ASSIGN 
                    xxwk1_trfid = v_trfid
                    xxwk1_sname = v_data[1]
                    xxwk1_fname = v_data[2]
                    xxwk1_date  = v_fdate
                    xxwk1_time  = v_ftime.
            END.
    END.
    INPUT CLOSE.
END PROCEDURE.

/****************/
PROCEDURE xxpro-report:
    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE xxwk1:HANDLE.
    FIND FIRST xxwk1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN LEAVE.
    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yyedut002", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "传输日志清单",
                                         INPUT "xxwk1_fname",
                                         INPUT "yyedut002a.p",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").

END PROCEDURE.

