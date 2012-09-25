
/* SCHEDULE DATA REPORT */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

{rcrpvar.i}
define variable schtype       like sch_type initial 1 no-undo.
define variable date_from     as date label "Created" no-undo.
define variable date_to       as date label {t001.i} no-undo.
define variable sortoption    as integer no-undo
                              label "Sort Option" format "9" initial 1.
define variable sortextoption as character extent 2 format "x(66)" no-undo.
define variable current_ind   like mfc_logical label "Active/Hist"
                              format "Active/Hist" initial yes no-undo.


DEFINE TEMP-TABLE ttt2
    FIELDS ttt2_customer_code LIKE so_cust
    FIELDS ttt2_customer_name LIKE ad_name
    FIELDS ttt2_shipto_code   LIKE so_ship
    FIELDS ttt2_shipto_name   LIKE ad_name
    FIELDS ttt2_shipfr_code   LIKE so_site
    FIELDS ttt2_releaseid     LIKE sch_rlse_id
    FIELDS ttt2_create_date   LIKE so_ord_date
    FIELDS ttt2_po_number     LIKE so_po
    FIELDS ttt2_so_number     LIKE so_nbr
    FIELDS ttt2_so_line       LIKE sod_line
    FIELDS ttt2_part_code     LIKE pt_part
    FIELDS ttt2_part_desc     LIKE pt_desc1
    FIELDS ttt2_eff_start     LIKE sch_eff_start
    FIELDS ttt2_eff_end       LIKE sch_eff_end
    FIELDS ttt2_pre_date      LIKE tr_date   LABEL "上次累计日期"
    FIELDS ttt2_pre_qty       LIKE ld_qty_oh LABEL "上次累计需求"
    FIELDS ttt2_asn_date      AS DATE LABEL "上次ASN日期"
    FIELDS ttt2_asn_qty       LIKE ld_qty_oh LABEL "上次ASN数量"
    INDEX ttt2_idx1 ttt2_customer_code ttt2_releaseid ttt2_so_number ttt2_so_line.
    .
DEFINE TEMP-TABLE ttt3
    FIELDS ttt3_customer_code LIKE so_cust
    FIELDS ttt3_releaseid     LIKE sch_rlse_id
    FIELDS ttt3_so_number     LIKE so_nbr
    FIELDS ttt3_so_line       LIKE sod_line
    FIELDS ttt3_date          LIKE schd_date
    FIELDS ttt3_qty           LIKE schd_upd_qty
    FIELDS ttt3_col           AS INTEGER INITIAL 1
    INDEX ttt3_idx1 ttt3_customer_code ttt3_releaseid ttt3_so_number ttt3_so_line ttt3_date.

DEFINE VARIABLE v_releaseid   LIKE sch_rlse_id.
define variable v_datelist as char no-undo.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE v-excelfile AS CHAR INITIAL "".
DEFINE VARIABLE v-okflag    AS LOGICAL NO-UNDO.

DEFINE FRAME WaitingFrame 
            "处理中，请稍候..." 
            SKIP
WITH VIEW-AS DIALOG-BOX.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   cust_from            colon 15
   v_releaseid          COLON 15
   shipfrom_from        colon 15 label "Ship-From"
   shipfrom_to          colon 45 label {t001.i}
   shipto_from          colon 15
   shipto_to            colon 45 label {t001.i}
   part_from            colon 15
   part_to              colon 45 label {t001.i}
   po_from              colon 15 format "x(22)"
   po_to                colon 45 label {t001.i} format "x(22)"
   order_from           colon 15
   order_to             colon 45 label {t001.i}
   date_from            colon 15
   date_to              colon 45 label {t001.i}
   skip(1)
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


