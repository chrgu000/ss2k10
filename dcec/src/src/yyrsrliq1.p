
/* DISPLAY TITLE */

{mfdtitle.i "f+"}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

DEF VARIABLE v_ponbr LIKE po_nbr.
DEF VARIABLE v_part1 LIKE pt_part.
DEF VARIABLE v_part2 LIKE pt_part.
DEF VARIABLE v_batch AS   INTEGER INITIAL 0.
DEF VARIABLE v_releaseid LIKE schd_rlse_id.

DEF VARIABLE v_rptfmt AS LOGICAL INITIAL NO FORMAT "1-标准输出/2-浏览输出".

DEF TEMP-TABLE xxwk1 RCODE-INFORMATION
    FIELDS xxwk1_ponbr      LIKE po_nbr
    FIELDS xxwk1_poline     LIKE pod_line
    FIELDS xxwk1_part       LIKE pt_part 
    FIELDS xxwk1_desc2      LIKE pt_desc1            LABEL "描述(中文)"
    FIELDS xxwk1_desc1      LIKE pt_desc1            LABEL "描述(英文)"
    FIELDS xxwk1_active     AS LOGICAL               LABEL "激活状态" INITIAL NO
    FIELDS xxwk1_releaseid  LIKE schd_rlse_id
    FIELDS xxwk1_edi_batch  AS   INTEGER             LABEL "EDI批处理号"
    FIELDS xxwk1_edi_date   AS   CHAR                LABEL "EDI下载时间" FORMAT "x(20)"
    INDEX xxwk1_idx1 xxwk1_ponbr xxwk1_part.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_ponbr  COLON 20
    v_part1  COLON 20
    v_part2  COLON 40 LABEL "至"
    v_releaseid COLON 20
    v_batch  COLON 20 LABEL "EDI批处理号"
    v_rptfmt COLON 20 LABEL "输出格式" "(1-标准输出/2-浏览输出)"
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



DEFINE FRAME WaitingFrame 
        "处理中，请稍候..." 
        SKIP
WITH VIEW-AS DIALOG-BOX.

REPEAT:
    IF v_part2 = hi_char THEN v_part2 = "".

    VIEW FRAME a.
    UPDATE 
        v_ponbr
        v_part1 v_part2
        v_releaseid
        v_batch
        v_rptfmt
        WITH FRAME a.

    IF v_part2 = "" THEN v_part2 = hi_char.
    

    IF v_rptfmt = YES THEN DO:
        /*review*/ 
        {mfselprt.i "terminal" 80}
    END.

    RUN xxpro-bud1.

    IF v_rptfmt = YES THEN DO:
        RUN xxpro-report1.
        {mfreset.i}
        {mfgrptrm.i} 
    END.
    IF v_rptfmt = NO THEN DO:
        RUN xxpro-report2.
    END.
END.


/************************/
PROCEDURE xxpro-bud1:
    DEF VAR v_bid AS INTEGER.
    DEF VAR v_bdate AS CHAR.

    FOR EACH xxwk1:
        DELETE xxwk1.
    END.

    FOR EACH po_mstr 
        WHERE po_nbr = v_ponbr
        AND (po_sched = YES)
        NO-LOCK:


        FOR EACH pod_det NO-LOCK 
            WHERE pod_nbr = po_nbr /*AND pod_site = v_ship_to*/
            AND pod_sched = YES
            AND pod_part >= v_part1 AND pod_part <= v_part2
            /*AND (pod_start_eff[1] >= TODAY OR pod_start_eff[1] = ?)
            AND (pod_end_eff[1] >= TODAY OR pod_end_eff[1] = ?)*/
            :
            FOR EACH sch_mstr 
                where sch_type = 4
                and sch_nbr = pod_nbr 
                and sch_line = pod_line 
                and (sch_rlse_id = v_releaseid OR v_releaseid = "")
                NO-LOCK:
                v_bid = 0.
                IF sch_ship <> "" THEN DO:
                    v_bid = INTEGER(SUBSTRING(sch_ship,17,8)).
                    v_bdate = SUBSTRING(sch_ship,1,8) + " " + SUBSTRING(sch_ship,9,8).
                END.
                IF v_batch = v_bid OR v_batch = 0 THEN DO:
                    CREATE xxwk1.
                    ASSIGN
                        xxwk1_ponbr = po_nbr
                        xxwk1_poline = pod_line
                        xxwk1_part   = pod_part
                        xxwk1_releaseid = sch_rlse_id
                        xxwk1_edi_batch = v_bid
                        xxwk1_edi_date =  v_bdate
                        .
                    IF sch_rlse_id = pod_curr_rlse_id[1]  THEN xxwk1_active = YES.
                    FIND FIRST pt_mstr WHERE pt_part = xxwk1_part NO-LOCK NO-ERROR.
                    IF AVAILABLE pt_mstr THEN ASSIGN xxwk1_desc1 = pt_desc1 xxwk1_desc2 = pt_desc2.
                END.
            END.
        END.
    END.

END PROCEDURE.



/************************/
PROCEDURE xxpro-report1:
    FOR EACH xxwk1 NO-LOCK:
        DISP xxwk1
WITH WIDTH 255 STREAM-IO.
    END.
END PROCEDURE.
/************************/
PROCEDURE xxpro-report2:
    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE xxwk1:HANDLE.

    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yyrsrliq1", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").

END PROCEDURE.





