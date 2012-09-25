

/* DISPLAY TITLE */
{mfdtitle.i "f+"}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

DEF VAR v_ok         AS LOGICAL.
DEF VAR v_sys_status AS CHAR.
DEF VAR v_printername AS CHAR.

DEF VAR v_fexcel     AS CHAR.
DEF VAR v_fname      AS CHAR.
DEF VAR v_fname2     AS CHAR.


DEF VAR v_ponbr       LIKE po_nbr.
DEF VAR v_sonbr       LIKE so_nbr.
DEF VAR v_part1       LIKE pt_part.
DEF VAR v_part2       LIKE pt_part.
DEF VAR v_date       AS DATE.
DEF VAR v_ship_fr       LIKE si_site.
DEF VAR v_ship_to       LIKE scx_shipto.
DEF VAR v_sold_to       LIKE so_cust.
DEF VAR v_tot_amt   LIKE glt_amt.
DEF VAR v_curr  AS CHAR.
DEF VAR v_order_label AS CHAR.
DEF VAR v_polist  AS CHAR.
DEF VAR v_dt_prt AS DATE INITIAL TODAY.
DEF VAR v_rev    LIKE po_rev.
DEF VAR v_list_net AS LOGICAL INITIAL YES.
DEF VAR v_list_fp   AS CHAR INITIAL "".
DEF VAR v_list_zero AS LOGICAL INITIAL NO.
DEF VAR v_buyer    AS CHAR.
DEF VAR v_name     AS CHAR EXTENT 5.
DEF VAR v_noexport AS LOGICAL INITIAL YES.
DEF VAR v_releaseid LIKE schd_rlse_id.

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
    FIELDS xxwk2_err       AS LOGICAL        LABEL "错误"
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



/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_sonbr                          COLON 20
    v_sold_to                        COLON 20   v_name[1] NO-LABEL
    v_ship_to  LABEL "收货地点"      COLON 20   v_name[2] NO-LABEL
    v_ship_fr  LABEL "发货地点"      COLON 20   v_name[3] NO-LABEL
    SKIP(1)
    v_part1                          COLON 20
    v_part2                          COLON 50 LABEL "至"
    v_ponbr                          COLON 20
    v_releaseid                      COLON 20
    v_list_net  LABEL "显示净数量" COLON 20
    v_list_zero LABEL "显示0数量"     COLON 20
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


RUN xxpro-initial (OUTPUT v_sys_status).

REPEAT:
    VIEW FRAME a.

    RUN xxpro-input (OUTPUT v_sys_status).
    IF v_sys_status <> "0" THEN LEAVE.
    RUN xxpro-build (OUTPUT v_sys_status).
    FIND FIRST xxwk2 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk2 THEN DO:
        MESSAGE "无数据,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        NEXT.
    END.
    /*review*/ 
    {mfselprt.i "terminal" 80}
    RUN xxpro-report.
    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/

    /*save to excel*/
    v_fname = "".
    SYSTEM-DIALOG GET-FILE v_fname
            TITLE "请输入要保存文件的名称..."        
            FILTERS "Source Files (*.xls)"   "*.xls"       
            /*MUST-EXIST*/
            SAVE-AS
            USE-FILENAME
            UPDATE v_ok.
    IF v_ok = TRUE THEN DO:
            IF v_fname MATCHES ".xls" THEN v_fname = v_fname + ".xls".
            VIEW FRAME waitingframe.
            RUN xxpro-excel  (OUTPUT v_sys_status).
            HIDE FRAME waitingframe NO-PAUSE.
            MESSAGE "输出完毕，要预览吗" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
            IF choice = YES THEN DO:
                RUN xxpro-excel-view. 
            END.
    END.
    ELSE DO:
            MESSAGE "未指定文件名称,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END.


