
/* DISPLAY TITLE */

{mfdtitle.i "20121024.1"}

DEF VARIABLE v_acct LIKE glt_acct.
DEF VARIABLE v_date1 LIKE glt_effdate.
DEF VARIABLE v_date2 LIKE glt_effdate.
DEF VARIABLE v_entity LIKE glt_entity.
DEF VARIABLE v_rptfmt AS LOGICAL INITIAL NO FORMAT "1-标准输出/2-浏览输出".
DEF VARIABLE v_showdet AS LOGICAL INITIAL NO LABEL "显示明细".

DEF NEW SHARED TEMP-TABLE xxwk1 RCODE-INFORMATION
    FIELDS xxwk1_ref      LIKE glt_ref
    FIELDS xxwk1_line     LIKE glt_line
    FIELDS xxwk1_acct     LIKE glt_acct
    FIELDS xxwk1_sub      LIKE glt_sub
    FIELDS xxwk1_cc       LIKE glt_cc
    FIELDS xxwk1_pj       LIKE glt_proj
    FIELDS xxwk1_amt      LIKE glt_amt
    FIELDS xxwk1_desc     LIKE glt_desc
    FIELDS xxwk1_doc      LIKE glt_doc
    fields xxwk1_date     like gltr_eff_dt
    FIELDS xxwk1_part     LIKE pt_part
    FIELDS xxwk1_type     AS   CHARACTER  LABEL "类型"
    INDEX xxwk1_idx1 xxwk1_acct xxwk1_sub xxwk1_cc
    INDEX xxwk1_idx2 xxwk1_part.

DEF NEW SHARED TEMP-TABLE xxwk2 RCODE-INFORMATION
    FIELDS xxwk2_part     LIKE pt_part
    FIELDS xxwk2_desc     LIKE pt_desc1
    FIELDS xxwk2_amt0     LIKE glt_amt LABEL "总差异"
    FIELDS xxwk2_amt1     LIKE glt_amt LABEL "量差"
    FIELDS xxwk2_amt2     LIKE glt_amt LABEL "率差"
    FIELDS xxwk2_amt3     LIKE glt_amt LABEL "方法差"
    FIELDS xxwk2_amt4     LIKE glt_amt LABEL "其他"
    FIELDS xxwk2_amt5     LIKE glt_amt LABEL "调整"
    INDEX xxwk2_idx1 xxwk2_part.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_entity COLON 20
    v_acct   COLON 20
    v_date1  COLON 20
    v_date2  COLON 40 LABEL "TO"
    v_rptfmt COLON 20 LABEL "输出格式" "(1-标准输出/2-浏览输出)"
    v_showdet COLON 20 
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
    VIEW FRAME a.
    UPDATE 
        v_entity
        v_acct
        v_date1
        v_date2
        v_rptfmt
        v_showdet
        WITH FRAME a.

    IF v_rptfmt = YES THEN DO:
        /*review*/ 
        {mfselprt.i "terminal" 80}
    END.

    RUN xxpro-bud.

    IF v_rptfmt = YES THEN DO:
        RUN xxpro-report1.
        {mfreset.i}
        {mfgrptrm.i} /*Report-to-Window*/
    END.
    IF v_rptfmt = NO THEN DO:
        RUN xxpro-report2.
    END.
END.


