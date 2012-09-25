/* DISPLAY TITLE */
{mfdtitle.i "f+"}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.


DEF VAR v_ok         AS LOGICAL.
DEF VAR v_confirm    AS LOGICAL.
DEF VAR v_sys_status AS CHAR.
DEF VAR v_flag       AS CHAR.

DEF VAR v_fexcel     AS CHAR FORMAT "x(55)".
DEF VAR v_fdir       AS CHAR.
DEF VAR v_sheet      AS INTEGER INITIAL 1.

DEFINE TEMP-TABLE xxwk1 
    FIELDS xxwk1_asn_nbr      AS CHAR LABEL "ASN编号"
    FIELDS xxwk1_box_nbr      AS CHARACTER LABEL "箱子号"
    FIELDS xxwk1_cnt_nbr      AS CHARACTER LABEL "集装箱号" FORMAT "x(20)"
    FIELDS xxwk1_err          AS LOGICAL INITIAL NO LABEL "错误"
    INDEX xxwk1_idx1 xxwk1_asn_nbr xxwk1_box_nbr.
DEFINE TEMP-TABLE xxwk2 
    FIELDS xxwk2_asn_nbr      AS CHAR LABEL "ASN编号"
    FIELDS xxwk2_err          AS LOGICAL INITIAL NO LABEL "错误"
    FIELDS xxwk2_shipfr_code  AS CHARACTER LABEL "发货地点"
    FIELDS xxwk2_shipfr_name  AS CHARACTER LABEL "名称" FORMAT "x(28)"
    FIELDS xxwk2_shipto_code  AS CHARACTER LABEL "收货地点"
    FIELDS xxwk2_shipto_name  AS CHARACTER LABEL "名称" FORMAT "x(28)"
    INDEX xxwk2_idx1 xxwk2_asn_nbr.

DEF TEMP-TABLE xxwk4
    FIELDS xxwk4_line   AS INTEGER LABEL "行号" FORMAT ">>>>"
    FIELDS xxwk4_error  AS CHAR    LABEL "错误" FORMAT "x(60)"
    .

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_fexcel LABEL "上载文件" COLON 10
    SKIP
    v_sheet LABEL "工作薄号"  COLON 10
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


REPEAT:
    UPDATE
        v_fexcel 
        WITH FRAME a.
    v_ok = YES.
    IF v_fexcel = "" THEN DO:
        v_ok = NO.
        SYSTEM-DIALOG GET-FILE v_fexcel 
            TITLE "请选择数据文件..."        
            FILTERS "Source Files (*.xls)"   "*.xls"
            INITIAL-DIR v_fdir
            MUST-EXIST
            USE-FILENAME
            UPDATE v_ok.
        DISP v_fexcel WITH FRAME a.
    END.
    IF v_ok = YES THEN DO:
        UPDATE
            v_sheet
            WITH FRAME a.
    END.
    ELSE DO:
        UNDO, RETRY.
    END.
    
    IF v_fexcel = "" THEN UNDO, RETRY.

    RUN xxpro-excel (OUTPUT v_sys_status).
    FIND FIRST xxwk1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN UNDO, RETRY.
    
    /*review*/ 

    {mfselprt.i "terminal" 80}
    RUN xxpro-check.
    RUN xxpro-report.
    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/

    FIND FIRST xxwk4 NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk4 THEN DO:
        MESSAGE "数据存在错误，不能上载." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    ELSE DO:
        v_confirm = NO.
        MESSAGE "确认要上载所显示的数据" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_confirm.
        IF v_confirm = YES THEN DO:
            RUN xxpro-load.
        END.
    END.
END.