REPEAT:
    if shipfrom_to = hi_char then shipfrom_to = "".
    if cust_to     = hi_char then cust_to     = "".
    if shipto_to   = hi_char then shipto_to   = "".
    if dock_to     = hi_char then dock_to     = "".
    if part_to     = hi_char then part_to     = "".
    if po_to       = hi_char then po_to       = "".
    if order_to    = hi_char then order_to    = "".
    IF DATE_from   = low_date THEN DATE_from = ?.
    IF DATE_to     = hi_date THEN DATE_to = ?.

    UPDATE
        cust_from
        v_releaseid
        shipfrom_from        
        shipfrom_to          
        shipto_from          
        shipto_to          
        part_from         
        part_to            
        po_from            
        po_to             
        order_from        
        order_to           
        date_from         
        date_to             
        WITH FRAME a.

    if shipfrom_to = "" then shipfrom_to = hi_char.
    if shipto_to   = "" then shipto_to   = hi_char.
    if part_to     = "" then part_to     = hi_char.
    if po_to       = "" then po_to       = hi_char.
    if order_to    = "" then order_to    = hi_char.
    IF DATE_from   = ?  THEN DATE_from   = low_date.
    IF DATE_to     = ?  THEN DATE_to     = hi_date.
    cust_to = cust_from.

    RUN xxpro-init.
    RUN xxpro-bud-ttt.
    RUN xxpro-report.
    
END.

/**************/
PROCEDURE xxpro-init:
    FOR EACH ttt2:
        DELETE ttt2.
    END.
    FOR EACH ttt3:
        DELETE ttt3.
    END.
END PROCEDURE.
/**************/
PROCEDURE xxpro-bud-ttt:
    for each scx_ref no-lock
       where scx_type = 1
         and scx_shipfrom >= shipfrom_from and scx_shipfrom <= shipfrom_to
         and scx_shipto >= shipto_from and scx_shipto <= shipto_to
         and scx_part >= part_from and scx_part <= part_to
         and scx_po >= po_from and scx_po <= po_to
         and scx_order >= order_from and scx_order <= order_to,
    each sod_det no-lock
       where sod_nbr = scx_order and sod_line = scx_line,
    each so_mstr no-lock
       where so_nbr = sod_nbr
         and so_cust >= cust_from and so_cust <= cust_to
        :

    IF v_releaseid = "" THEN DO:
        find sch_mstr 
            WHERE sch_type = schtype
            and sch_nbr = sod_nbr and sch_line = sod_line
            and (sch_cr_date >= date_from or date_from = ?)
            and (sch_cr_date <= date_to or date_to = ?)
            and sch_rlse_id = sod_curr_rlse_id[schtype]
        no-lock no-error.
    END.
    ELSE DO:
        find sch_mstr 
            WHERE sch_type = schtype
            and sch_nbr = sod_nbr and sch_line = sod_line
            and (sch_cr_date >= date_from or date_from = ?)
            and (sch_cr_date <= date_to or date_to = ?)
            and sch_rlse_id = v_releaseid
            NO-LOCK NO-ERROR.
    END.
    IF NOT AVAILABLE sch_mstr THEN NEXT.

    FOR EACH schd_det NO-LOCK
        WHERE schd_type = sch_type
        AND   schd_nbr  = sch_nbr
        AND   schd_line = sch_line
        AND   schd_rlse_id = sch_rlse_id:

        FIND FIRST ttt2 
            WHERE ttt2_customer_code = so_cust
            and   ttt2_releaseid     = sch_rlse_id
            and   ttt2_so_number     = sch_nbr
            and   ttt2_so_line       = sch_line
            no-lock no-error.
        if not available ttt2 then do:
            create ttt2.
            assign
                ttt2_customer_code = so_cust      
                ttt2_releaseid     = sch_rlse_id  
                ttt2_so_number     = sch_nbr      
                ttt2_so_line       = sch_line     
                ttt2_shipto_code   = scx_shipto
                ttt2_shipfr_code   = scx_shipfrom
                ttt2_part_code     = sod_part
                ttt2_po_number     = scx_po
                ttt2_create_date   = sch_cr_date
                ttt2_eff_start     = sch_eff_start
                ttt2_eff_end       = sch_eff_end
                ttt2_pre_date      = sch_pcs_date
                ttt2_pre_qty       = sch_pcr_qty
                .
            
            do i = 1 to 9:
                if sch_lr_asn[i] <> ""
                or sch_lr_date[i] <> ?
                or sch_lr_time[i] <> ""
                or sch_lr_qty[i] <> 0
                or sch_lr_cum_qty[i] <> 0 
                THEN ASSIGN
                    ttt2_asn_date = sch_lr_date[i]
                    ttt2_asn_qty  = sch_lr_qty[i].

            END.
        end.
        create ttt3.
        assign 
            ttt3_customer_code     = ttt2_customer_code
            ttt3_releaseid         = ttt2_releaseid
            ttt3_so_number         = schd_nbr
            ttt3_so_line           = schd_line
            ttt3_date              = schd_date
            ttt3_qty               = schd_upd_qty
            .
    END.
    end.
    