/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-input:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    
    IF v_part2 = hi_char THEN v_part2 = "".
    UPDATE 
        v_sonbr
        /*v_ship_fr
        v_ship_to
        v_sold_to*/
        v_part1
        v_part2
        v_ponbr
        v_releaseid
        v_list_net
        v_list_zero
    WITH FRAME a EDITING :

        if frame-field = "v_sonbr" then do:
            {mfnp05.i so_mstr so_nbr "yes = yes" so_nbr "INPUT v_sonbr"}
            if recno <> ? then DO:
                v_name = "".
                ASSIGN 
                    v_ship_fr = ""
                    v_ship_to = so_ship
                    v_sold_to = so_cust.
                FIND FIRST ad_mstr WHERE ad_addr = v_sold_to NO-LOCK NO-ERROR.
                IF AVAILABLE ad_mstr THEN v_name[1] = ad_name.
                FIND FIRST ad_mstr WHERE ad_addr = v_ship_to NO-LOCK NO-ERROR.
                IF AVAILABLE ad_mstr THEN v_name[2] = ad_name.
                FIND FIRST sod_det WHERE sod_nbr = so_nbr NO-LOCK NO-ERROR.
                IF AVAILABLE sod_det THEN DO:
                    ASSIGN v_ship_fr = sod_site.
                END.
                FIND FIRST ad_mstr WHERE ad_addr = v_ship_fr NO-LOCK NO-ERROR.
                IF AVAILABLE ad_mstr THEN v_name[3] = ad_name.

                DISPLAY 
                    so_nbr  @ v_sonbr
                    v_sold_to
                    v_ship_to
                    v_ship_fr
                    v_name[1]
                    v_name[2]
                    v_name[3]
                    WITH FRAME a.
            END.
        END.
        ELSE DO:
            status input.
            readkey.
            apply lastkey.
        END.
    END.

    
    FIND FIRST so_mstr WHERE so_nbr = v_sonbr AND so_sched = YES NO-LOCK NO-ERROR.
    IF NOT AVAILABLE so_mstr THEN DO:
        UNDO, RETRY.
    END.
    v_name = "".
    ASSIGN 
        v_ship_fr = ""
        v_ship_to = so_ship
        v_sold_to = so_cust.
    FIND FIRST ad_mstr WHERE ad_addr = v_sold_to NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN v_name[1] = ad_name.
    FIND FIRST ad_mstr WHERE ad_addr = v_ship_to NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN v_name[2] = ad_name.
    FIND FIRST sod_det WHERE sod_nbr = so_nbr NO-LOCK NO-ERROR.
    IF AVAILABLE sod_det THEN DO:
        ASSIGN v_ship_fr = sod_site.
    END.
    FIND FIRST ad_mstr WHERE ad_addr = v_ship_fr NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN v_name[3] = ad_name.

    DISPLAY 
        so_nbr  @ v_sonbr
        v_sold_to
        v_ship_to
        v_ship_fr
        v_name[1]
        v_name[2]
        v_name[3]
        WITH FRAME a.

    IF v_part2 = "" THEN v_part2 = hi_char.

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
        WITH FRAME f-a 2 COLUMNS width 200 STREAM-IO.

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
PROCEDURE xxpro-build:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    
    DEF VAR i AS INTEGER.
    DEF VAR v_net_qty LIKE tr_qty_loc.
    DEF VAR v_cum_qty LIKE tr_qty_loc.

    i = 0.
    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    FOR EACH xxwk3:
        DELETE xxwk3.
    END.

    
    FOR EACH so_mstr 
        WHERE (so_sched = YES)
        AND (so_nbr = v_sonbr)
        NO-LOCK:


        FOR EACH sod_det NO-LOCK 
            WHERE sod_nbr = so_nbr 
            AND sod_sched = YES
            AND (sod_part >= v_part1 AND sod_part <= v_part2)
            :
            IF v_releaseid <> "" THEN do:
                IF sod_curr_rlse_id[3] <> v_releaseid THEN NEXT.
            END.
            FIND FIRST scx_ref 
                where scx_type = 1
                and scx_order = sod_nbr 
                and scx_line = sod_line 
                AND (scx_po = v_ponbr OR v_ponbr = "")
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE scx_ref THEN do:
                NEXT.
            END.

            FOR each schd_det NO-LOCK 
                where schd_type = 3
                and schd_rlse_id = sod_curr_rlse_id[3] 
                and schd_nbr = sod_nbr 
                and schd_line = sod_line :


                IF v_list_net = YES THEN v_net_qty = max(min(schd_discr_qty, schd_cum_qty - sod_cum_qty[1]),0).
                ELSE v_net_qty = schd_discr_qty.

                IF v_list_zero = NO AND v_net_qty = 0 THEN NEXT.

                FIND FIRST xxwk2 WHERE xxwk2_order = so_nbr NO-ERROR.
                IF NOT AVAILABLE xxwk2 THEN DO:
                    CREATE xxwk2.
                    ASSIGN
                        xxwk2_order  = so_nbr
                        xxwk2_soldto = so_cust
                        xxwk2_shipfr = scx_shipfrom
                        xxwk2_shipto = scx_shipto
                        xxwk2_ponbr = scx_po
                        xxwk2_curr    = so_curr
                        xxwk2_fob     = so_fob
                        xxwk2_releaseid = schd_rlse_id.
                    xxwk2_name_fr = f-getaddata(xxwk2_shipfr, "Name").
                    xxwk2_name_to = f-getaddata(xxwk2_shipto, "Name").
                    xxwk2_name_sold = f-getaddata(xxwk2_soldto, "Name").

                END.
                FIND FIRST xxwk1 WHERE xxwk1_order = so_nbr 
                    AND xxwk1_line = sod_line
                    NO-ERROR.
                IF NOT AVAILABLE xxwk1 THEN DO:
                    CREATE xxwk1.
                    ASSIGN 
                        xxwk1_order = scx_order
                        xxwk1_line  = scx_line
                        xxwk1_part = scx_part
                        xxwk1_part_ref = sod_custpart
                        xxwk1_rlse_id = schd_rlse_id
                        xxwk1_iss_cumqty = sod_cum_qty[1]
                        xxwk1_ord_cumqty = schd_cum_qty
                        xxwk1_beg_cumdat = sod_start_eff[1]
                        xxwk1_end_cumdat = sod_end_eff[1]
                        xxwk1_fobpt      = so_fob
                        xxwk1_ponbr      = scx_po
                        xxwk1_rlse_id    = schd_rlse_id
                        .
                    xxwk1_org     = f-getpartdata(xxwk1_part, "pt__chr03").
                    xxwk1_desc = f-getpartdata(xxwk1_part, "pt_desc1").
                    xxwk1_mot  = f-getpartdata(xxwk1_part, "pt__chr04").
                    xxwk1_model     = f-getpartdata(xxwk1_part, "pt__chr01").
                    IF LOOKUP(xxwk1_ponbr, xxwk2_ponbr) = 0 THEN DO:
                        xxwk2_ponbr = xxwk2_ponbr + (IF xxwk2_ponbr = "" THEN "" ELSE ",") + xxwk1_ponbr.
                    END.
                    IF xxwk1_part_ref = "" THEN xxwk1_part_ref = xxwk1_part.
                END.
                CREATE xxwk3.
                ASSIGN
                    xxwk3_order =  so_nbr
                    xxwk3_line = sod_line
                    xxwk3_duedate  = schd_date
                    xxwk3_qty   = v_net_qty.
                /*IF schd_fc_qual = "F" THEN xxwk3_fp    = "YES".*/

                xxwk3_price = sod_price.
                xxwk3_amt = xxwk3_qty * xxwk3_price.

                ASSIGN xxwk2_amt = xxwk2_amt + xxwk3_amt.

            END.
        END.
    END.
    p_sys_status = "0".
