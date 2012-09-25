/* DISPLAY TITLE */
{mfdtitle.i "f+"}

{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.


DEF VAR v_ok         AS LOGICAL.
DEF VAR v_confirm    AS LOGICAL.
DEF VAR v_sys_status AS CHAR.
DEF VAR v_date       AS DATE.
DEF VAR v_nbr        AS CHAR.
DEF VAR v_ship_fr    AS CHAR.
DEF VAR v_ship_to    AS CHAR.
DEF VAR v_flag       AS CHAR.

DEF VAR v_fexcel     AS CHAR FORMAT "x(55)".
DEF VAR v_fdir       AS CHAR.


DEF VARIABLE v_sheet AS INTEGER INITIAL 1.
DEF VARIABLE v_chk_price AS LOGICAL INITIAL NO.
DEF VARIABLE v_copyold AS LOGICAL INITIAL NO.

DEF TEMP-TABLE xxwk2
    FIELDS xxwk2_order     LIKE so_nbr       LABEL "销售单"
    FIELDS xxwk2_ponbr     LIKE so_po        LABEL "合同号"
    FIELDS xxwk2_soldto    LIKE so_cust      LABEL "客户"
    FIELDS xxwk2_name_sold LIKE ad_name      LABEL "名称"
    FIELDS xxwk2_shipto    LIKE po_site      LABEL "收货地点"
    FIELDS xxwk2_name_to   LIKE ad_name      LABEL "名称"
    FIELDS xxwk2_shipfr    LIKE so_site      LABEL "发货地点"
    FIELDS xxwk2_name_fr   LIKE ad_name      LABEL "名称"
    FIELDS xxwk2_releaseid LIKE schd_rlse_id LABEL "日程版本"
    FIELDS xxwk2_fob       LIKE po_fob
    FIELDS xxwk2_beg_dt    AS   DATE         LABEL "起始日期"
    FIELDS xxwk2_end_dt    AS   DATE         LABEL "结束日期"
    FIELDS xxwk2_curr      LIKE glt_curr     LABEL "币种"
    FIELDS xxwk2_amt       LIKE glt_amt      LABEL "金额"
    FIELDS xxwk2_err       AS LOGICAL LABEL "错误标志"
    INDEX xxwk2_idx1 xxwk2_order
    .

DEF TEMP-TABLE xxwk3
    FIELDS xxwk3_order      LIKE so_nbr
    FIELDS xxwk3_line       LIKE pod_line
    FIELDS xxwk3_duedate    AS DATE            LABEL "发运日期"
    FIELDS xxwk3_fp         AS CHAR            LABEL "1/2/F"   
    FIELDS xxwk3_qty        LIKE tr_qty_loc    LABEL "数量"
    FIELDS xxwk3_price      LIKE pt_price      LABEL "价格"
    FIELDS xxwk3_amt        LIKE glt_amt       LABEL "金额"
    INDEX  xxwk3_idx1 xxwk3_order xxwk3_line xxwk3_duedate.
    .

DEF TEMP-TABLE xxwk1 rcode-information
    FIELDS xxwk1_part       LIKE pt_part       LABEL "零件号"  
    FIELDS xxwk1_part_ref   LIKE pt_part       LABEL "参考零件号"  
    FIELDS xxwk1_desc       LIKE pt_desc1      LABEL "零件名称"
    FIELDS xxwk1_org        AS CHAR            LABEL "产地"
    FIELDS xxwk1_model      AS CHAR            label "机型"
    FIELDS xxwk1_mot        AS CHAR            LABEL "运输方式"
    FIELDS xxwk1_fobpt      AS CHAR            LABEL "FOB地点"
    FIELDS xxwk1_beg_cumdat AS DATE            LABEL "累计起始日期"
    FIELDS xxwk1_end_cumdat AS DATE            LABEL "累计结束日期"
    FIELDS xxwk1_ord_cumqty LIKE pod_qty_ord   LABEL "累计订货量"
    FIELDS xxwk1_iss_cumqty LIKE pod_qty_ord   LABEL "累计发货量"
    FIELDS xxwk1_price      LIKE pt_price      LABEL "价格"
    FIELDS xxwk1_curr       AS CHAR            LABEL "币种"
    FIELDS xxwk1_order      AS CHAR            LABEL "采购单"
    FIELDS xxwk1_line       AS INTEGER         LABEL "行"             
    FIELDS xxwk1_rlse_id    LIKE schd_rlse_id  LABEL "发布号"
    FIELDS xxwk1_ponbr      LIKE so_po        LABEL "合同号"
    FIELDS xxwk1_msg        AS CHAR INITIAL "" LABEL "检查提示"  FORMAT "x(20)"
    INDEX xxwk1_idx1 xxwk1_order xxwk1_line
    INDEX xxwk1_idx2 xxwk1_order xxwk1_part
    .

DEF TEMP-TABLE xxwk4
    FIELDS xxwk4_line AS INTEGER LABEL "行号" FORMAT ">>>>"
    FIELDS xxwk4_err  AS CHAR    LABEL "错误" FORMAT "x(60)"
    .

DEF STREAM s1.

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
    v_copyold   COLON 10 LABEL "复制" "(新版本建立时复制老版本信息)"
    v_chk_price COLON 10 LABEL "检查价格"
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

RUN xxpro-initial (OUTPUT v_sys_status).
REPEAT:
    UPDATE
        v_fexcel WITH FRAME a.
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
            v_copyold
            v_chk_price
            WITH FRAME a.
    END.
    ELSE DO:
        UNDO, RETRY.
    END.
    
    IF v_fexcel = "" THEN UNDO, RETRY.

    RUN xxpro-excel (OUTPUT v_sys_status).
    FIND FIRST xxwk1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN DO:
        MESSAGE "无数据存在，不能上载." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        LEAVE.
    END.

    /*review*/ 
    {mfselprt.i "terminal" 80}
    RUN xxpro-check.
    FIND FIRST xxwk2.
    FIND FIRST xxwk4 NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk4 THEN DO:
        xxwk2_err = YES.
    END.
    ELSE DO:
        xxwk2_err = NO.
    END.
    RUN xxpro-report.
    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
    
    FIND FIRST xxwk2.
    IF xxwk2_err = YES THEN DO:
        MESSAGE "数据存在错误，不能上载." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    ELSE DO:
        v_confirm = NO.
        MESSAGE "确认要上载所显示的数据" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_confirm.
        IF v_confirm = YES THEN DO:
            RUN xxpro-load  (OUTPUT v_sys_status).
        END.
    END.
END.

/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    v_ok = NO.
    v_fexcel = "".
    v_fdir = "".
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-excel:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.
    
    DEF VAR iRow   AS INTEGER.
    def var i      as integer.
    def var iWarning as integer.

    DEF VAR v_data AS CHAR EXTENT 20.

    CREATE "Excel.Application" chExcel.
    
    /*chWorkbook  =  chExcel:Workbooks:OPEN(v_filename1).*/
    chWorkbook = chExcel:Workbooks:OPEN(v_fexcel,0,true,,,,true).
    chWorkSheet =  chWorkbook:workSheets(v_sheet).
    chExcel:visible = NO.



    /* read EXCEL file and load data begin..*/
    iRow = 5.	/* from the 17th row in the excel file, read data.*/

    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    FOR EACH xxwk3:
        DELETE xxwk3.
    END.
    FOR EACH xxwk4:
        DELETE xxwk4.
    END.

    iRow = 2.
    CREATE xxwk2.
    ASSIGN 
        xxwk2_order = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value).

    iRow = 3.
    ASSIGN 
        xxwk2_shipfr = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk2_name_fr = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,3):value).

    iRow = 4.
    ASSIGN 
        xxwk2_soldto = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk2_name_sold = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,3):value).
    
    iRow = 5.
    ASSIGN 
        xxwk2_shipto = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk2_name_to = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,3):value).

    iRow = 6.
    ASSIGN 
        xxwk2_releaseid =  STRING((chWorkbook:Worksheets(v_sheet):Cells(iRow,2):TEXT)).

    iRow = 7.
    ASSIGN 
        xxwk2_beg_dt =  (chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk2_end_dt = (chWorkbook:Worksheets(v_sheet):Cells(iRow,7):value).

    iRow = 9.
    REPEAT:
        iRow = iRow + 1.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = "" then leave.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = ? then leave.
                    
        DO i = 1 TO 20:
            v_data[i] = chWorkbook:Worksheets(v_sheet):Cells(iRow,i):value.
        END.
        FIND FIRST xxwk1 
            WHERE xxwk1_order = xxwk2_order AND xxwk1_line = INTEGER(v_data[9])
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE xxwk1 THEN DO:
            CREATE xxwk1.
            ASSIGN
                xxwk1_order = xxwk2_order
                xxwk1_line  = INTEGER(v_data[9])
                xxwk1_part  = v_data[1]
                xxwk1_desc  = v_data[3]
                xxwk1_part_ref = v_data[10]
                xxwk1_rlse_id  = xxwk2_releaseid
                .
        END.

        CREATE xxwk3.
        ASSIGN 
            xxwk3_order    = xxwk2_order
            xxwk3_line     = xxwk1_line
            xxwk3_duedate  = chWorkbook:Worksheets(v_sheet):Cells(iRow,8):VALUE
            xxwk3_qty      = DECIMAL(chWorkbook:Worksheets(v_sheet):Cells(iRow,6):value).
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
PROCEDURE xxpro-report:
    FOR EACH xxwk2 NO-LOCK:
        DISP 
                xxwk2_order    
                xxwk2_ponbr    
                xxwk2_soldto   
                xxwk2_name_sold
                xxwk2_shipto   
                xxwk2_name_to  
                xxwk2_shipfr   
                xxwk2_name_fr  
                xxwk2_beg_dt   
                xxwk2_end_dt   
                xxwk2_curr     
                xxwk2_amt      
                xxwk2_fob     
                xxwk2_err
        WITH FRAME f-a 2 COLUMNS width 132 STREAM-IO.

        FOR EACH xxwk1 NO-LOCK WHERE xxwk1_order = xxwk2_order:
            DISP 
                xxwk1_part       
                xxwk1_part_ref   
                xxwk1_desc       
                xxwk1_model      
                xxwk1_beg_cumdat 
                xxwk1_end_cumdat 
                xxwk1_ord_cumqty 
                xxwk1_iss_cumqty 
                xxwk1_order      
                xxwk1_line       
                xxwk1_rlse_id    
                xxwk1_ponbr      
            WITH WITH FRAME f-b WIDTH 250 DOWN STREAM-IO.
            FOR EACH xxwk3 NO-LOCK WHERE xxwk3_order = xxwk1_order AND xxwk3_line = xxwk1_line:
                DISP 
                space(12)
                xxwk3_duedate  
                xxwk3_qty      
                xxwk3_price    
                xxwk3_amt      
                WITH FRAME f-c DOWN width 120 STREAM-IO.
            END.
        END.
    END.

END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-load:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    DEF VAR v_fcimdat    AS CHAR.
    DEF VAR v_fcimlog    AS CHAR.

    FIND FIRST xxwk2.
    FOR EACH xxwk1 BREAK BY xxwk1_order BY xxwk1_line:
            v_fcimdat = "SODat." + xxwk1_order + "." + string(xxwk1_line).    
            v_fcimlog = "SOLog." + xxwk1_order + "." + string(xxwk1_line).    
            OUTPUT STREAM s1 CLOSE.
            OUTPUT STREAM s1 TO VALUE(v_fcimdat).
            put STREAM s1 UNFORMATTED
                ' "" "" "" "" "" "" ' AT 1
                xxwk1_order  SPACE(1)
                xxwk1_line   SPACE(1)
                skip 
                "-" skip 
                "no -" skip .

        FOR EACH xxwk3 WHERE xxwk3_order = xxwk1_order 
            AND xxwk3_line = xxwk1_line 
            BY  xxwk3_duedate: 
            put STREAM s1 UNFORMATTED
                    xxwk3_duedate SKIP
                    xxwk3_qty SKIP.
        END.
        put STREAM s1 UNFORMATTED
                "." skip . 
        OUTPUT STREAM s1 CLOSE.
        RUN xxpro-cimload (INPUT v_fcimdat, INPUT v_fcimlog, INPUT "rcrsmt.p").
    END.

    RUN xxpro-check2 (OUTPUT v_ok).
    IF v_ok = YES THEN DO:
        MESSAGE "上载完毕." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    p_sys_status = "0".
END PROCEDURE.
/*-----------------------*/
PROCEDURE xxpro-cimload:
    DEF INPUT PARAMETER p_cimdat AS CHAR.
    DEF INPUT PARAMETER p_cimlog AS CHAR.
    DEF INPUT PARAMETER p_cimprg AS CHAR.

        batchrun = yes .
        OUTPUT CLOSE.
        output to value(p_cimlog) APPEND.
        input from value(p_cimdat) .
        {gprun.i "p_cimprg"}
        input close .
        output close . 
END PROCEDURE.

/*-----------------------*/
PROCEDURE xxpro-check:

    DEF VAR i AS INTEGER.
    i = 0.
    FIND FIRST xxwk2 NO-ERROR.
    IF NOT AVAILABLE xxwk2 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN 
            xxwk4_line  = i
            xxwk4_err = "无销售单". 
        NEXT.
    END.

    FOR EACH xxwk1:
        IF xxwk1_rlse_id = "" THEN DO:
            FIND FIRST sod_det 
                WHERE sod_nbr = xxwk1_order
                AND   sod_line = xxwk1_line
                NO-LOCK
                NO-ERROR.
            IF AVAILABLE sod_det THEN DO:
                ASSIGN 
                    xxwk1_rlse_id = sod_curr_rlse_id[3].

                FIND FIRST scx_ref WHERE scx_type = 1
                    AND scx_order = xxwk1_order
                    AND scx_line  = xxwk1_line
                    NO-LOCK NO-ERROR.
                IF AVAILABLE scx_ref THEN DO:
                    ASSIGN xxwk1_ponbr = scx_po.
                END.
            END.
        END.
    END.

    FOR EACH xxwk1:
        find first scx_ref no-lock where scx_type = 1 AND scx_order = xxwk1_order and scx_line = xxwk1_line no-error.
        IF NOT AVAILABLE scx_ref THEN DO:
            i = i + 1.
            CREATE xxwk4.
            ASSIGN 
                xxwk4_line  = i
                xxwk4_err = "SO:" + xxwk1_order + "Line:" + string(xxwk1_line) + "日程不存在.". 
            NEXT.
        END.
        FIND FIRST sod_det WHERE sod_nbr = xxwk1_order
            AND sod_line = xxwk1_line
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE sod_det THEN DO:
            i = i + 1.
            CREATE xxwk4.
            ASSIGN 
                xxwk4_line  = i
                xxwk4_err = "SO:" + xxwk1_order + "Line:" + string(xxwk1_line) + "销售单未找到.". 
            NEXT.
        END.
        ELSE IF sod_part <>  xxwk1_part THEN DO:
            i = i + 1.
            CREATE xxwk4.
            ASSIGN 
                xxwk4_line  = i
                xxwk4_err = "SO:" + xxwk1_order + "Line:" + string(xxwk1_line) + "销售单零件不匹配.". 
            NEXT.
        END.
        find first sch_mstr where sch_type = 3
            and sch_nbr = xxwk1_order
			and sch_line = xxwk1_line
            and sch_rlse_id = xxwk1_rlse_id
            no-lock no-error.
		if not available sch_mstr then do:
            i = i + 1.
            CREATE xxwk4.
            ASSIGN 
                xxwk4_line  = i
                xxwk4_err = "SO:" + xxwk1_order + "Line:" + string(xxwk1_line) + "不存在有效日程单.". 
            NEXT.
		end.

        FOR EACH xxwk3 WHERE xxwk3_order = xxwk1_order
            AND xxwk3_line = xxwk1_line:
            IF xxwk3_qty < 0 THEN DO:
                i = i + 1.
                CREATE xxwk4.
                ASSIGN 
                    xxwk4_line  = i
                    xxwk4_err = "SO:" + xxwk1_order + "Line:" + string(xxwk1_line) + "数量<0.". 
                NEXT.
            END.
            IF xxwk3_duedate = ? THEN DO:
                i = i + 1.
                CREATE xxwk4.
                ASSIGN 
                    xxwk4_line  = i
                    xxwk4_err = "SO:" + xxwk1_order + "Line:" + string(xxwk1_line) + "日期错误.". 
                NEXT.
            END.
        END.
    END.
END PROCEDURE.
/*-----------------------*/
PROCEDURE xxpro-check2:
    DEF OUTPUT PARAMETER p_ok as LOGICAL.
    p_ok = YES.

    DEF VAR i AS INTEGER.
    i = 0.
    FOR EACH xxwk4:
        DELETE xxwk4.
    END.

    FIND FIRST xxwk2.
    FOR EACH xxwk1:
        FIND FIRST sod_det 
            WHERE sod_nbr = xxwk1_order
            AND   sod_line = xxwk1_line
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE sod_det THEN NEXT.
        FOR EACH xxwk3 WHERE xxwk3_order = xxwk1_order
            AND xxwk3_line = xxwk1_line:
            FIND FIRST schd_det 
            where schd_type = 3
              and schd_rlse_id = xxwk1_rlse_id
              and schd_nbr = sod_nbr 
              and schd_line = sod_line
              AND schd_date = xxwk3_duedate
              NO-LOCK NO-ERROR.
            IF (NOT AVAILABLE schd_det) OR (AVAILABLE schd_det AND schd_upd_qty <> xxwk3_qty) THEN DO:
                CREATE xxwk4.
                ASSIGN 
                    xxwk4_line = sod_line
                    xxwk4_err  = "PART:" + sod_part + "/DATE:" + STRING(xxwk3_duedate).
            END.
        END.
    END.
    FIND FIRST xxwk4 NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk4 THEN DO:
        p_ok = NO.
        MESSAGE "数据上载错误,请检查." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        FOR EACH xxwk4 WITH FRAME f-d WIDTH 80 STREAM-IO:
            DISP xxwk4.
        END.
        PAUSE.
        HIDE FRAME f-d NO-PAUSE.
    END.
END PROCEDURE.