END PROCEDURE.
/**************/
PROCEDURE xxpro-report:
    /*post process*/
    for each ttt2:
        find first ad_mstr where ad_addr = ttt2_customer_code no-lock no-error.
        if AVAILABLE ad_mstr then assign ttt2_customer_name = ad_name.
        find first ad_mstr where ad_addr = ttt2_shipto_code no-lock no-error.
        if AVAILABLE ad_mstr then assign ttt2_shipto_name = ad_name.
        find first pt_mstr where pt_part = ttt2_part_code no-lock no-error.
        if AVAILABLE pt_mstr then assign ttt2_part_desc = pt_desc2.
    end.
    v_datelist = "".
    for each ttt3 break by ttt3_date:
        if first-of(ttt3_date) then do:
            if lookup(STRING(ttt3_date), v_datelist) = 0 THEN DO:
                v_datelist = v_datelist + (IF v_datelist = "" THEN "" ELSE ",") + STRING(ttt3_date).
            END.
        end.
    end.
    FOR EACH ttt3:
        ttt3_col = 18 + lookup(STRING(ttt3_date), v_datelist).
    END.
    FIND FIRST ttt2 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttt2 THEN DO:
        MESSAGE "没有符合条件的数据" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        LEAVE.
    END.

    RUN xxpro-get-filename (OUTPUT v-okflag).
    IF v-okflag = NO THEN LEAVE.
    VIEW FRAME waitingframe.
    RUN xxpro-bud-excel.
    HIDE FRAME waitingframe NO-PAUSE.
    MESSAGE "输出完毕.要预览吗" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
    IF choice THEN RUN xxpro-view-excel.
END PROCEDURE.
/*******************/
PROCEDURE xxpro-get-filename:
    DEFINE OUTPUT PARAMETER v-ok AS LOGICAL NO-UNDO.
    v-ok = NO.
    v-excelfile = "".
    SYSTEM-DIALOG GET-FILE v-excelfile
        TITLE "请输入要保存文件的名称..."        
        FILTERS "Source Files (*.xls)"   "*.xls"       
        /*MUST-EXIST*/
        SAVE-AS
            USE-FILENAME
            UPDATE v-ok.
    IF v-ok = TRUE THEN DO:
    END.
    ELSE DO:
        MESSAGE "未指定文件名称,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END PROCEDURE.