END PROCEDURE.
/*-----------------------*/
PROCEDURE xxpro-excel-view:
    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    CREATE "Excel.Application" chExcel.
    chExcel:VISIBLE = YES.
    chWorkbook = chExcel:Workbooks:Open(v_fname).
    chWorkSheet = chWorkbook:workSheets(1).

    MESSAGE "关闭EXCEL，返回" VIEW-AS ALERT-BOX BUTTONS OK.  
    /* Perform housekeeping and cleanup steps */
    chExcel:Application:Workbooks:CLOSE() NO-ERROR.
    chExcel:Application:QUIT NO-ERROR.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-excel:
    
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.
    
    DEF VAR i   AS INTEGER.
    DEF VAR j   AS INTEGER.
    DEF VAR k   AS INTEGER.

    CREATE "Excel.Application" chExcel.
    
    chWorkbook =  chExcel:Workbooks:ADD().
    chExcel:visible = NO.
    k = 0.
    FOR EACH xxwk2 NO-LOCK:
        k = k + 1.
        chWorkSheet = chWorkbook:workSheets(k).
        chWorkSheet:NAME = xxwk2_ponbr.
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.

        /*header*/
        i = 1.
        chWorkbook:worksheets(K):cells(i,1):Font:SIZE = 16.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkSheet:range("A" + string(i) + ":" + "D" + STRING(i)):merge().
        chWorkbook:worksheets(K):cells(i,1):value = "客户日程单".

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "日期".
        chWorkbook:worksheets(K):cells(i,7):value = TODAY.

        i = 2.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "销售订单".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_order.

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "合同号".
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_ponbr.
        
        i = 3.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "发货地点".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_shipfr.
        chWorkbook:worksheets(K):cells(i,3):value = xxwk2_name_fr.

        i = 4.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "客户".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_soldto.
        chWorkbook:worksheets(K):cells(i,3):value = xxwk2_name_sold.
        
        i = 5.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "收货地点".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_shipto.
        chWorkbook:worksheets(K):cells(i,3):value = xxwk2_name_to.
        
        i = 6.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "日程版本".
        /*chWorkbook:worksheets(K):cells(i,2):value = xxwk2_releaseid.*/

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "FOB".
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_FOB.
        
        i = 7.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "起始日期".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_beg_dt.

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "结束日期".
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_end_dt.
        
        i = 8.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "币种".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_curr.

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "金额".
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_amt.

        /*body*/
        i = 9.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        DO j = 1 TO 10:
            chWorkbook:worksheets(K):cells(i,j):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(K):cells(i,j):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(K):cells(i,j):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(K):cells(i,j):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "零件".
        chWorkbook:worksheets(K):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,3):value = "描述".
        chWorkbook:worksheets(K):cells(i,5):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,5):value = "单价".
        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "数量".
        chWorkbook:worksheets(K):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,7):value = "金额".
        chWorkbook:worksheets(K):cells(i,8):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,8):value = "发运日期".
        chWorkbook:worksheets(K):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,9):value = "订单行号".
        chWorkbook:worksheets(K):cells(i,10):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,10):value = "客户零件号".

        FOR EACH xxwk1 NO-LOCK
            WHERE xxwk1_order = xxwk2_order BY xxwk1_part:
            FOR EACH xxwk3 NO-LOCK 
                WHERE xxwk3_order = xxwk1_order 
                AND xxwk3_line = xxwk1_line
                BY xxwk3_duedate:

                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().

                chWorkbook:worksheets(k):cells(i,1):value = xxwk1_part.
                chWorkbook:worksheets(k):cells(i,3):value = xxwk1_desc.
                chWorkbook:worksheets(k):cells(i,5):value = xxwk3_price.
                chWorkbook:worksheets(k):cells(i,6):value = xxwk3_qty.
                chWorkbook:worksheets(k):cells(i,7):value = xxwk3_amt.
                chWorkbook:worksheets(k):cells(i,8):value = xxwk3_duedate.
                chWorkbook:worksheets(k):cells(i,9):value = xxwk1_line.
                chWorkbook:worksheets(k):cells(i,10):value = xxwk1_part_ref.
            END.
        END.

        /*foot*/
        i = i + 1.
        DO j = 1 TO 10:
            chWorkbook:worksheets(K):cells(i,j):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(k):cells(i,6):value = "合计:".
        chWorkbook:worksheets(k):cells(i,7):value = xxwk2_amt.




    END. /*each wk2*/
    
    chExcel:DisplayAlerts = FALSE.
    chWorkbook:SaveAs(v_fname,, , ,,,).
    chWorkbook:CLOSE.
    chExcel:QUIT.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.

    p_sys_status = "0".
    
END PROCEDURE.