/*---------------------------*/
PROCEDURE xxpro-excel:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.
    
    DEF VAR iRow   AS INTEGER.
    def var iError as integer.
    def var iWarning as integer.

    DEF VAR v_data AS CHAR EXTENT 20.
    DEF VAR i      AS INTEGER.

    CREATE "Excel.Application" chExcel.
    
    /*chWorkbook  =  chExcel:Workbooks:OPEN(v_filename1).*/
    chWorkbook = chExcel:Workbooks:OPEN(v_fexcel,0,true,,,,true).
    chWorkSheet =  chWorkbook:workSheets(v_sheet).
    chExcel:visible = NO.



    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    FOR EACH xxwk4:
        DELETE xxwk4.
    END.

    /* read EXCEL file and load data begin..*/
    iRow = 1.
    /*
    IF STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,"A"):value) <> "发货装箱单" THEN DO:
        MESSAGE "这不是发货装箱单，不能上载." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        LEAVE.
    END.*/


    iRow = 1.
    REPEAT:
        iRow = iRow + 1.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = "" then leave.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = ? then leave.

        v_data = "".
        do i = 1 to 20:
            v_data[i] = trim(string(chWorkbook:Worksheets(v_sheet):Cells(iRow,i):TEXT)).
        end.
        FIND FIRST xxwk2 
            WHERE xxwk1_asn_nbr = v_data[1]
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE xxwk2 THEN DO:
            CREATE xxwk2.
            ASSIGN xxwk2_asn_nbr = v_data[1].
        END.
        FIND FIRST xxwk1 
            WHERE xxwk1_asn_nbr = v_data[1]
            AND   xxwk1_box_nbr = v_data[2] 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE xxwk1 THEN DO:
            CREATE xxwk1.
            ASSIGN 
                xxwk1_asn_nbr = v_data[1]
                xxwk1_box_nbr = v_data[2] 
                xxwk1_cnt_nbr = v_data[3] 
                .
        END.
    END.
    chExcel:DisplayAlerts = FALSE.
    chWorkbook:CLOSE.
    chExcel:QUIT.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.

    p_sys_status = "0".
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-check:
    DEF VAR i AS INTEGER.
    i = 0.
    FIND FIRST xxwk1 NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN 
            xxwk4_line  = i
            xxwk4_error = "无上载信息". 
        NEXT.
    END.

    FOR EACH xxwk2:
        FIND FIRST ABS_mstr WHERE ABS_type = 's'
            AND ABS_id = "s" + xxwk2_asn_nbr
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ABS_mstr THEN DO:
            ASSIGN xxwk2_err = YES.
            i = i + 1.
            CREATE xxwk4.
            ASSIGN 
                xxwk4_line  = i
                xxwk4_error = "发货单" + xxwk2_asn_nbr + "不存在". 
            NEXT.
        END.
        ASSIGN 
            xxwk2_shipfr_code = ABS_shipfrom
            xxwk2_shipto_code = ABS_shipto.
        FIND FIRST ad_mstr WHERE ad_addr = xxwk2_shipfr_code NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN ASSIGN xxwk2_shipfr_name = ad_name.
        FIND FIRST ad_mstr WHERE ad_addr = xxwk2_shipto_code NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN ASSIGN xxwk2_shipto_name = ad_name.
        FOR EACH xxwk1 WHERE xxwk1_asn_nbr = xxwk2_asn_nbr:
            FIND FIRST ABS_mstr WHERE ABS_type = 's'
                AND ABS_par_id = 's' + xxwk1_asn_nbr
                AND ABS_id BEGINS 'c'
                AND ABS_id = 'c' + xxwk1_box_nbr
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ABS_mstr THEN DO:
                xxwk1_err = YES.
                i = i + 1.
                CREATE xxwk4.
                ASSIGN 
                    xxwk4_line  = i
                    xxwk4_error = "箱子" + Xxwk1_box_nbr + "不存在". 
                NEXT.
            END.
        END.
    END.
END PROCEDURE.


/*---------------------------*/
PROCEDURE xxpro-report:
    FOR EACH xxwk4:
        DISP xxwk4 WITH FRAME f-a DOWN WIDTH 80 STREAM-IO.
    END.
    FOR EACH xxwk2:
        DISP xxwk2 WITH 2 COLUMNS WIDTH 80 STREAM-IO.
        FOR EACH xxwk1 WHERE xxwk1_asn_nbr = xxwk2_asn_nbr:
            DISP 
                xxwk1_box_nbr      
                xxwk1_cnt_nbr      
                xxwk1_err
            WITH FRAME f-b WIDTH 80 DOWN STREAM-IO.
        END.
    END.
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-load:
    FIND FIRST xxwk4 NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk4 THEN LEAVE.
    FOR EACH xxwk1:
        FIND FIRST ABS_mstr WHERE ABS_type = 's'
            AND ABS_par_id = 's' + xxwk1_asn_nbr
            AND ABS_id BEGINS 'c'
            AND ABS_id = 'c' + xxwk1_box_nbr
            NO-ERROR.
        IF AVAILABLE ABS_mstr THEN DO:
            ASSIGN ABS_user2 = xxwk1_cnt_nbr.
        END.
    END.
    MESSAGE "上载完毕." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END PROCEDURE.
