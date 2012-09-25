
/* DISPLAY TITLE */
{mfdtitle.i "f+"}
{yyedcomlib.i}
/*
IF f-howareyou("HAHA") = NO THEN LEAVE.
*/


DEF VAR v_ok         AS LOGICAL.
DEF VAR v_confirm    AS LOGICAL.
DEF VAR v_sys_status AS CHAR.
DEF VAR v_date       AS DATE.
DEF VAR v_flag       AS CHAR.
DEF VAR v_order_label AS CHAR.

DEF VAR v_fexcel     AS CHAR FORMAT "x(55)".
DEF VAR v_fdir       AS CHAR.

DEF VARIABLE v_sheet AS INTEGER INITIAL 1.
DEF VARIABLE v_chk_price AS LOGICAL INITIAL NO.
DEF VARIABLE v_copyold AS LOGICAL INITIAL NO.

DEF NEW SHARED TEMP-TABLE xxwk1 
    FIELDS xxwk1_part  LIKE pt_part
    FIELDS xxwk1_desc  LIKE pt_desc1
    FIELDS xxwk1_shpdate AS DATE LABEL "发运日期"
    FIELDS xxwk1_duedate  AS DATE LABEL "到达日期"
    FIELDS xxwk1_fp    AS CHAR    LABEL "F/P"
    FIELDS xxwk1_qty   LIKE tr_qty_loc LABEL "数量"
    INDEX xxwk1_idx1 xxwk1_part xxwk1_duedate.

DEF NEW SHARED TEMP-TABLE xxwk2
    FIELDS xxwk2_ponbr      LIKE po_nbr
    FIELDS xxwk2_shipfr     LIKE po_vend
    FIELDS xxwk2_namefr     LIKE ad_name
    FIELDS xxwk2_shipto     LIKE pod_site
    FIELDS xxwk2_nameto     LIKE ad_name
    FIELDS xxwk2_releaseid  LIKE schd_rlse_id
    FIELDS xxwk2_beg_date   AS DATE     label "起始日期"
    FIELDS xxwk2_end_date   AS DATE     label "截止日期"
    FIELDS xxwk2_err        AS LOGICAL INITIAL NO label "错误!!!"
    .