/*******************/
PROCEDURE xxpro-bud-excel:

    IF v-excelfile = "" THEN LEAVE.

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.
    
    DEF VAR i         AS INTEGER.
    DEF VAR iRowNum   AS INTEGER.
    DEFINE VARIABLE ColumnRange   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE v_totalcol    AS INTEGER    NO-UNDO.

    v_totalcol = NUM-ENTRIES(v_datelist).
    IF v_totalcol = 0 THEN LEAVE.

    CREATE "Excel.Application" chExcel.
    
    /*chWorkbook  =  chExcel:Workbooks:OPEN(v_filename1).*/

    chWorkbook =  chExcel:Workbooks:ADD().
    chWorkSheet = chWorkbook:workSheets(1).
    chExcel:visible = NO.
    /*header*/
    chWorkSheet:COLUMNS(1):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(2):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(3):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(4):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(5):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(6):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(7):NumberFormatLocal = "m/d/y".
    chWorkSheet:COLUMNS(8):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(9):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(10):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(11):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(12):NumberFormatLocal = "@".
    chWorkSheet:COLUMNS(13):NumberFormatLocal = "m/d/y".
    chWorkSheet:COLUMNS(14):NumberFormatLocal = "m/d/y".
    chWorkSheet:COLUMNS(15):NumberFormatLocal = "m/d/y".
    chWorkSheet:COLUMNS(16):NumberFormatLocal = "0".
    chWorkSheet:COLUMNS(17):NumberFormatLocal = "m/d/y".
    chWorkSheet:COLUMNS(18):NumberFormatLocal = "0".

    chExcel:Worksheets("Sheet1"):Cells(1,1) = "客户代码".
    chExcel:Worksheets("Sheet1"):Cells(1,2) = "名称".
    chExcel:Worksheets("Sheet1"):Cells(1,3) = "货物发往".
    chExcel:Worksheets("Sheet1"):Cells(1,4) = "名称".
    chExcel:Worksheets("Sheet1"):Cells(1,5) = "发货地点".
    chExcel:Worksheets("Sheet1"):Cells(1,6) = "单据号".
    chExcel:Worksheets("Sheet1"):Cells(1,7) = "单据日期".
    chExcel:Worksheets("Sheet1"):Cells(1,8) = "采购单".
    chExcel:Worksheets("Sheet1"):Cells(1,9) = "销售单".
    chExcel:Worksheets("Sheet1"):Cells(1,10) = "行".
    chExcel:Worksheets("Sheet1"):Cells(1,11) = "零件号".
    chExcel:Worksheets("Sheet1"):Cells(1,12) = "描述".
    chExcel:Worksheets("Sheet1"):Cells(1,13) = "生效日期".
    chExcel:Worksheets("Sheet1"):Cells(1,14) = "失效日期".
    chExcel:Worksheets("Sheet1"):Cells(1,15) = "上次累计日期".
    chExcel:Worksheets("Sheet1"):Cells(1,16) = "上次累计需求".
    chExcel:Worksheets("Sheet1"):Cells(1,17) = "上次ASN日期".
    chExcel:Worksheets("Sheet1"):Cells(1,18) = "上次ASN数量".
    DO i = 1 TO v_totalcol:
        chWorkSheet:COLUMNS(i + 18):NumberFormatLocal = "@".
        chExcel:Worksheets("Sheet1"):Cells(1, i + 18) = ENTRY(i, v_datelist).
    END.
    chWorksheet:COLUMNS:Font:SIZE = 10.

    /*detail*/
    iRowNum = 1.
    FOR EACH ttt2:
        iRowNum = iRowNum + 1.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,1) = ttt2_customer_code.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,2) = ttt2_customer_name.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,3) = ttt2_shipto_code.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,4) = ttt2_shipto_name.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,5) = ttt2_shipfr_code.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,6) = ttt2_releaseid.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,7) = ttt2_create_date.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,8) = ttt2_po_number.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,9) = ttt2_so_number.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,10) = ttt2_so_line.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,11) = ttt2_part_code.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,12) = ttt2_part_desc.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,13) = ttt2_eff_start.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,14) = ttt2_eff_end.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,15) = ttt2_pre_date.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,16) = ttt2_pre_qty.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,17) = ttt2_asn_date.
        chExcel:Worksheets("Sheet1"):Cells(iRowNum,18) = ttt2_asn_qty.

        FOR EACH ttt3 
            WHERE ttt3_customer_code = ttt2_customer_code
            AND   ttt3_releaseid     = ttt2_releaseid
            AND   ttt3_so_number     = ttt2_so_number
            AND   ttt3_so_line       = ttt2_so_line:
            chExcel:Worksheets("Sheet1"):Cells(iRowNum,ttt3_col) = ttt3_qty.
        END.
    END.

    /*chWorkSheet:range(ENTRY(i, ttt1_merge)):merge().*/
    i = /*18 + v_totalcol.*/ 26.
    ASSIGN 
    ColumnRange = CHR(65) + ":" + CHR(65 + i - 1).
    chExcel:COLUMNS(ColumnRange):SELECT.
    chExcel:SELECTION:COLUMNS:AUTOFIT().

    chExcel:DisplayAlerts = FALSE.
    chWorkbook:SaveAs(v-excelfile,, , ,,,).
    chWorkbook:CLOSE.
    chExcel:QUIT.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.

END PROCEDURE.

PROCEDURE xxpro-view-excel:
    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    CREATE "Excel.Application" chExcel.
    chExcel:VISIBLE = YES.
    chWorkbook = chExcel:Workbooks:Open(v-excelfile).
    chWorkSheet = chWorkbook:workSheets(1).

    MESSAGE "退出EXCEL，返回" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    /*chWorksheet:Printpreview.*/
    chWorkbook:CLOSE NO-ERROR.
    chExcel:QUIT. 

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.
END PROCEDURE.