/*****************/
PROCEDURE xxpro-bud:
    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    FOR EACH gltr_hist NO-LOCK 
        WHERE gltr_domain = global_domain and gltr_entity = v_entity
        AND gltr_acc      = v_acct
        AND gltr_eff_dt >= v_date1 AND gltr_eff_dt <= v_date2
        USE-INDEX gltr_ind1:
        CREATE xxwk1.
        ASSIGN 
            xxwk1_ref  = gltr_ref
            xxwk1_line = gltr_line
            xxwk1_acct = gltr_acc
            xxwk1_sub  = gltr_sub
            xxwk1_cc   = gltr_ctr
            xxwk1_pj   = gltr_proj
            xxwk1_desc = gltr_desc
            xxwk1_amt  = gltr_amt
            xxwk1_part = ""
            xxwk1_type = ""
            xxwk1_doc = gltr_doc
            xxwk1_date = gltr_eff_dt.
    END.
    FOR EACH xxwk1:
        IF xxwk1_ref BEGINS "WO" THEN DO:
            FOR FIRST op_hist FIELDS (op_trnbr op_part)
                use-index op_trnbr 
                where op_domain = global_domain and op_trnbr = integer(xxwk1_doc)
                NO-LOCK: END.
            IF AVAILABLE op_hist THEN DO:
                xxwk1_part = op_part.
                IF xxwk1_desc BEGINS "CLOSE" THEN ASSIGN xxwk1_type = "3".
                ELSE IF xxwk1_desc BEGINS "MUV-CMP" THEN ASSIGN xxwk1_type = "1".
                ELSE IF xxwk1_desc BEGINS "RATE VAR" THEN ASSIGN xxwk1_type = "2".
                ELSE IF xxwk1_desc BEGINS "ISS-WO" THEN ASSIGN xxwk1_type = "2".
                ELSE IF xxwk1_desc BEGINS "MATL-VAR" THEN ASSIGN xxwk1_type = "1".
                ELSE ASSIGN xxwk1_type = "4".
            END.
            ELSE DO:
                ASSIGN 
                    xxwk1_part = "MISS OP"
                    xxwk1_type = "5".
            END.
        END.
        ELSE IF xxwk1_ref BEGINS "IC" THEN DO:
            FOR FIRST tr_hist FIELDS (tr_trnbr tr_lot)
                use-index tr_trnbr
                where tr_domain = global_domain and tr_trnbr = integer(xxwk1_doc)
                NO-LOCK: END.
            IF AVAILABLE tr_hist THEN DO:
                FOR FIRST wo_mstr FIELDS (wo_domain wo_lot wo_part)
                    use-index wo_lot
                    where wo_domain = global_domain and wo_lot = tr_lot
                    NO-LOCK: END.
                IF AVAILABLE wo_mstr THEN DO:
                    xxwk1_part = wo_part.
                    IF xxwk1_desc BEGINS "MTHD CHG" THEN ASSIGN xxwk1_type = "3".
                    ELSE IF xxwk1_desc BEGINS "MUV-CMP" THEN ASSIGN xxwk1_type = "1".
                    ELSE IF xxwk1_desc BEGINS "RATE VAR" THEN ASSIGN xxwk1_type = "2".
                    ELSE IF xxwk1_desc BEGINS "ISS-WO" THEN ASSIGN xxwk1_type = "2".
                    ELSE IF xxwk1_desc BEGINS "MATL-VAR" THEN ASSIGN xxwk1_type = "1".
                    ELSE ASSIGN xxwk1_type = "4".
                END.
                ELSE DO:                    
                    ASSIGN 
                        xxwk1_part = "MISS WO"
                        xxwk1_type = "5".
                END.
            END.
            ELSE DO:
                ASSIGN 
                    xxwk1_part = "MISS TR"
                    xxwk1_type = "5".
            END.
        END.
        ELSE DO:
            ASSIGN 
                xxwk1_part = "其他调整"
                xxwk1_type = "5".
        END.
        FIND FIRST xxwk2 WHERE xxwk2_part = xxwk1_part NO-ERROR.
        IF NOT AVAILABLE xxwk2 THEN DO:
            CREATE xxwk2.
            ASSIGN xxwk2_part = xxwk1_part.
            FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = xxwk2_part NO-LOCK NO-ERROR.
            IF AVAILABLE pt_mstr THEN ASSIGN xxwk2_desc = pt_desc1.
        END.
        CASE xxwk1_type:
            WHEN "1" THEN ASSIGN xxwk2_amt1 = xxwk2_amt1 + xxwk1_amt.
            WHEN "2" THEN ASSIGN xxwk2_amt2 = xxwk2_amt2 + xxwk1_amt.
            WHEN "3" THEN ASSIGN xxwk2_amt3 = xxwk2_amt3 + xxwk1_amt.
            WHEN "4" THEN ASSIGN xxwk2_amt4 = xxwk2_amt4 + xxwk1_amt.
            OTHERWISE    ASSIGN xxwk2_amt5 = xxwk2_amt5 + xxwk1_amt.
        END CASE.
    END.
    FOR EACH xxwk2:
        xxwk2_amt0 = xxwk2_amt1 + xxwk2_amt2 + xxwk2_amt3 + xxwk2_amt4 + xxwk2_amt5. 
    END.
END PROCEDURE.
/*****************/
PROCEDURE xxpro-report1:
    FOR EACH xxwk2:
        DISP xxwk2 WITH WIDTH 255 STREAM-IO.
    END.
    IF v_showdet = NO THEN LEAVE.
    FOR EACH xxwk1:
        DISP  
            xxwk1_ref   
            xxwk1_line  
            xxwk1_acct  
            xxwk1_sub   
            xxwk1_cc    
            xxwk1_pj    
            xxwk1_amt   
            xxwk1_desc  
            xxwk1_doc   
            xxwk1_date  
            xxwk1_part  
        WITH WIDTH 255 STREAM-IO.
    END.
END PROCEDURE.
/*****************/
PROCEDURE xxpro-report2:
    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE xxwk2:HANDLE.

    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yyacctvarrp2", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "差异汇总",
                                         INPUT "xxwk2_part",
                                         INPUT "yyacctvarrp2a.p",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").

END PROCEDURE.