DEF NEW SHARED TEMP-TABLE xxwk3
    FIELDS xxwk3_ponbr LIKE po_nbr
    FIELDS xxwk3_poln  LIKE pod_line
    FIELDS xxwk3_part  LIKE pt_part
    FIELDS xxwk3_desc  LIKE pt_desc1
    FIELDS xxwk3_err   AS CHAR INITIAL "" LABEL "错误" FORMAT "x(24)"
    FIELDS xxwk3_releaseid LIKE schd_rlse_id
    FIELDS xxwk3_pcs_date LIKE sch_pcs_date
    FIELDS xxwk3_newid AS LOGICAL INITIAL NO .

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

    RUN xxpro-check.

    {mfselprt.i "terminal" 80}
    FIND FIRST xxwk2.
    DISP 
        xxwk2_ponbr     
        " "
        xxwk2_shipfr    
        xxwk2_namefr    
        xxwk2_shipto    
        xxwk2_nameto    
        xxwk2_releaseid 
        xxwk2_err       
        xxwk2_beg_date  
        xxwk2_end_date  
    WITH WIDTH 132 2 COLUMNS STREAM-IO.
    FOR EACH xxwk3 BY xxwk3_part:
        FOR EACH xxwk1 WHERE xxwk1_part = xxwk3_part BY xxwk1_duedate:
            DISPLAY 
                xxwk3_part
                xxwk3_desc
                xxwk3_poln
                xxwk1_shpdate
                xxwk1_duedate
                xxwk1_qty
                xxwk1_fp
                xxwk3_err
                WITH FRAME f-b WIDTH 132 DOWN STREAM-IO.
        END.
    END.
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
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-input:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    
    SYSTEM-DIALOG GET-FILE v_fexcel 
        TITLE "请选择数据文件..."        
        FILTERS "Source Files (*.xls)"   "*.xls"
        INITIAL-DIR v_fdir
        MUST-EXIST
        USE-FILENAME
        UPDATE v_ok.
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
    def var iError as integer.
    def var iWarning as integer.

    CREATE "Excel.Application" chExcel.
    
    /*chWorkbook  =  chExcel:Workbooks:OPEN(v_filename1).*/
    chWorkbook = chExcel:Workbooks:OPEN(v_fexcel,0,true,,,,true).
    chWorkSheet =  chWorkbook:workSheets(v_sheet).
    chExcel:visible = NO.



    /* read EXCEL file and load data begin..*/
    iRow = 6.	/* from the 17th row in the excel file, read data.*/
	iError = 0.
	iWarning = 0.

    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    FOR EACH xxwk1:
        DELETE xxwk1.
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
        xxwk2_ponbr = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value).

    iRow = 3.
    ASSIGN 
        xxwk2_shipfr = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk2_namefr = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,3):value).

    iRow = 4.
    ASSIGN 
        xxwk2_shipto = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk2_nameto = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,3):value).

    iRow = 5.
    ASSIGN 
        xxwk2_releaseid = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value).

    iRow = 6.
    ASSIGN 
        xxwk2_beg_date =  (chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk2_end_date = (chWorkbook:Worksheets(v_sheet):Cells(iRow,7):value).

    iRow = 9.
    REPEAT:
        iRow = iRow + 1.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = "" then leave.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = ? then leave.
            
        CREATE xxwk1.
        ASSIGN 
            xxwk1_part     = chWorkbook:Worksheets(v_sheet):Cells(iRow,1):TEXT
            xxwk1_desc     = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,3):value)
            xxwk1_shpdate  = chWorkbook:Worksheets(v_sheet):Cells(iRow,5):VALUE
            xxwk1_duedate  = chWorkbook:Worksheets(v_sheet):Cells(iRow,6):VALUE
            xxwk1_qty      = DECIMAL(chWorkbook:Worksheets(v_sheet):Cells(iRow,8):value).
        IF chWorkbook:Worksheets(v_sheet):Cells(iRow,7):VALUE = "YES" THEN
            xxwk1_fp = "F". ELSE xxwk1_fp = "P".
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
PROCEDURE xxpro-load:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    DEF VAR v_fcimdat    AS CHAR.
    DEF VAR v_fcimlog    AS CHAR.

    FIND FIRST xxwk2.

    FOR EACH xxwk3 WHERE xxwk3_new = YES:
        RUN xxpro-create-release (INPUT xxwk3_ponbr, INPUT xxwk3_poln, INPUT xxwk3_releaseid).
    END.
    
    FOR EACH xxwk3:
        IF xxwk3_pcs_date = ? THEN xxwk3_pcs_date = TODAY.

        v_fcimdat = "DAT." + xxwk3_ponbr + "." + string(xxwk3_poln).    
        v_fcimlog = "Log." + xxwk3_ponbr + "." + string(xxwk3_poln).    
        OUTPUT STREAM s1 CLOSE.
        OUTPUT STREAM s1 TO VALUE(v_fcimdat).
        put STREAM s1 UNFORMATTED
            xxwk3_ponbr AT 1
            ' ""  ""  "" ' 
            xxwk3_poln 
            skip .
        put STREAM s1 UNFORMATTED
            "-" skip .
        put STREAM s1 UNFORMATTED
            "N" SPACE(1) "-" SPACE(1) xxwk3_pcs_date SPACE(1).
        IF xxwk2_beg_date <> ? THEN put STREAM s1 UNFORMATTED 
            xxwk2_beg_date SPACE(1).
        ELSE put STREAM s1 UNFORMATTED "-" SPACE(1).
        IF xxwk2_end_date <> ? THEN put STREAM s1 UNFORMATTED 
            xxwk2_end_date SPACE(1).
        ELSE put STREAM s1 UNFORMATTED "-" SPACE(1).
        put STREAM s1 UNFORMATTED
            SPACE(1) skip .
        FOR EACH xxwk1 WHERE xxwk1_part = xxwk3_part BY xxwk1_duedate:
            put STREAM s1 UNFORMATTED
                    xxwk1_duedate SKIP
                    xxwk1_qty SPACE(1).

            IF xxwk1_fp = "" THEN 
                put STREAM s1 UNFORMATTED "-" SPACE(1).
            ELSE
                put STREAM s1 UNFORMATTED xxwk1_fp SPACE(1).
            PUT STREAM s1 UNFORMATTED SPACE(1) SKIP.
        END.
        put STREAM s1 UNFORMATTED
            "." skip 
            "-" SKIP
            "." skip . 
        OUTPUT STREAM s1 CLOSE.
        RUN xxpro-cimload (INPUT v_fcimdat, INPUT v_fcimlog, INPUT "rssmt.p").

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
PROCEDURE xxpro-check2:
    DEF OUTPUT PARAMETER p_ok as LOGICAL.
    p_ok = YES.
    DEF VAR i AS INTEGER.
    i = 0.
    FOR EACH xxwk4:
        DELETE xxwk4.
    END.

    FIND FIRST xxwk2.
    FOR EACH xxwk3:
        FIND FIRST pod_det 
            WHERE pod_domain = global_domain and pod_nbr = xxwk3_ponbr
            AND pod_line  = xxwk3_poln
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pod_det THEN NEXT.

        FOR EACH xxwk1 WHERE xxwk1_part = xxwk3_part:

            FIND FIRST schd_det 
            where schd_domain = global_domain and  schd_type = 4
              and schd_rlse_id = /*pod_curr_rlse_id[1] */ xxwk3_releaseid
              and schd_nbr = pod_nbr 
              and schd_line = pod_line
              AND schd_date = xxwk1_duedate
              NO-LOCK NO-ERROR.
            IF (NOT AVAILABLE schd_det) OR (AVAILABLE schd_det AND schd_upd_qty <> xxwk1_qty) THEN DO:
                CREATE xxwk4.
                ASSIGN 
                    xxwk4_line = pod_line
                    xxwk4_err  = "PART:" + pod_part + "/DATE:" + STRING(xxwk1_duedate).
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

/*-----------------------*/
PROCEDURE xxpro-chk-price:
    DEF INPUT PARAMETER p_recid AS RECID.
    DEF INPUT PARAMETER p_date  AS DATE.
    DEF OUTPUT PARAMETER p_msg   AS CHAR.

    p_msg   = "".

    FIND FIRST pod_det WHERE RECID(pod_det) = p_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pod_det THEN LEAVE.

    IF pod_pr_list = "" THEN DO:
        p_msg = "价格单未定义".
    END.
    ELSE DO:
        FIND FIRST po_mstr WHERE po_domain = global_domain and 
        				   po_nbr = pod_nbr NO-LOCK NO-ERROR.
        IF NOT AVAILABLE po_mstr THEN LEAVE.
        FIND FIRST pc_mstr WHERE pc_domain = global_domain
        		AND pc_list = pod_pr_list 
            AND pc_part = pod_part AND pc_curr = po_curr AND pc_um = pod_um
            AND ((pc_start <= p_date OR pc_start = ?) AND (pc_expire >= p_date OR pc_expire = ?))
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pc_mstr THEN DO:
            p_msg = "价格单无该日期定义".
        END.
    END.
END PROCEDURE.


/*--------------------------*/
PROCEDURE xxpro-create-release:
    DEF INPUT PARAMETER p_ponbr AS CHAR.
    DEF INPUT PARAMETER p_poln  AS INTEGER.
    DEF INPUT PARAMETER p_rls_id AS CHAR.

    DEF VAR v_new AS LOGICAL.
    
    FIND FIRST pod_det WHERE pod_domain = global_domain and 
               pod_nbr = p_ponbr AND pod_line = p_poln AND pod_sched = YES NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pod_det THEN LEAVE.

    IF p_rls_id = pod_curr_rlse_id[1]  THEN LEAVE.
    
    FIND first scx_ref where scx_domain = global_domain and 
    					 scx_type  = 2 and scx_order = pod_nbr and scx_line  = pod_line NO-LOCK NO-ERROR.
    IF NOT AVAILABLE scx_ref THEN LEAVE.

    FIND first sch_mstr WHERE sch_domain = global_domain and  sch_type = 4
         and sch_nbr = scx_order
         and sch_line = scx_line
         and sch_rlse_id = p_rls_id
        NO-LOCK NO-ERROR.
    IF AVAILABLE sch_mstr THEN LEAVE.

    create sch_mstr.
    assign
        sch_type = 4
        sch_nbr = scx_order
        sch_line = scx_line
        sch_rlse_id = p_rls_id.

    IF v_copyold = YES THEN DO:
        DEF BUFFER PREV_sch_mstr FOR sch_mstr.
        for first prev_sch_mstr where sch_domain = global_domain 
                   and sch_type = 4
                   and sch_nbr = sch_mstr.sch_nbr
                   and sch_line = sch_mstr.sch_line
                   and sch_rlse_id = pod_curr_rlse_id[1]
        no-lock:
        end.
        IF AVAILABLE PREV_sch_mstr THEN DO:
            {gprun.i ""rcsinit.p""
                    "(input recid(prev_sch_mstr),
                      input recid(sch_mstr),
                      input yes)"}
        END.
    END.

    FIND FIRST pod_det WHERE pod_domain = global_domain and 
    				   pod_nbr = p_ponbr AND pod_line = p_poln AND pod_sched = YES NO-ERROR.
    IF AVAILABLE pod_det THEN DO:
        pod_curr_rlse_id[1] = p_rls_id.
        RELEASE pod_det.
    END.
END PROCEDURE.

/*******************************************/
/*post done*/
PROCEDURE xxpro-check:
    DEFINE VARIABLE v_chk_out AS CHAR.

    FIND FIRST xxwk2.
    FOR EACH xxwk1 BREAK BY xxwk1_part:
        IF FIRST-OF(xxwk1_part) THEN DO:
            CREATE xxwk3.
            ASSIGN 
                xxwk3_part = xxwk1_part
                xxwk3_desc = xxwk1_desc
                xxwk3_releaseid = xxwk2_releaseid
                xxwk3_ponbr = xxwk2_ponbr.
        END.
    END.
    FOR EACH xxwk3:
        FIND FIRST pod_det WHERE pod_domain = global_domain and 
        					 pod_nbr = xxwk3_ponbr AND pod_part = xxwk3_part
            AND pod_sched = YES 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pod_det THEN DO:
            xxwk3_err = xxwk3_err + "采购单未找到.".
            xxwk2_err = YES.
            NEXT.
        END.
        ASSIGN xxwk3_poln = pod_line.
        find first scx_ref no-lock where scx_domain = global_domain and
        				   scx_type = 2 AND scx_po = xxwk3_ponbr and scx_line = xxwk3_poln no-error.
        IF NOT AVAILABLE scx_ref THEN DO:
            xxwk3_err = xxwk3_err + "日程不存在.".
            xxwk2_err = YES.
            NEXT.
        END.
        IF CAN-FIND(FIRST xxwk1 WHERE xxwk1_part = xxwk3_part AND xxwk1_qty < 0) THEN DO:
            xxwk3_err = xxwk3_err + "数量<0.".
            xxwk2_err = YES.
            NEXT.
        END.
        IF CAN-FIND(FIRST xxwk1 WHERE xxwk1_part = xxwk3_part AND xxwk1_fp = "F") 
            AND pod_firm_days = 0 THEN DO:
            xxwk3_err = xxwk3_err + "Firm days is 0.".
            xxwk2_err = YES.
            NEXT.
        END.

        IF can-find(FIRST xxwk1 WHERE xxwk1_duedate - pod_translt_days <> xxwk1_shpdate) THEN DO:
            xxwk3_err = xxwk3_err + "发运提前期不一致".
            xxwk2_err = YES.
            NEXT.
        END.
        
        IF xxwk3_releaseid = "" THEN DO:
            find first sch_mstr where sch_domain = global_domain and sch_type = 4
                and sch_nbr = xxwk3_ponbr
                and sch_line = xxwk3_poln
                and sch_rlse_id = pod_curr_rlse_id[1] 
                no-lock no-error.
            if not available sch_mstr then do:
                xxwk3_err = xxwk3_err + "不存在有效日程单.".
                xxwk2_err = YES.
                NEXT.
            end.
        END.
        ELSE DO:
            find first sch_mstr where sch_domain = global_domain and sch_type = 4
                and sch_nbr = xxwk3_ponbr
                and sch_line = xxwk3_poln
                and sch_rlse_id = xxwk3_releaseid
                NO-LOCK NO-ERROR.
            IF AVAILABLE sch_mstr AND xxwk3_releaseid <> pod_curr_rlse_id[1] THEN DO:
                xxwk3_err = xxwk3_err + "日程单存在,请先激活.".
                xxwk3_pcs_date = sch_pcs_date.
                xxwk2_err = YES.
                NEXT.
            END.
            ELSE DO:
                xxwk3_newid = YES.
                IF AVAILABLE sch_mstr THEN xxwk3_pcs_date = sch_pcs_date.
            END.
        END.

        IF AVAILABLE pod_det AND v_chk_price = YES THEN do:
            FOR EACH xxwk1 WHERE xxwk1_part = xxwk3_part AND xxwk1_fp = "F":
                RUN xxpro-chk-price (INPUT RECID(pod_det), INPUT xxwk1_duedate, OUTPUT v_chk_out).
                IF v_chk_out <> "" THEN do:
                    xxwk3_err = xxwk3_err + v_chk_out.
                    xxwk2_err = YES.
                    LEAVE.
                END.
            END.
            IF xxwk2_err = YES THEN NEXT.
        END.
        IF xxwk3_pcs_date = ? THEN xxwk3_pcs_date = TODAY.
    END.
END PROCEDURE.
